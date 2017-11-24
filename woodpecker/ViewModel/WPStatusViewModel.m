//
//  WPStatusViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPStatusViewModel.h"
#import "WPNetInterface.h"
#import "MMCDeviceManager.h"
#import "WPDeviceModel.h"
#import "XJFDBManager.h"
#import "WPTemperatureModel.h"
#import "XJFDBManager.h"
#import "WPEventItemModel.h"
#import "NSString+JSON.h"

@implementation WPStatusViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _temps = [[NSMutableArray alloc] init];
        _isBindNewDevice = NO;
    }
    return self;
}

- (void)bindDevice{
    //去绑定
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    NSString *softwareRev = [MMCDeviceManager defaultInstance].currentDevice.softwareRev;
    NSString *hardwareRev = [MMCDeviceManager defaultInstance].currentDevice.hardwareRev;
    NSString *modelNum = [MMCDeviceManager defaultInstance].currentDevice.modelNum;
    NSString *MacAddr = [MMCDeviceManager defaultInstance].currentDevice.MacAddr;
    [WPNetInterface registerDevice:MacAddr num:modelNum software_rev:softwareRev hardware_rev:hardwareRev success:^(NSString *device_id) {
        @weakify(self);
        [WPNetInterface bindDevice:user.user_id device_id:device_id start_dindex:@"0" success:^(BOOL bind) {
            @strongify(self);
            self.isBindNewDevice = YES;
            user.device_id = device_id;
            kDefaultSetObjectForKey([user transToDictionary], USER_DEFAULT_ACCOUNT_USER);
            WPDeviceModel *device = [[WPDeviceModel alloc] init];
            device.device_id = device_id;
            device.mac_addr = softwareRev;
            device.hardware_rev = hardwareRev;
            device.model_num = modelNum;
            kDefaultSetObjectForKey([device transToDictionary], USER_DEFAULT_DEVICE);
            [self syncTempData];
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        
    }];
}

- (void)syncTempDataFromIndex:(NSInteger)index{
    //连接成功后，马上同步数据会失败，需要时间发现服务和属性
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MMCDeviceManager defaultInstance] syncDataFromIndex:index callback:^(NSInteger sendState) {
            
        }];
    });
}

