//
//  WPClockPopupView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/12.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPClockPopupView.h"
#import "WPPickerItemView.h"

@interface WPClockPopupView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *leftPickerView;
@property (nonatomic, strong) UIPickerView *rightPickerView;
@property (nonatomic, strong) UILabel *hourlabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UIView *markView;
@end

@implementation WPClockPopupView
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        self.titleView.backgroundColor = kColor_1;
        self.titleLabel.text = kLocalization(@"clock_wakeup_time");
        self.titleLabel.font = kFont_1(12);
        self.titleLabel.textColor = kColor_7;
        self.contentView.backgroundColor = kColor_9_With_Alpha(0.1);
    }
    return self;
}

- (void)setupViews{
    [super setupViews];
    _leftPickerView = [[UIPickerView alloc] init];
    _leftPickerView.backgroundColor = kColor_1;
    _leftPickerView.showsSelectionIndicator = YES;
    _leftPickerView.delegate = self;
    _leftPickerView.dataSource = self;
    [self.contentView addSubview:_leftPickerView];
    _rightPickerView = [[UIPickerView alloc] init];
    _rightPickerView.backgroundColor = kColor_1;
    _rightPickerView.showsSelectionIndicator = YES;
    _rightPickerView.delegate = self;
    _rightPickerView.dataSource = self;
    [self.contentView addSubview:_rightPickerView];
    _markView = [[UIView alloc] init];
    _markView.backgroundColor = kColor_5;
    [self.contentView addSubview:_markView];
    _hourlabel = [[UILabel alloc] init];
    _hourlabel.textColor = kColor_9;
    _hourlabel.textAlignment = NSTextAlignmentLeft;
    _hourlabel.font = kFont_1(10);
    _hourlabel.backgroundColor = [UIColor clearColor];
    _hourlabel.text = kLocalization(@"common_hour_unit");
    [self addSubview:_hourlabel];
    _minLabel = [[UILabel alloc] init];
    _minLabel.textColor = kColor_9;
    _minLabel.textAlignment = NSTextAlignmentLeft;
    _minLabel.font = kFont_1(10);
    _minLabel.backgroundColor = [UIColor clearColor];
    _minLabel.text = kLocalization(@"common_minute_unit");
    [self addSubview:_minLabel];
    MJWeakSelf;
    [_leftPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0.5);
        make.bottom.equalTo(@(-0.5));
        make.left.equalTo(@6);
        make.right.equalTo(weakSelf.rightPickerView.mas_left).offset(-0.5);
        make.width.equalTo(weakSelf.rightPickerView.mas_width);
    }];
    [_rightPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0.5);
        make.bottom.equalTo(@(-0.5));
        make.left.equalTo(weakSelf.leftPickerView.mas_right).offset(0.5);
        make.right.equalTo(@0);
        make.width.equalTo(weakSelf.leftPickerView.mas_width);
        
    }];
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.equalTo(@6);
        make.height.equalTo(@55);
    }];
    [_hourlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.markView.mas_top);
        make.bottom.equalTo(weakSelf.markView.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX).offset(-21);
        make.width.equalTo(@42);
    }];
    [_minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.markView.mas_top);
        make.bottom.equalTo(weakSelf.markView.mas_bottom);
        make.left.equalTo(weakSelf.hourlabel.mas_right).offset(72);
        make.width.equalTo(@42);
    }];
    [_leftPickerView selectRow:50 inComponent:0 animated:NO];
    [_rightPickerView selectRow:0 inComponent:0 animated:NO];
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == _leftPickerView) {
        return 24;
    }else{
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld",(long)row];
}

#pragma mark UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    WPPickerItemView* item = (WPPickerItemView*)view;
    if (!item){
        item = [[WPPickerItemView alloc] init];
        item.titleLabel.textColor = kColor_9;
        item.titleLabel.font = kFont_1(18);
        item.titleLabel.backgroundColor = [UIColor clearColor];
    }
    if (pickerView == _leftPickerView) {
        item.titleLabel.textAlignment = NSTextAlignmentRight;
        [item.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@(-56));
        }];
    }else{
        item.titleLabel.textAlignment = NSTextAlignmentRight;
        [item.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@(64 - self.width/2));
        }];
    }
    
    item.titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return item;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//
//    NSDictionary * attrDic = @{NSForegroundColorAttributeName:kColor_9,
//                               NSFontAttributeName:kFont_3(18)};
//    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString: [self pickerView:pickerView titleForRow:row forComponent:component] attributes:attrDic];
//    return attrString;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return pickerView.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 53;
}

- (void)cancelBtnPressed{
    [super cancelBtnPressed];
}

- (void)confirmBtnPressed{
    [super confirmBtnPressed];
    NSInteger hour = [_leftPickerView selectedRowInComponent:0];
    NSInteger minute = [_rightPickerView selectedRowInComponent:0];
    NSDate *date = [NSDate dateFromString:[NSString stringWithFormat:@"%ld:%ld",(long)hour,(long)minute] format:@"H:m"];
    if (_clockBlock) {
        _clockBlock(self, date);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
