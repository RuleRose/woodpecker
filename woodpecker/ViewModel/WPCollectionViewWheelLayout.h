//
//  WPCollectionViewWheelLayout.h
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPCollectionViewWheelLayout : UICollectionViewFlowLayout
@property (assign, nonatomic) NSUInteger cellCount;
@property (assign, nonatomic) CGFloat invisibleCellCount;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) CGSize cellSize;
@property (assign, nonatomic) CGFloat angular;
@property (assign, nonatomic) BOOL fadeAway;
@property (assign, nonatomic) CGFloat maxContentHeight;
@property (assign, nonatomic) CGFloat contentHeightPadding;
@end
