//
//  WPConnectDeviceManager.m
//  woodpecker
//
//  Created by QiWL on 2017/10/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPConnectDeviceManager.h"
#import "MMCDeviceManager.h"

@interface WPConnectDeviceManager ()
@property(nonatomic, strong)NSTimer *timer;
@end

@implementation WPConnectDeviceManager
Singleton_Implementation(WPConnectDeviceManager);
- (instancetype)init {
    self = [super init];
    if (self) {
        _device = [[WPDeviceModel alloc] init];
    }
    return self;
}

- (void)startTimer {
    NSDictionary *deviceDic = kDefaultObjectForKey(USER_DEFAULT_DEVICE);
    [_device loadDataFromkeyValues:deviceDic];
    if (![NSString leie_isBlankString:_device.mac_addr] && [MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_NONE) {
        if (self.timer) [self stopTimer];
        self.timer = [NSTimer timerWithTimeInterval:60*5 target:self selector:@selector(connectDevice) userInfo:nil repeats:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timer fire];
        });
//        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)connectDevice{
    NSDictionary *deviceDic = kDefaultObjectForKey(USER_DEFAULT_DEVICE);
    [_device loadDataFromkeyValues:deviceDic];
    if (![NSString leie_isBlankString:_device.mac_addr]) {
        [[MMCDeviceManager defaultInstance] startScanAndConnectWithMac:_device.mac_addr callback:^(NSInteger sendState) {
            
        }];
    }
}
@end