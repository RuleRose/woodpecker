//
//  WPWeightPopupView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/24.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPWeightPopupView.h"
#import "WPPickerItemView.h"

@interface WPWeightPopupView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *leftPickerView;
@property (nonatomic, strong) UIPickerView *rightPickerView;

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UILabel *unitlabel;
@property (nonatomic, strong) UILabel *pointLabel;

@end
@implementation WPWeightPopupView
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.titleView.backgroundColor = kColor_5;
        self.titleLabel.text = @"体重";
        self.titleLabel.font = kFont_1(14);
        self.titleLabel.textColor = kColor_10;
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
    _pointLabel = [[UILabel alloc] init];
    _pointLabel.textColor = kColor_9;
    _pointLabel.textAlignment = NSTextAlignmentCenter;
    _pointLabel.font = kFont_3(18);
    _pointLabel.backgroundColor = [UIColor clearColor];
    _pointLabel.text = @".";
    [self addSubview:_pointLabel];
    _unitlabel = [[UILabel alloc] init];
    _unitlabel.textColor = kColor_9;
    _unitlabel.textAlignment = NSTextAlignmentLeft;
    _unitlabel.font = kFont_3(18);
    _unitlabel.backgroundColor = [UIColor clearColor];
    _unitlabel.text = @"kg";
    [self addSubview:_unitlabel];

    MJWeakSelf;
    [_leftPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@(-0.5));
        make.left.equalTo(@6);
        make.right.equalTo(weakSelf.rightPickerView.mas_left);
        make.width.equalTo(weakSelf.rightPickerView.mas_width);
    }];
    [_rightPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@(-0.5));
        make.left.equalTo(weakSelf.leftPickerView.mas_right);
        make.right.equalTo(@0);
        make.width.equalTo(weakSelf.leftPickerView.mas_width);

    }];
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.equalTo(@6);
        make.height.equalTo(@55);
    }];
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.markView.mas_top);
        make.bottom.equalTo(weakSelf.markView.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.equalTo(@80);
    }];
    [_unitlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.markView.mas_top);
        make.bottom.equalTo(weakSelf.markView.mas_bottom);
        make.left.equalTo(weakSelf.pointLabel.mas_right).offset(36);
        make.width.equalTo(@80);
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
        return 500;
    }else{
        return 10;
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
        item.titleLabel.font = kFont_3(18);
        item.titleLabel.backgroundColor = [UIColor clearColor];
    }
    if (pickerView == _leftPickerView) {
        item.titleLabel.textAlignment = NSTextAlignmentRight;
        [item.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@(-40));
        }];
    }else{
        item.titleLabel.textAlignment = NSTextAlignmentLeft;
        [item.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(@40);
            make.right.equalTo(@0);
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
    [self hide];
    NSInteger weight1 = [_leftPickerView selectedRowInComponent:0];
    NSInteger weight2 = [_rightPickerView selectedRowInComponent:0];
    if (_weightBlock) {
        _weightBlock(self, weight1,weight2);
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
