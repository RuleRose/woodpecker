//
//  UNICOrderResendManager.m
//  unicorn
//
//  Created by 肖君 on 17/3/4.
//  Copyright © 2017年 johnxiao. All rights reserved.
//

#import "UNICOrderResendManager.h"
#import "UNICCommonOrderModel.h"
#import "UNICCommonTemperatureModel.h"
#import "UNICNetworkAgent.h"

@interface UNICOrderResendManager ()
@property(nonatomic, strong) NSTimer *timerRetry;
@property(nonatomic, strong) NSMutableArray<UNICCommonOrderModel *> *sendOrderList;
@property(nonatomic, strong) NSMutableArray<UNICCommonOrderModel *> *receiveOrderList;
@property(nonatomic, strong) NSMutableArray<UNICCommonTemperatureModel *> *temperatureList;
@property(nonatomic, assign) BOOL isSendOrderChanged;  // use to refresh tablelist view
@property(nonatomic, assign) BOOL isReceiveOrderChanged;
@property(nonatomic, strong) UNICCommonOrderModel *receiveOrderToUpdate;
@property(nonatomic, assign) NSInteger postStartIndex;
@end

@implementation UNICOrderResendManager
Singleton_Implementation(UNICOrderResendManager);
- (NSTimer *)timerRetry {
    if (!_timerRetry) {
        _timerRetry = [NSTimer scheduledTimerWithTimeInterval:(60.0 * 5.0) target:self selector:@selector(retry) userInfo:nil repeats:YES];
    }
    return _timerRetry;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sendOrderList = [NSMutableArray array];
        _receiveOrderList = [NSMutableArray array];
        _temperatureList = [NSMutableArray array];
        _isSendOrderChanged = NO;
        _isReceiveOrderChanged = NO;
        _postStartIndex = 0;
    }
    return self;
}

- (void)startRetry {
    [self.timerRetry fire];
}

- (void)retry {
    [self retrySendOrder];
    [self retryReceiveOrder];
}

- (void)retrySendOrder {
    DDLogDebug(@"retrySendOrder");
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        UNICCommonOrderModel *orderToUpdate = nil;

        if ([self.sendOrderList count] > 0) {
            orderToUpdate = [self.sendOrderList lastObject];
        } else {
            UNICCommonOrderModel *orderCondition = [[UNICCommonOrderModel alloc] init];
            orderCondition.order_type = 1;
            orderCondition.is_uploaded = 2;
            [self.sendOrderList addObjectsFromArray:[UNICDBManager searchModelsWithCondition:orderCondition andpage:-1 andOrderby:nil isAscend:NO]];
            if ([self.sendOrderList count] > 0) {
                orderToUpdate = [self.sendOrderList lastObject];
            }
        }

        if (orderToUpdate) {
            @weakify(self);
            [[UNICNetworkAgent defaultInstance]
                registerOrderWithMac:orderToUpdate.mac
                          expressNum:orderToUpdate.number
                           hightTemp:orderToUpdate.high_temp
                             lowTemp:orderToUpdate.low_temp
                           startTime:orderToUpdate.start_time
                             endTime:nil
                               state:1
                            callback:^(NSError *error, NSDictionary *dic) {
                              @strongify(self);
                              if (!error) {
                                  orderToUpdate.order_id = [[dic leie_getObjectByPath:@"order_id"] integerValue];
                                  orderToUpdate.create_time = [[NSDate date] displayStringOfDate];
                                  orderToUpdate.is_uploaded = 1;
                                  [orderToUpdate updateToDBDependsOn:@[ @"mac", @"number", @"order_type" ]];
                                  [self.sendOrderList removeLastObject];
                                  self.isSendOrderChanged = YES;
                                  [self retrySendOrder];
                              } else {
                                  //提交不成功，等待下次timer到时间。
                                  [self.sendOrderList removeAllObjects];
                                  if (self.isSendOrderChanged) {
                                      self.isSendOrderChanged = NO;
                                      [[NSNotificationCenter defaultCenter] postNotificationName:UNICNotificationKeySendOrderListChanged object:self];
                                  }
                              }
                            }];
        } else {
            if (self.isSendOrderChanged) {
                self.isSendOrderChanged = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:UNICNotificationKeySendOrderListChanged object:self];
            }
            [self.sendOrderList removeAllObjects];
        }
    }
}

