//
//  UNICNetworkAgent.m
//  unicorn
//
//  Created by 肖君 on 16/12/9.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "UNICNetworkAgent.h"
#import "UNICNetworkManager.h"
#import "UNICServerTime.h"

@implementation UNICNetworkAgent
Singleton_Implementation(UNICNetworkAgent);

- (void)getExpressInfo:(NSString *)expressNum callback:(void (^)(NSError *error, NSDictionary *dic))callback {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:expressNum forKey:@"number"];

    [[UNICNetworkManager shareManager] requestWithPath:NETWORK_EXPRESS
                                         requestParams:params
                                         networkMethod:POST
                                              callback:^(id data, NSError *error) {
                                                if (!error) {
                                                    callback(nil, data);
                                                } else {
                                                    callback(error, nil);
                                                }
                                              }];
}

- (void)getOrderByMac:(NSString *)mac callback:(void (^)(NSError *error, NSDictionary *dic))callback {
    mac = [UNICHelper serverMac:mac];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mac forKey:@"mac"];
    [params setObject:@1 forKey:@"status"];

    [self getOrder:params callback:callback];
}

- (void)getOrderByExpressNumb:(NSString *)expressNum callback:(void (^)(NSError *error, NSDictionary *dic))callback {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:expressNum forKey:@"number"];
    [params setObject:@1 forKey:@"status"];

    [self getOrder:params callback:callback];
}

- (void)getOrderByMac:(NSString *)mac expressNum:(NSString *)expressNum callback:(void (^)(NSError *error, NSDictionary *dic))callback;
{
    mac = [UNICHelper serverMac:mac];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mac forKey:@"mac"];
    [params setObject:expressNum forKey:@"number"];

    [self getOrder:params callback:callback];
}

- (void)getOrder:(NSDictionary *)params callback:(void (^)(NSError *error, NSDictionary *dic))callback {
    [[UNICNetworkManager shareManager] requestWithPath:NETWORK_ORDER
                                         requestParams:params
                                         networkMethod:POST
                                              callback:^(id data, NSError *error) {
                                                if (!error) {
                                                    callback(nil, data);
                                                } else {
                                                    callback(error, data);
                                                }
                                              }];
}

- (void)updateOrderWithID:(NSInteger)orderID
                hightTemp:(CGFloat)highTemp
                  lowTemp:(CGFloat)lowTemp
                startTime:(NSString *)startTime
                  endTime:(NSString *)endTime
                 callback:(void (^)(NSError *error, NSDictionary *dic))callback {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:orderID] forKey:@"order_id"];
    [params setObject:[NSNumber numberWithFloat:highTemp] forKey:@"high_temp"];
    [params setObject:[NSNumber numberWithFloat:lowTemp] forKey:@"low_temp"];
    if (startTime) {
        [params setObject:[[UNICServerTime defaultInstance] serverStringFromDisplayString:startTime] forKey:@"start_time"];
    }
    if (endTime) {
        [params setObject:[[UNICServerTime defaultInstance] serverStringFromDisplayString:endTime] forKey:@"end_time"];
    }
    [params setObject:@2 forKey:@"status"];

    [[UNICNetworkManager shareManager] requestWithPath:NETWORK_ORDER_UPDATE
                                         requestParams:params
                                         networkMethod:POST
                                              callback:^(id data, NSError *error) {
                                                if (!error) {
                                                    callback(nil, data);
                                                } else {
                                                    callback(error, nil);
                                                }
                                              }];
}