- (void)syncTempData{
    NSNumber *getTemp = kDefaultObjectForKey(TEMPERATURE_DEFAULT_GETTEMP);
    if ([getTemp boolValue]) {
        WPUserModel *user = [[WPUserModel alloc] init];
        [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
        if (self.isBindNewDevice) {
            WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
            temp.device = @"1";
            NSArray *arr = [XJFDBManager searchModelsWithCondition:temp andpage:0 andOrderby:@"time" isAscend:NO];
            temp = arr.firstObject;
            if (temp) {
                self.syncFromTime = temp.time;
            }else{
                self.syncFromTime = nil;
            }
            [self syncTempDataFromIndex:0];
            self.isBindNewDevice = NO;
        }else{
            if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_CONNECTED) {
                //获取该设备最后一条本地温度信息dindex
                WPUserModel *user = [[WPUserModel alloc] init];
                [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
                if (![NSString leie_isBlankString:user.device_id]) {
                    WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
                    temp.device_id = user.device_id;
                    NSArray *arr = [XJFDBManager searchModelsWithCondition:temp andpage:0 andOrderby:@"time" isAscend:NO];
                    temp = arr.firstObject;
                    if (temp) {
                        [self syncTempDataFromIndex:[temp.dindex integerValue]];
                    }else{
                        [self syncTempDataFromIndex:0];
                    }
                }
            }
        }
        
    }
}

- (void)syncDeviceTempDataAfterBinding{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
    temp.device = @"1";
    NSArray *arr = [XJFDBManager searchModelsWithCondition:temp andpage:0 andOrderby:@"time" isAscend:NO];
    temp = arr.firstObject;
    if (temp) {
        self.syncFromTime = temp.time;
    }else{
        self.syncFromTime = nil;
    }
    

    [self syncTempDataFromIndex:0];
}

- (void)syncTempDataToService{
    WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
    temp.sync = @"0";
    NSArray *temps = [XJFDBManager searchModelsWithCondition:temp andpage:-1 andOrderby:nil isAscend:YES];
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    [WPNetInterface postTemps:temps user_id:user.user_id success:^(NSArray *temperatures) {
        for (NSDictionary *tempDic in temperatures) {
            WPTemperatureModel *temperature = [[WPTemperatureModel alloc] init];
            [temperature loadDataFromkeyValues:tempDic];
            temperature.sync = @"1";
            [self insertTemperature:temp];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)insertTemperature:(WPTemperatureModel *)temp{
    NSDate *date = [NSDate dateFromUTCString:temp.time format:DATE_FORMATE_SEC_STRING];
    if (date) {
        NSTimeInterval time = [date timeIntervalSince2000];
        if (time >= 0) {
            WPTemperatureModel *temperature = [[WPTemperatureModel alloc] init];
            temperature.date = [NSDate stringFromDate:date format:DATE_FORMATE_STRING];
            NSArray *tempsArr = [XJFDBManager searchModelsWithCondition:temperature andpage:-1 andOrderby:@"time" isAscend:NO];
            WPTemperatureModel *localTemp = tempsArr.firstObject;
            temp.date = temperature.date;
            temp.time = [NSString stringWithFormat:@"%f",time] ;
            if (localTemp) {
                [XJFDBManager deleteModel:localTemp dependOnKeys:nil];
                [temp insertToDB];
            }else{
                //插入当前时间
                [temp insertToDB];
            }
        }
    }
}


- (NSDate *)getStartDate{
    WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
    NSArray *temps = [XJFDBManager searchModelsWithCondition:temp andpage:0 andOrderby:@"time" isAscend:YES];
    WPTemperatureModel *startTemp = temps.firstObject;
    NSDate *date = [NSDate dateWithTimeIntervalSince2000:[startTemp.time longLongValue]];
    if (startTemp) {
        return [NSDate dateFromString:[NSDate stringFromDate:date] format:DATE_FORMATE_STRING];
    }
    return nil;
}

- (NSInteger)eventCountAtDate:(NSDate *)date withDayInfor:(WPDayInfoInPeriod *)dayInfo{
    WPEventItemModel *event =[[WPEventItemModel alloc] init];
    event.date = [NSDate stringFromDate:date format:DATE_FORMATE_STRING];
    NSArray *events = [XJFDBManager searchModelsWithCondition:event andpage:-1 andOrderby:nil isAscend:YES];
    NSInteger count = 0;
    if (dayInfo.type == kPeriodTypeOfMenstrual) {
        if ((!dayInfo.isForecast && dayInfo.isStart) || (!dayInfo.isEndDayForecast && dayInfo.isEnd)) {
            count ++;
        }
    }
    for (WPEventItemModel *item in events) {
        if (dayInfo.type != kPeriodTypeOfMenstrual) {
            if ([item.type isEqualToString:@"1"]
                || [item.type isEqualToString:@"2"]) {
                continue;
            }
        }
        NSDictionary *breifDic =[NSString getDictionary:item.brief];
        for (NSString *value in breifDic.allValues) {
            if (![NSString leie_isBlankString:value]) {
                count ++;
            }
        }
    }
    return count;
}

- (WPTemperatureModel *)getTempWithDate:(NSDate *)date{
    if (date) {
        WPTemperatureModel *temperature = [[WPTemperatureModel alloc] init];
        temperature.date = [NSDate stringFromDate:date format:DATE_FORMATE_STRING];
        NSArray *tempsArr = [XJFDBManager searchModelsWithCondition:temperature andpage:-1 andOrderby:@"time" isAscend:NO];
        return tempsArr.firstObject;
    }
    return nil;
}

- (void)insertTemperature:(NSNumber *)temp index:(NSNumber *)index time:(NSNumber *)time{
    if (time && temp && index) {
        if ([time stringValue].length == 9) {
            NSDate *date = [NSDate dateWithTimeIntervalSince2000:[time longLongValue]];
            if (date) {
                WPDeviceModel *device = [[WPDeviceModel alloc] init];
                [device loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_DEVICE)];
                WPTemperatureModel *temperature = [[WPTemperatureModel alloc] init];
                temperature.date = [NSDate stringFromDate:date format:DATE_FORMATE_STRING];
                NSArray *tempsArr = [XJFDBManager searchModelsWithCondition:temperature andpage:-1 andOrderby:@"time" isAscend:NO];
                WPTemperatureModel *localTemp = tempsArr.firstObject;
                temperature.dindex = [index stringValue];
                temperature.device_id = device.device_id;
                temperature.time = [time stringValue];
                temperature.pid = temperature.time;
                temperature.temp = [NSString stringWithFormat:@"%0.2f",([temp integerValue]/100.0)];
                temperature.device = @"1";
                temperature.sync = @"0";
                if (localTemp) {
                    if ([time longLongValue] >= [localTemp.time longLongValue]) {
                        //替换当前记录
                        [XJFDBManager deleteModel:localTemp dependOnKeys:nil];
                        [temperature insertToDB];
                    }
                }else{
                    //插入当前时间
                    [temperature insertToDB];
                }
            }
        }
    }
}

- (NSMutableArray *)getPeriods{
    WPProfileModel *profile = [[WPProfileModel alloc] init];
    [profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
    WPPeriodModel *period = [[WPPeriodModel alloc] init];
    NSArray *periods = [XJFDBManager searchModelsWithCondition:period andpage:-1 andOrderby:@"period_start" isAscend:YES];
    NSMutableArray *allPeriods = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < periods.count; i ++) {
        WPPeriodModel *peirod = periods[i];
        NSDate *date = [NSDate dateFromString:peirod.period_start format:DATE_FORMATE_STRING];
        NSDate *nextDate = [NSDate date];
        if (periods.count > i +1) {
            //后面就还有数据
            WPPeriodModel *peirod_next = periods[i + 1];
            nextDate = [NSDate dateFromString:peirod_next.period_start format:DATE_FORMATE_STRING];
        }
        [allPeriods addObject:peirod];
        NSInteger days = [NSDate daysFromDate:date toDate:nextDate];
        while (days > [profile.period integerValue]) {
            NSDate *addDate = [NSDate dateByAddingDays:[profile.period integerValue] toDate:nextDate];
            WPPeriodModel *add_peirod = [[WPPeriodModel alloc] init];
            add_peirod.period_start = [NSDate stringFromDate:addDate];
            add_peirod.speculate = YES;
            [allPeriods addObject:add_peirod];
            days -=  [profile.period integerValue];
        }
    }
    WPPeriodModel *next_period;
    for (NSInteger i = allPeriods.count - 1; i >= 0; i --) {
        WPPeriodModel *period = [allPeriods objectAtIndex:i];
        NSDate *startDate;
        NSDate *endDate;
        if (![NSString leie_isBlankString:period.period_start]) {
            startDate = [NSDate dateFromString:period.period_start format:DATE_FORMATE_STRING];
        }
        if (![NSString leie_isBlankString:period.period_end]) {
            endDate = [NSDate dateFromString:period.period_end format:DATE_FORMATE_STRING];
        }
        NSInteger menstruation_lenth = [profile.menstruation integerValue];
        if (endDate) {
            menstruation_lenth = [NSDate daysFromDate:startDate toDate:endDate];
        }
        NSInteger period_lenth = [profile.period integerValue];
        if (next_period) {
            NSDate *nextStartDate;
            if (![NSString leie_isBlankString:next_period.period_start]) {
                nextStartDate = [NSDate dateFromString:next_period.period_start format:DATE_FORMATE_STRING];
            }
            period_lenth = [NSDate daysFromDate:startDate toDate:nextStartDate];
        }
        period.menstruation_lenth = menstruation_lenth;
        period.period_lenth  = period_lenth;
        period.oviposit = period_lenth - 14;
        period.pregnancy_start = period.oviposit - 5;
        period.pregnancy_end = period.oviposit + 4;
        next_period = period;
    }
    return allPeriods;
}
@end
