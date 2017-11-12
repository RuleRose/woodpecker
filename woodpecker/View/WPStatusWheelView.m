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
#import "NSDate+Extension.h"
#import "WPUserModel.h"
#import "WPProfileModel.h"
#import "WPPeriodModel.h"
#import "WPPeriodCountManager.h"

@interface WPStatusWheelView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;
//@property(nonatomic, assign)CGPoint pos;
@property(nonatomic, assign) CGFloat offset;
@property(nonatomic, assign) CGPoint location;
//@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)CAShapeLayer *shapeLayer;
@property(nonatomic, strong)WPCollectionViewWheelLayout *layout;
//@property (nonatomic,strong)NSMutableArray *periods;

@end

@implementation WPStatusWheelView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_startDate) {
            _startDate = [NSDate date];
        }
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    _layout = [[WPCollectionViewWheelLayout alloc] init];
    _layout.cellSize = CGSizeMake(56, 56);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((self.width - 300)/2, self.height - 300, 300, 300) collectionViewLayout:_layout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = NO;
    _collectionView.clipsToBounds = YES;
    _collectionView.scrollsToTop = NO;
//    _collectionView.userInteractionEnabled = NO;
    [_collectionView registerClass:[WPStatusWheelCell class] forCellWithReuseIdentifier:NSStringFromClass([WPStatusWheelCell class])];
//    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//    _scrollView.backgroundColor = [UIColor clearColor];
//    _scrollView.delegate = self;
//    _scrollView.contentSize = CGSizeMake(self.frame.size.height*18, self.frame.size.height*18);
//    _scrollView.pagingEnabled = YES;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
    [self drawLine];
    [self addSubview:_collectionView];
//    [self addSubview:_scrollView];
}

- (void)drawLine{
    //创建出圆形贝塞尔曲线
    UIBezierPath* linePath = [UIBezierPath bezierPath];
    [linePath addArcWithCenter:CGPointMake(203, 203) radius:203 startAngle:-M_PI*0.6 endAngle:M_PI_2 clockwise:YES];
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.masksToBounds = YES;
    self.shapeLayer.frame = CGRectMake(0, 0, 406, 250);//设置shapeLayer的尺寸和位置
    self.shapeLayer.position = CGPointMake((self.width - self.layout.radius)/2 + 25, self.height - 300 + self.layout.radius - 28 - 2.5);
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 1.0f;
    self.shapeLayer.strokeColor = kColor_7_With_Alpha(0.9).CGColor;
    [self.shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:1],nil]];
    //添加并显示
    self.shapeLayer.path = linePath.CGPath;
    [self.layer addSublayer:self.shapeLayer];
}

- (void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    if (!_startDate) {
        _startDate = [NSDate date];
    }
    [_collectionView reloadData];
//    _periods = [_viewModel getPeriods];
    [self scrollToBottom];
}

- (void)updateData{
    [_collectionView reloadData];
}


#pragma mark - UICollectionView DataSource & Delegate Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [NSDate daysFromDate:_startDate toDate:[NSDate date]] + 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPStatusWheelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WPStatusWheelCell class]) forIndexPath:indexPath];
    NSInteger days = [NSDate daysFromDate:_startDate toDate:[NSDate date]];
    NSDate *date = [NSDate dateByAddingDays:indexPath.row - 2 toDate:_startDate];
    if (indexPath.row == days + 2) {
        cell.textLabel.text = @"今天";
    }else{
        cell.textLabel.text = [NSDate stringFromDate:date format:@"M/d" ];

    }
    WPDayInfoInPeriod *period = [[WPPeriodCountManager defaultInstance] dayInfo:date];
    cell.period_type = period.type;
    cell.date = date;
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

- (void)scrollToBottom{
    CGPoint collectionViewOffset = self.collectionView.contentOffset;
    NSInteger index = ([NSDate daysFromDate:_startDate toDate:[NSDate date]]);
    CGFloat offsetY = index * 56;
    [self.collectionView setContentOffset:CGPointMake(collectionViewOffset.x, offsetY) animated:YES];
    WPDayInfoInPeriod *period_day = [[WPPeriodCountManager defaultInstance] dayInfo:[NSDate date]];
    if (_delegate && [_delegate respondsToSelector:@selector(showDetailDate:period:)]) {
        NSDate *date = [NSDate dateFromString:[NSDate stringFromDate:[NSDate date]] format:DATE_FORMATE_STRING];
        [_delegate showDetailDate:date period:period_day];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"end scrolling");
    [self pageCollectionView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self pageCollectionView:scrollView];
    }
}

- (void)pageCollectionView:(UIScrollView *)scrollView{
    CGPoint collectionViewOffset = self.collectionView.contentOffset;
    NSInteger index = round(collectionViewOffset.y / 56);
    if (index < 0) {
        index = 0;
    }else if(index > ([NSDate daysFromDate:_startDate toDate:[NSDate date]] + 5)){
        index = ([NSDate daysFromDate:_startDate toDate:[NSDate date]] + 5);
    }
    CGFloat offsetY = index * 56;
    
    [self.collectionView setContentOffset:CGPointMake(collectionViewOffset.x, offsetY)];
    
    NSDate *date = [NSDate dateByAddingDays:index toDate:_startDate];
    WPDayInfoInPeriod *period_day = [[WPPeriodCountManager defaultInstance] dayInfo:date];
    if (_delegate && [_delegate respondsToSelector:@selector(showDetailDate:period:)]) {
        [_delegate showDetailDate:date period:period_day];
    }
}
@end
