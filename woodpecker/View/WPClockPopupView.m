//
//  WPClockPopupView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/12.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPClockPopupView.h"
#import "WPClockItemView.h"

@interface WPClockPopupView()//<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIDatePicker *timePicker;
@property (nonatomic, strong) UIView *handleView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger firstIndex;
@property (nonatomic, assign) NSInteger secondIndex;


@end

@implementation WPClockPopupView
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        self.backgroundColor = kColor_9_With_Alpha(0.1);
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = kColor_1;
        _titleLabel.textColor = kColor_7;
        _titleLabel.font = kFont_1(12);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = kLocalization(@"clock_wakeup_time");
        [self addSubview:_titleLabel];
        _timePicker = [[UIDatePicker alloc] init];
        _timePicker.backgroundColor = kColor_1;
        _timePicker.datePickerMode = UIDatePickerModeCountDownTimer;
//        _timePicker.delegate = self;
//        _timePicker.dataSource = self;
        [self addSubview:_timePicker];
        _handleView = [[UIView alloc] init];
        _handleView.backgroundColor = kColor_1;
        [self addSubview:_handleView];
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.backgroundColor = kColor_10;
        [_cancelBtn setTitle:kLocalization(@"common_cancel") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFont_1(12);
        [_cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_handleView addSubview:_cancelBtn];
        
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.backgroundColor = kColor_10;
        [_confirmBtn setTitle:kLocalization(@"common_confirm") forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = kFont_1(12);
        [_confirmBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_handleView addSubview:_confirmBtn];
        MJWeakSelf;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(392);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@64);
        }];
        [_handleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@92);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@23);
            make.left.equalTo(@24);
            make.right.equalTo(weakSelf.confirmBtn.mas_left).offset(0.5);
            make.width.equalTo(weakSelf.confirmBtn.mas_width);
            make.height.equalTo(@40);
        }];
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@23);
            make.right.equalTo(@(-24));
            make.left.equalTo(weakSelf.confirmBtn.mas_left).offset(0.5);
            make.width.equalTo(weakSelf.confirmBtn.mas_width);
            make.height.equalTo(@40);
        }];
        
        [_timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(0.5);
            make.bottom.equalTo(weakSelf.handleView.mas_top).offset(-0.5);
            make.left.equalTo(@6);
            make.right.equalTo(@0);
        }];
    }
    
    return self;
}

//#pragma mark UIPickerViewDataSource
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 2;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    if (component == 0) {
//        return 24;
//    }else if (component == 1){
//        return 60;
//    }
//    return 0;
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return [NSString stringWithFormat:@"%ld",(long)row];
//}
//
//#pragma mark UIPickerViewDelegate
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    WPClockItemView* itemView = (WPClockItemView*)view;
//    if (!itemView){
//        itemView = [[WPClockItemView alloc] init];
//    }
//    itemView.titleLabel.textColor = kColor_9;
//    itemView.titleLabel.font = kFont_1(14);
//    if (component == 0) {
//        itemView.titleLabel.textAlignment = NSTextAlignmentRight;
//        [itemView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(@(-55));
//        }];
//        [itemView layoutIfNeeded];
//    }else{
//        itemView.titleLabel.textAlignment = NSTextAlignmentLeft;
//        [itemView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@35);
//        }];
//        [itemView layoutIfNeeded];
//    }
//    if (component == 0) {
//        if (row == _firstIndex) {
//            itemView.titleLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
//        }else{
//            itemView.titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//        }
//    }else{
//        if (row == _secondIndex) {
//            itemView.titleLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
//        }else{
//            itemView.titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//        }
//    }
//    return itemView;
//}
//
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    
//    NSDictionary * attrDic = @{NSForegroundColorAttributeName:kColor_5,
//                               NSFontAttributeName:kFont_1(17)};
//    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString: [self pickerView:pickerView titleForRow:row forComponent:component] attributes:attrDic];
//    return attrString;
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    if (component == 0) {
//        _firstIndex = row;
//    }else{
//        _secondIndex = row;
//    }
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    return pickerView.frame.size.width/2;
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
//    return 53;
//}

- (MMPopupBlock)sheetShowAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.attachedView);
                make.bottom.equalTo(self.attachedView.mas_bottom).offset(self.attachedView.frame.size.height);
            }];
            [self.superview layoutIfNeeded];
        }
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.attachedView.mas_bottom).offset(0);
                             }];
                             
                             [self.superview layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (void)cancelBtnPressed{
    [self hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
