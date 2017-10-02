//
//  WPCollectionViewWheelLayout.m
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPCollectionViewWheelLayout.h"

@implementation WPCollectionViewWheelLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellSize = CGSizeMake(56, 56);
        _angular = 22.5;
        _radius = 203;
        _fadeAway = YES;
        _contentHeightPadding = 0;
    }
    return self;
}

- (void)prepareLayout
{
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    if (!self.cellCount) {
        return;
    }
    
    self.invisibleCellCount = self.collectionView.contentOffset.y/self.cellSize.height;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize viewSize = self.collectionView.bounds.size;
    CGSize cellSize = CGSizeMake(50, 50);
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat visibleCellIndex = indexPath.item-self.invisibleCellCount;//calculate new index->visible index
    
    UICollectionViewLayoutAttributes *attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.hidden = YES;
    CGFloat angle = self.angular/90*visibleCellIndex*M_PI_2;
    CGFloat angleOffset = asin(cellSize.width/self.radius);
    CGAffineTransform translation = CGAffineTransformIdentity;
    attributes.center =
    CGPointMake(cellSize.width/2,
                contentOffset.y+viewSize.height-cellSize.height/2);
    
    if (angle <= (M_PI_2+2*angleOffset+self.angular/90) && angle >= (0-angleOffset))
    {
        attributes.hidden = NO;
        translation =
        CGAffineTransformMakeTranslation(sin(angle)*self.radius + (self.collectionView.frame.size.width - self.radius)/2,
                                         -(cos(angle)*self.radius+cellSize.height/2));
    }
    
    attributes.transform = translation;
    CGFloat fadeFactor = 1-fabs(angle-M_PI_4);
    attributes.alpha = self.fadeAway?fadeFactor:1;
    CGFloat width = cellSize.height*fadeFactor;
    if (width < 22) {
        width = 22;
    }
    attributes.size = CGSizeMake(width, width);
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArray = @[].mutableCopy;
    for (int i = 0; i < self.cellCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (CGRectContainsRect(rect, attributes.frame) || CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArray addObject:attributes];
        }
    }
    
    return attributesArray;
}

- (CGSize)collectionViewContentSize
{
    CGSize viewSize = self.collectionView.bounds.size;
    CGFloat visibleCellCount = 0;
    visibleCellCount = 90/self.angular+1;
    return CGSizeMake(viewSize.width,
                      viewSize.height+(self.cellCount-visibleCellCount)*self.cellSize.height+self.contentHeightPadding);
}
@end
