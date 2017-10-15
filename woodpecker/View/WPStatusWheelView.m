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
#import "WPEventModel.h"
#import "WPUserModel.h"
#import "WPProfileModel.h"

@interface WPStatusWheelView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;
//@property(nonatomic, assign)CGPoint pos;
@property(nonatomic, assign) CGFloat offset;
@property(nonatomic, assign) CGPoint location;
//@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)CAShapeLayer *shapeLayer;
@property(nonatomic, strong)WPCollectionViewWheelLayout *layout;
@property(nonatomic, strong)NSArray *startEvents;
@property(nonatomic, strong)NSArray *endEvents;
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
    WPEventModel *event = [[WPEventModel alloc] init];
    event.status = @"1"; //start
    _startEvents = [XJFDBManager searchModelsWithCondition:event andpage:-1 andOrderby:@"date" isAscend:NO];
    event.status = @"2"; //end
    _endEvents = [XJFDBManager searchModelsWithCondition:event andpage:-1 andOrderby:@"date" isAscend:NO];
    [_collectionView reloadData];
    [self scrollToBottom];
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
    cell.period_type = [self getPeriodWithDate:date];
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
    if (_delegate && [_delegate respondsToSelector:@selector(showDetailDate:period:)]) {
        [_delegate showDetailDate:[NSDate date] period:[self getPeriodWithDate:[NSDate date]]];
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
    if (_delegate && [_delegate respondsToSelector:@selector(showDetailDate:period:)]) {
        [_delegate showDetailDate:date period:[self getPeriodWithDate:date]];
    }
}

- (PeriodType)getPeriodWithDate:(NSDate *)date{
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    WPEventModel *startEvent;
    for (WPEventModel *event in _startEvents) {
        NSDate *eventDate = [NSDate dateFromString:event.date format:@"yyyy MM dd"];
        NSTimeInterval event_timestamp = [eventDate timeIntervalSince1970];
        if (event_timestamp <= timestamp) {
            startEvent = event;
            break;
        }
    }
    if (startEvent) {
        WPProfileModel *profile = [[WPProfileModel alloc] init];
        [profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
        if ([profile.period integerValue] > 0) {
            NSDate *startDate = [NSDate dateFromString:startEvent.date format:@"yyyy MM dd"];
            NSInteger days = [NSDate daysFromDate:startDate toDate:date];
            startDate = [NSDate dateByAddingDays:-(days%([profile.period integerValue])) toDate:date];
            NSTimeInterval startTime = [startDate timeIntervalSince1970];
            WPEventModel *endEvent;
            for (WPEventModel *event in _endEvents) {
                NSDate *eventDate = [NSDate dateFromString:event.date format:@"yyyy MM dd"];
                NSTimeInterval event_timestamp = [eventDate timeIntervalSince1970];
                if ((event_timestamp >= startTime) && (event_timestamp <= startTime + [profile.period longLongValue])) {
                    endEvent = event;
                    break;
                }
            }
            days = [NSDate daysFromDate:startDate toDate:date];
            NSInteger menstruation = [profile.menstruation integerValue];
            if (endEvent) {
                NSDate *endDate = [NSDate dateFromString:endEvent.date format:@"yyyy MM dd"];
                menstruation = [NSDate daysFromDate:startDate toDate:endDate];
            }
            if (days <= menstruation) {
                if ([NSDate isDateAfterToday:date]) {
                    return kPeriodTypeOfForecast;
                }else{
                    return kPeriodTypeOfMenstrual;
                }
            }else if(days == [profile.period integerValue] - 14){
                return kPeriodTypeOfOviposit;
            }else if ((days >= [profile.period integerValue] - 19) && (days <= [profile.period integerValue] - 10)){
                return kPeriodTypeOfPregnancy;
            }else{
                return kPeriodTypeOfSafe;
            }
        }else{
            return kPeriodTypeOfSafe;
        }
    }else{
        return kPeriodTypeOfSafe;
    }
}

//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == _scrollView) {
//        CGPoint currentPoint = scrollView.contentOffset;
//        CGPoint offset = [self offsetWithCurrentPos:currentPoint];
//        [_collectionView setContentOffset:offset];
//        [_scrollView setContentOffset:_pos];
//    }
//}

//- (CGPoint)offsetWithCurrentPos:(CGPoint)currentPoint{
//    CGFloat contentOffsetY = currentPoint.y;
//    if (fabs(currentPoint.y - _pos.y) > fabs(currentPoint.x -_pos.x)) {
//        contentOffsetY = currentPoint.y;
//    }else{
//        contentOffsetY = currentPoint.x;
//    }
//    _pos = CGPointMake(contentOffsetY, contentOffsetY);
//    CGPoint contentOffset = _collectionView.contentOffset;
//    return CGPointMake(contentOffset.x, contentOffsetY*(300.0/self.width));
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
//    [super beginTrackingWithTouch:touch withEvent:event];
//    self.location = [touch locationInView:self];
//
//    return YES;
//}
//
//- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    [super continueTrackingWithTouch:touch withEvent:event];
//    CGPoint currentLocation = [touch locationInView:self];
//    self.offset = [self offset:self.location to:currentLocation];
//    NSLog(@"offset %f", self.offset);
//    CGPoint collectionViewOffset = self.collectionView.contentOffset;
//    NSLog(@"collectionview offset %f, %f", collectionViewOffset.x, collectionViewOffset.y);
//    
//    [self.collectionView setContentOffset:CGPointMake(collectionViewOffset.x, collectionViewOffset.y - self.offset*1)];
//    self.location = currentLocation;
//    
//    return YES;
//}
//
//- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
//    [super endTrackingWithTouch:touch withEvent:event];
//    CGPoint collectionViewOffset = self.collectionView.contentOffset;
//    NSInteger index = round(collectionViewOffset.y / 300);
//    if (index < 0) {
//        index = 0;
//    }else if(index > 15){
//        index = 15;
//    }
//    CGFloat offsetY = index * 300;
//    
//    [self.collectionView setContentOffset:CGPointMake(collectionViewOffset.x, offsetY)];
//}
//
//-(CGFloat)offset:(CGPoint)fromPoint to:(CGPoint)toPoint{
//    CGFloat offsetX = toPoint.x - fromPoint.x;
//    CGFloat offsetY = toPoint.y - fromPoint.y;
//    return offsetX + offsetY;
//}
@end
