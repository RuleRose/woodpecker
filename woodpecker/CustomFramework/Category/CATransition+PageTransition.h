//
//  CATransition+PageTransition.h
//  woodpecker
//
//  Created by QiWL on 2017/9/21.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CATransition (PageTransition)
+ (CATransition *)EaseInEaseOut:(id)delegate;

+ (CATransition *)revealFromBottom:(id)delegate;

+ (CATransition *)revealFromTop:(id)delegate;

+ (CATransition *)revealFromLeft:(id)delegate;

+ (CATransition *)revealFromRight:(id)delegate;

+ (CATransition *)pushFromRight:(id)delegate;

+ (CATransition *)pushFromLeft:(id)delegate;

+ (CATransition *)pushFromTop:(id)delegate;

+ (CATransition *)pushFromBottom:(id)delegate;

+ (CATransition *)moveInFromTop:(id)delegate;

+ (CATransition *)moveInFromBottom:(id)delegate;

+ (CATransition *)moveInFromLeft:(id)delegate;

+ (CATransition *)moveInFromRight:(id)delegate;

+ (CATransition *)fadeInFromTop:(id)delegate;

+ (CATransition *)fadeInFromBottom:(id)delegate;

+ (CATransition *)fadeInFromLeft:(id)delegate;

+ (CATransition *)fadeInFromRight:(id)delegate;
@end
