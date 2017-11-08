//
//  CATransition+PageTransition.m
//  woodpecker
//
//  Created by QiWL on 2017/9/21.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "CATransition+PageTransition.h"

#define kDefaultTransitionDuration 0.5
@implementation CATransition (PageTransition)
+ (CATransition *)EaseInEaseOut:(id)delegate
{
    CATransition *transition = [CATransition animation];
    transition.duration = kDefaultTransitionDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.delegate = delegate;
    transition.removedOnCompletion = YES;
    return transition;
}

+ (CATransition *)revealFromBottom:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    return transition;
}

+ (CATransition *)revealFromTop:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromTop;
    return transition;
}

+ (CATransition *)revealFromLeft:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    return transition;
}

+ (CATransition *)revealFromRight:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    return transition;
}

+ (CATransition *)pushFromRight:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    return transition;
}

+ (CATransition *)pushFromLeft:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    return transition;
}

+ (CATransition *)pushFromTop:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    return transition;
}

+ (CATransition *)pushFromBottom:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    return transition;
}

+ (CATransition *)moveInFromTop:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    return transition;
}

+ (CATransition *)moveInFromBottom:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    return transition;
}

+ (CATransition *)moveInFromLeft:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    return transition;
}

+ (CATransition *)moveInFromRight:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    return transition;
}

+ (CATransition *)fadeInFromTop:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    return transition;
}

+ (CATransition *)fadeInFromBottom:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    return transition;
}

+ (CATransition *)fadeInFromLeft:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromLeft;
    return transition;
}

+ (CATransition *)fadeInFromRight:(id)delegate
{
    CATransition *transition = [self EaseInEaseOut:delegate];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    return transition;
}
@end