- (void)retryReceiveOrder {
    DDLogDebug(@"retryReceiveOrder");
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        UNICCommonOrderModel *orderToUpdate = nil;

        if ([self.receiveOrderList count] > 0) {
            orderToUpdate = [self.receiveOrderList lastObject];
        } else {
            UNICCommonOrderModel *orderCondition = [[UNICCommonOrderModel alloc] init];
            orderCondition.order_type = 2;
            orderCondition.is_uploaded = 2;
            [self.receiveOrderList addObjectsFromArray:[UNICDBManager searchModelsWithCondition:orderCondition andpage:-1 andOrderby:nil isAscend:NO]];
            if ([self.receiveOrderList count] > 0) {
                orderToUpdate = [self.receiveOrderList lastObject];
            }
        }

        if (orderToUpdate) {
            @weakify(self);
            if (NON_OBJECT_DEFAULT_VALUE == orderToUpdate.order_id) {
                [[UNICNetworkAgent defaultInstance] registerOrderWithMac:orderToUpdate.mac
                                                              expressNum:orderToUpdate.number
                                                               hightTemp:orderToUpdate.high_temp
                                                                 lowTemp:orderToUpdate.low_temp
                                                               startTime:orderToUpdate.start_time
                                                                 endTime:orderToUpdate.end_time
                                                                   state:2
                                                                callback:^(NSError *error, NSDictionary *dic) {
                                                                  @strongify(self);
                                                                  if (!error) {
                                                                      orderToUpdate.order_id = [[dic leie_getObjectByPath:@"order_id"] integerValue];
                                                                      orderToUpdate.is_uploaded = 1;
                                                                      [orderToUpdate updateToDBDependsOn:nil];
                                                                      [self.receiveOrderList removeLastObject];
                                                                      [self retryReceiveOrder];
                                                                      return;
                                                                  } else {
                                                                      [self.receiveOrderList removeAllObjects];
                                                                      return;
                                                                  }
                                                                }];
            } else {
                [[UNICNetworkAgent defaultInstance] updateOrderWithID:orderToUpdate.order_id
                                                            hightTemp:orderToUpdate.high_temp
                                                              lowTemp:orderToUpdate.low_temp
                                                            startTime:orderToUpdate.start_time
                                                              endTime:orderToUpdate.end_time
                                                             callback:^(NSError *error, NSDictionary *dic) {
                                                               @strongify(self);
                                                               if (!error) {
                                                                   orderToUpdate.is_uploaded = 1;
                                                                   [orderToUpdate updateToDBDependsOn:nil];
                                                                   [self.receiveOrderList removeLastObject];
                                                                   [self retryReceiveOrder];
                                                                   return;
                                                               } else {
                                                                   [self.receiveOrderList removeAllObjects];
                                                                   return;
                                                               }
                                                             }];
            }
        } else {
            [self.receiveOrderList removeAllObjects];
            [self retryTemperatureData];
        }
    }
}

- (void)retryTemperatureData {
    DDLogDebug(@"retryTemperatureData");
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        self.receiveOrderToUpdate = nil;

        if ([self.receiveOrderList count] > 0) {
            self.receiveOrderToUpdate = [self.receiveOrderList lastObject];
        } else {
            UNICCommonOrderModel *orderCondition = [[UNICCommonOrderModel alloc] init];
            orderCondition.order_type = 2;
            orderCondition.is_temperature_uploaded = 2;
            [self.receiveOrderList addObjectsFromArray:[UNICDBManager searchModelsWithCondition:orderCondition andpage:-1 andOrderby:nil isAscend:NO]];
            if ([self.receiveOrderList count] > 0) {
                self.receiveOrderToUpdate = [self.receiveOrderList lastObject];
            }
        }

        if (self.receiveOrderToUpdate) {
            UNICCommonTemperatureModel *temperatureModel = [[UNICCommonTemperatureModel alloc] init];
            temperatureModel.order_pid = self.receiveOrderToUpdate.pid;
            self.temperatureList =
                [NSMutableArray arrayWithArray:[UNICDBManager searchModelsWithCondition:temperatureModel andpage:-1 andOrderby:nil isAscend:NO]];
            [self sendTemperature];
        } else {
            if (self.isReceiveOrderChanged) {
                self.isReceiveOrderChanged = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:UNICNotificationKeyReceiveOrderListChanged object:self];
            }
            [self.receiveOrderList removeAllObjects];
        }
    }
}

- (void)sendTemperature {
    NSInteger totalCount = self.temperatureList.count;
    if (self.postStartIndex > totalCount) {
        self.receiveOrderToUpdate.is_temperature_uploaded = 1;
        [self reUpdateOrder:self.receiveOrderToUpdate];
        [self.receiveOrderToUpdate updateToDBDependsOn:nil];
        [self.receiveOrderList removeLastObject];
        self.postStartIndex = 0;
        self.isReceiveOrderChanged = YES;
        [self retryTemperatureData];
        return;
    }
    DDLogDebug(@"Post index from %ld", self.postStartIndex);

    NSArray<UNICCommonTemperatureModel *> *postList;
    if ((self.postStartIndex + 5000) >= totalCount) {
        postList = [self.temperatureList subarrayWithRange:NSMakeRange(self.postStartIndex, totalCount - self.postStartIndex)];
    } else {
        postList = [self.temperatureList subarrayWithRange:NSMakeRange(self.postStartIndex, 5000)];
    }
    self.postStartIndex += 5000;

    DDLogDebug(@"Post index from %ld to %ld", [postList firstObject].seq_no, [postList lastObject].seq_no);

    @weakify(self);
    [[UNICNetworkAgent defaultInstance] postTemperature:postList
                                                    mac:self.receiveOrderToUpdate.mac
                                               callback:^(NSError *error, NSDictionary *dic) {
                                                 @strongify(self);
                                                 if (!error) {
                                                     [self sendTemperature];
                                                 }
                                               }];
}

- (void)reUpdateOrder:(UNICCommonOrderModel *)order {
    if (NON_OBJECT_DEFAULT_VALUE != order.order_id) {
        [[UNICNetworkAgent defaultInstance] updateOrderWithID:order
                                                     callback:^(NSError *error, NSDictionary *dic){

                                                     }];
    }
}
@end
