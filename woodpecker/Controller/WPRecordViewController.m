//
//  WPRecordViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPRecordViewController.h"
#import "WPRecordViewModel.h"
#import "TableViewCell.h"
#import "WPRecordHeaderView.h"
#import "WPRecordStatusModel.h"

@interface WPRecordViewController ()<UITableViewDataSource,UITableViewDelegate,WPRecordHeaderViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) WPRecordViewModel *viewModel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSMutableArray *statuses;

@end

@implementation WPRecordViewController
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
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 28)];
        headerView.backgroundColor = [UIColor clearColor];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 28)];
        _dateLabel.backgroundColor = kColor_7;
        _dateLabel.textColor = kColor_10;
        _dateLabel.font = kFont_2(12);
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = @"2017年6月7日 周三";
        [headerView addSubview:_dateLabel];
        _tableView.tableHeaderView = headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"记录";
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
}

- (void)setupData{
    _viewModel = [[WPRecordViewModel alloc] init];
}

- (void)setupViews{
    _statuses = _viewModel.statuses;
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"ThermometerCell";
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(TableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = kColor_10;
    cell.layer.masksToBounds = YES;
    cell.leftModel = kCellLeftModelIcon;
    cell.rightModel = kCellRightModelNext;
    [cell drawCellWithSize:CGSizeMake(kScreen_Width, [self tableView:_tableView heightForRowAtIndexPath:indexPath])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _statuses.count;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 41;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 3 || section == 7 ) {
        return 28;
    }
    return 41;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WPRecordStatusModel *status = [_statuses objectAtIndex:section];
    if (status.onlyTitle) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 28)];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, kScreen_Width - 46, 28)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = kFont_1(10);
        titleLabel.textColor = kColor_7_With_Alpha(0.8);
        titleLabel.text = status.title;
        [headerView addSubview:titleLabel];
        return headerView;
    }else{
        WPRecordHeaderView *headerView = [[WPRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 41)];
        headerView.backgroundColor = kColor_10;
        headerView.status = status;
        headerView.section = section;
        headerView.delegate = self;
        return headerView;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}

- (void)removeBtnPressed{
    
}

#pragma mark WPRecordHeaderViewDelegate
- (void)showRecordHeader:(WPRecordHeaderView *)headerView{
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:headerView.section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
