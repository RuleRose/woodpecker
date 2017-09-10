//
//  WPMyInfoView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPMyInfoView.h"
#import "TableViewNextCell.h"
#import "MyInfoHeaderView.h"

@interface WPMyInfoView ()<UITableViewDataSource,UITableViewDelegate,MyInfoHeaderViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) MyInfoHeaderView* headerView;

@end

@implementation WPMyInfoView
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
        _headerView = [[MyInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 157)];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.delegate = self;
        _tableView.tableHeaderView = _headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
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
    return 7;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 3) {
        NSString* identifier = @"MyCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        NSString* identifier = @"MyCell";
        TableViewNextCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TableViewNextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}
- (void)configureCell:(TableViewNextCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = kColor_10;
    cell.layer.masksToBounds = YES;
    if (indexPath.row == 1) {
        cell.icon.image = kImage(@"icon-me-basic");
        cell.titleLabel.text = kLocalization(@"me_basic");
        cell.detailLabel.text = @"";
        cell.line.hidden = YES;
    }else if (indexPath.row == 2){
        cell.icon.image = kImage(@"icon-me-cycle");
        cell.titleLabel.text = kLocalization(@"me_cycle");
        cell.detailLabel.text = @"29天";
        cell.line.hidden = NO;
    }else if (indexPath.row == 4){
        cell.icon.image = kImage(@"icon-me-shop");
        cell.titleLabel.text = kLocalization(@"me_shop");
        cell.detailLabel.text = @"";
        cell.line.hidden = YES;
    }else if (indexPath.row == 5){
        cell.icon.image = kImage(@"icon-me-about");
        cell.titleLabel.text = kLocalization(@"me_about");
        cell.detailLabel.text = @"";
        cell.line.hidden = NO;
    }else if (indexPath.row == 6){
        cell.icon.image = kImage(@"icon-me-help");
        cell.titleLabel.text = kLocalization(@"me_help");
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
    if (indexPath.row == 0 || indexPath.row == 3) {
        return 20;
    }
    return 41;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(selectedBasic)]) {
            [_delegate selectedBasic];
        }
    }else if (indexPath.row == 2){
        if (_delegate && [_delegate respondsToSelector:@selector(selectedCycle)]) {
            [_delegate selectedCycle];
        }
    }else if (indexPath.row == 4){
        if (_delegate && [_delegate respondsToSelector:@selector(selectedShop)]) {
            [_delegate selectedShop];
        }
    }else if (indexPath.row == 5){
        if (_delegate && [_delegate respondsToSelector:@selector(selectedAbout)]) {
            [_delegate selectedAbout];
        }
    }else if (indexPath.row == 6){
        if (_delegate && [_delegate respondsToSelector:@selector(selectedHelp)]) {
            [_delegate selectedHelp];
        }
    }
}

#pragma mark MyInfoHeaderViewDelegate
- (void)selectedAvatar{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedAvatar)]) {
        [_delegate selectedAvatar];
    }
}

- (void)selectedAccount{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedAccount)]) {
        [_delegate selectedAccount];
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
