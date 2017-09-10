//
//  WPThermometerView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerView.h"
#import "TableViewNextCell.h"

@interface WPThermometerView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton *removeBtn;
@end
@implementation WPThermometerView
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] init];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 90)];
        footerView.backgroundColor = [UIColor clearColor];
        _removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(37, 42, kScreen_Width - 74, 45)];
        _removeBtn.backgroundColor = [UIColor clearColor];
        _removeBtn.layer.borderColor = kColor_8.CGColor;
        _removeBtn.layer.borderWidth = 0.5;
        [_removeBtn setTitle:kLocalization(@"thermometer_remove_binding") forState:UIControlStateNormal];
        [_removeBtn setTitleColor:kColor_8 forState:UIControlStateNormal];
        _removeBtn.titleLabel.font = kFont_1(15);
        [_removeBtn addTarget:self action:@selector(removeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:_removeBtn];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"MyCell";
    TableViewNextCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TableViewNextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(TableViewNextCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = kColor_10;
    cell.layer.masksToBounds = YES;
    if (indexPath.row == 0) {
        cell.icon.image = kImage(@"icon-device-alarm");
        cell.titleLabel.text = kLocalization(@"thermometer_clock");
        cell.detailLabel.text = @"05:30";
        cell.line.hidden = YES;
    }else if (indexPath.row == 1){
        cell.icon.image = kImage(@"icon-device-unit");
        cell.titleLabel.text = kLocalization(@"thermometer_unit");
        cell.detailLabel.text = @"摄氏度°C";
        cell.line.hidden = NO;
    }else if (indexPath.row == 2){
        cell.icon.image = kImage(@"icon-device-settings");
        cell.titleLabel.text = kLocalization(@"thermometer_hardware");
        cell.detailLabel.text = @"";
        cell.line.hidden = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 41;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(showThermometerClock)]) {
            [_delegate showThermometerClock];
        }
    }else if (indexPath.row == 1){
        if (_delegate && [_delegate respondsToSelector:@selector(showThermometerUnit)]) {
            [_delegate showThermometerUnit];
        }
    }else if (indexPath.row == 2){
        if (_delegate && [_delegate respondsToSelector:@selector(showThermometerHardware)]) {
            [_delegate showThermometerHardware];
        }
    }
}

- (void)removeBtnPressed{
    if (_delegate && [_delegate respondsToSelector:@selector(removeBinding)]) {
        [_delegate removeBinding];
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
