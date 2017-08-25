//
//  UNICNetworkAgent.h
//  unicorn
//
//  Created by 肖君 on 16/12/9.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "BaseModel.h"
#import "UNICCommonOrderModel.h"
#import "UNICCommonTemperatureModel.h"

@interface UNICNetworkAgent : BaseModel
Singleton_Interface(UNICNetworkAgent);

- (void)getExpressInfo:(NSString *)expressNum callback:(void (^)(NSError *error, NSDictionary *dic))callback;

- (void)getOrderByMac:(NSString *)mac callback:(void (^)(NSError *error, NSDictionary *dic))callback;

- (void)getOrderByExpressNumb:(NSString *)expressNum callback:(void (^)(NSError *error, NSDictionary *dic))callback;

- (void)getOrderByMac:(NSString *)mac expressNum:(NSString *)expressNum callback:(void (^)(NSError *error, NSDictionary *dic))callback;

- (void)updateOrderWithID:(NSInteger)orderID
                hightTemp:(CGFloat)highTemp
                  lowTemp:(CGFloat)lowTemp
                startTime:(NSString *)startTime
                  endTime:(NSString *)endTime
                 callback:(void (^)(NSError *error, NSDictionary *dic))callback;

// orderID 是查询条件，其他属性是更新值。
- (void)updateOrderWithID:(UNICCommonOrderModel *)orderInfo callback:(void (^)(NSError *error, NSDictionary *dic))callback;

//发货时，endTime可以为nil。
- (void)registerOrderWithMac:(NSString *)mac
                  expressNum:(NSString *)expressNum
                   hightTemp:(CGFloat)highTemp
                     lowTemp:(CGFloat)lowTemp
                   startTime:(NSString *)startTime
                     endTime:(NSString *)endTime
                       state:(NSInteger)state
                    callback:(void (^)(NSError *error, NSDictionary *dic))callback;

- (void)getServerTime:(void (^)(NSError *error, NSDictionary *dic))callback;

- (void)postTemperature:(NSArray<UNICCommonTemperatureModel *> *)temperatureList
                    mac:(NSString *)mac
               callback:(void (^)(NSError *error, NSDictionary *dic))callback;

@end