- (void)updateOrderWithID:(UNICCommonOrderModel *)orderInfo callback:(void (^)(NSError *error, NSDictionary *dic))callback {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:[NSNumber numberWithInteger:orderInfo.order_id] forKey:@"order_id"];
    if (orderInfo.mac) {
        [params setObject:orderInfo.mac forKey:@"mac"];
    }

    if (orderInfo.number) {
        [params setObject:orderInfo.number forKey:@"number"];
    }

    if (orderInfo.start_time) {
        [params setObject:[[UNICServerTime defaultInstance] serverStringFromDisplayString:orderInfo.start_time] forKey:@"start_time"];
    }

    if (orderInfo.end_time) {
        [params setObject:[[UNICServerTime defaultInstance] serverStringFromDisplayString:orderInfo.end_time] forKey:@"end_time"];
    }

    if (NON_OBJECT_DEFAULT_VALUE != orderInfo.high_temp) {
        [params setObject:[NSNumber numberWithInteger:orderInfo.high_temp] forKey:@"high_temp"];
    }

    if (NON_OBJECT_DEFAULT_VALUE != orderInfo.low_temp) {
        [params setObject:[NSNumber numberWithInteger:orderInfo.low_temp] forKey:@"low_temp"];
    }

    [[UNICNetworkManager shareManager] requestWithPath:NETWORK_ORDER_UPDATE
                                         requestParams:params
                                         networkMethod:POST
                                              callback:^(id data, NSError *error) {
                                                if (!error) {
                                                    callback(nil, data);
                                                } else {
                                                    callback(error, nil);
                                                }
                                              }];
}

- (void)registerOrderWithMac:(NSString *)mac
                  expressNum:(NSString *)expressNum
                   hightTemp:(CGFloat)highTemp
                     lowTemp:(CGFloat)lowTemp
                   startTime:(NSString *)startTime
                     endTime:(NSString *)endTime
                       state:(NSInteger)state
                    callback:(void (^)(NSError *error, NSDictionary *dic))callback {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mac forKey:@"mac"];
    [params setObject:expressNum forKey:@"number"];
    [params setObject:[NSNumber numberWithFloat:highTemp] forKey:@"high_temp"];
    [params setObject:[NSNumber numberWithFloat:lowTemp] forKey:@"low_temp"];
    [params setObject:[[UNICServerTime defaultInstance] serverStringFromDisplayString:startTime] forKey:@"start_time"];
    if (endTime) {
        [params setObject:[[UNICServerTime defaultInstance] serverStringFromDisplayString:endTime] forKey:@"end_time"];
    }
    [params setObject:[NSNumber numberWithInteger:state] forKey:@"status"];

    [[UNICNetworkManager shareManager] requestWithPath:NETWORK_ORDER_REGISTER
                                         requestParams:params
                                         networkMethod:POST
                                              callback:^(id data, NSError *error) {
                                                if (!error) {
                                                    callback(nil, data);
                                                } else {
                                                    callback(error, nil);
                                                }
                                              }];
}

- (void)getServerTime:(void (^)(NSError *error, NSDictionary *dic))callback {
    [[UNICNetworkManager shareManager] requestWithPath:NETWORK_SERVER_TIME
                                         requestParams:nil
                                         networkMethod:GET
                                              callback:^(id data, NSError *error) {
                                                if (!error) {
                                                    callback(nil, data);
                                                } else {
                                                    callback(error, nil);
                                                }
                                              }];
}

- (void)postTemperature:(NSArray<UNICCommonTemperatureModel *> *)temperatureList
                    mac:(NSString *)mac
               callback:(void (^)(NSError *error, NSDictionary *dic))callback {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray<UNICCommonTemperatureModel *> *dataList = [NSMutableArray array];

    for (UNICCommonTemperatureModel *temperaturePoint in temperatureList) {
        UNICCommonTemperatureModel *temperature = [[UNICCommonTemperatureModel alloc] init];
        temperature.order_id = temperaturePoint.order_id;
        temperature.seq_no = temperaturePoint.seq_no;
        temperature.temperature = temperaturePoint.temperature;
        temperature.time = [[UNICServerTime defaultInstance] serverStringFromDisplayString:temperaturePoint.time];
        [dataList addObject:temperature];
    }

    [params setObject:[UNICCommonTemperatureModel mj_keyValuesArrayWithObjectArray:dataList ignoredKeys:@[ @"order_id", @"pid" ]] forKey:@"temperatures"];
    [params setObject:mac forKey:@"mac"];

    [[UNICNetworkManager shareManager] requestWithPath:NETWORK_TEMPERATURE_POST
                                         requestParams:params
                                         networkMethod:POST
                                              callback:^(id data, NSError *error) {
                                                if (!error) {
                                                    callback(nil, data);
                                                } else {
                                                    callback(error, nil);
                                                }
                                              }];
}
@end
