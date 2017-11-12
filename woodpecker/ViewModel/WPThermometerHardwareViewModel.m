//
//  WPThermometerHardwareViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerHardwareViewModel.h"

@implementation WPThermometerHardwareViewModel
- (UIImage *)mapRssi:(NSInteger)RSSI{
    NSInteger r = -RSSI;
    if (r <= 100 && r > 90) {
        return [UIImage imageNamed:@"icon-settings-signal-1"];
    }else if (r <=90 && r > 80){
        return [UIImage imageNamed:@"icon-settings-signal-2"];
    }else if (r <=80 && r > 70){
        return [UIImage imageNamed:@"icon-settings-signal-3"];
    }else if (r <=70){
        return [UIImage imageNamed:@"icon-settings-signal-4"];
    }else{
        return [UIImage imageNamed:@"icon-settings-signal-0"];
    }
}
@end
