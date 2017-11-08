//
//  WPConnectDeviceManager.m
//  woodpecker
//
//  Created by QiWL on 2017/10/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPConnectDeviceManager.h"
#import "MMCDeviceManager.h"
#import "WPDeviceModel.h"

@interface WPConnectDeviceManager ()
@property(nonatomic, strong)NSTimer *timer;
@end

@implementation WPConnectDeviceManager
Singleton_Implementation(WPConnectDeviceManager);
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)startTimer {
    WPDeviceModel *device = [[WPDeviceModel alloc] init];
    NSDictionary *deviceDic = kDefaultObjectForKey(USER_DEFAULT_DEVICE);
    [device loadDataFromkeyValues:deviceDic];
    if (![NSString leie_isBlankString:device.mac_addr] && [MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_NONE) {
        if (self.timer)
            [self stopTimer];
        self.timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(connectDevice) userInfo:nil repeats:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timer fire];
        });
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)connectDevice{
    WPDeviceModel *device = [[WPDeviceModel alloc] init];
    NSDictionary *deviceDic = kDefaultObjectForKey(USER_DEFAULT_DEVICE);
    [device loadDataFromkeyValues:deviceDic];
    if (![NSString leie_isBlankString:device.mac_addr]) {
        [[MMCDeviceManager defaultInstance] startScanAndConnectWithMac:device.mac_addr callback:^(NSInteger sendState) {
            
        }];
    }
}
@end
