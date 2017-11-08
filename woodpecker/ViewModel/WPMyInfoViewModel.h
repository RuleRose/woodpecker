//
//  WPMyInfoViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPMyInfoViewModel : NSObject
- (void)uploadAvatar:(UIImage *)avatar success:(void (^)(BOOL finished))result;
@end
