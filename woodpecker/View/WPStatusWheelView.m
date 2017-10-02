//
//  WPStatusWheelView.m
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPStatusWheelView.h"
#import "WPCollectionViewWheelLayout.h"
#import "WPStatusWheelCell.h"

@interface WPStatusWheelView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, assign)CGPoint pos;
@property(nonatomic, assign)CGFloat offsetY;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)CAShapeLayer *shapeLayer;
@property(nonatomic, strong)WPCollectionViewWheelLayout *layout;
@end

@implementation WPStatusWheelView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    _layout = [[WPCollectionViewWheelLayout alloc] init];
    _layout.cellSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                          collectionViewLayout:_layout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.clipsToBounds = YES;
    [_collectionView registerClass:[WPStatusWheelCell class] forCellWithReuseIdentifier:NSStringFromClass([WPStatusWheelCell class])];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(self.frame.size.height*18, self.frame.size.height*18);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self drawLine];
    [self addSubview:_collectionView];
    [self addSubview:_scrollView];
}

- (void)drawLine{
    //创建出圆形贝塞尔曲线
    UIBezierPath* linePath = [UIBezierPath bezierPath];
    [linePath addArcWithCenter:CGPointMake(203, 203) radius:203 startAngle:-M_PI*0.6 endAngle:M_PI_2 clockwise:YES];
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.masksToBounds = YES;
    self.shapeLayer.frame = CGRectMake(0, 0, 406, 250);//设置shapeLayer的尺寸和位置
    self.shapeLayer.position = CGPointMake((self.frame.size.width - self.layout.radius)/2 + 25, 287.5);
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 1.0f;
    self.shapeLayer.strokeColor = kColor_7_With_Alpha(0.9).CGColor;
    [self.shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:1],nil]];
    //添加并显示
    self.shapeLayer.path = linePath.CGPath;
    [self.layer addSublayer:self.shapeLayer];
}

#pragma mark - UICollectionView DataSource & Delegate Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPStatusWheelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WPStatusWheelCell class]) forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    if (indexPath.row < 2) {
        cell.hidden = YES;
    }else{
        cell.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        CGPoint currentPoint = scrollView.contentOffset;
        CGPoint offset = [self offsetWithCurrentPos:currentPoint];
        [_collectionView setContentOffset:offset];
        [_scrollView setContentOffset:_pos];
    }
}

- (CGPoint)offsetWithCurrentPos:(CGPoint)currentPoint{
    CGFloat contentOffsetY = currentPoint.y;
    if (fabs(currentPoint.y - _pos.y) > fabs(currentPoint.x -_pos.x)) {
        contentOffsetY = currentPoint.y;
    }else{
        contentOffsetY = currentPoint.x;
    }
    _pos = CGPointMake(contentOffsetY, contentOffsetY);
    CGPoint contentOffset = _collectionView.contentOffset;
    return CGPointMake(contentOffset.x, contentOffsetY - 18);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
