//
//  WPRecordViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPRecordViewController.h"
#import "WPRecordViewModel.h"
#import "WPRecordHeaderView.h"
#import "WPRecordStatusModel.h"
#import "WPRecordDetailCell.h"

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _dateLabel.bottom, kScreen_Width, kScreen_Height - _dateLabel.bottom)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] init];
        CGFloat height = kScreen_Height - kNavigationHeight - kStatusHeight - 28*4 - 41 * 12;
        if (height < 0) {
            height = 0;
        }
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
        footerView.backgroundColor = kColor_2;
        _tableView.tableFooterView = footerView;
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
    _statuses = _viewModel.statuses;
}

- (void)setupViews{
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavigationHeight + kStatusHeight, kScreen_Width, 28)];
    _dateLabel.backgroundColor = kColor_7;
    _dateLabel.textColor = kColor_10;
    _dateLabel.font = kFont_2(12);
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.text = @"2017年6月7日 周三";
    [self.view addSubview:_dateLabel];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5 || section == 6 || section == 8 || section == 9 || section == 10 || section == 12 || section == 13) {
        return 1;
    }else if (section == 2) {
        return 4;
    }else if (section == 4){
        return 2;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"DetailCell";
    WPRecordDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WPRecordDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(WPRecordDetailCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kColor_3;
    cell.contentView.backgroundColor = kColor_3;
    cell.layer.masksToBounds = YES;
    cell.contentView.layer.masksToBounds = YES;
    cell.column = 3;
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfColor];
            cell.selectedIndex = 1;
            cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfColor];
            cell.line.hidden = YES;
        }else if (indexPath.row == 1){
            cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfFlow];
            cell.selectedIndex = 1;
            cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfFlow];
            cell.line.hidden = NO;
        }else if (indexPath.row == 2){
            cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfPain];
            cell.selectedIndex = 1;
            cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfPain];
            cell.line.hidden = NO;
        }else{
            cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfGore];
            cell.selectedIndex = 1;
            cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfGore];
            cell.line.hidden = NO;
        }
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfCharacter];
            cell.selectedIndex = 1;
            cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfCharacter];
            cell.line.hidden = YES;
        }else{
            cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfQuantity];
            cell.selectedIndex = 1;
            cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfQuantity];
            cell.line.hidden = NO;
        }
    }else if (indexPath.section == 5){
        cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfLove];
        cell.selectedIndex = 1;
        cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfLove];
        cell.line.hidden = YES;
    }else if (indexPath.section == 6){
        cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfCT];
        cell.selectedIndex = 1;
        cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfCT];
        cell.line.hidden = YES;
    }else if (indexPath.section == 8){
        cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfSleep];
        cell.selectedIndex = 1;
        cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfSleep];
        cell.line.hidden = YES;
    }else if (indexPath.section == 9){
        cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfMood];
        cell.selectedIndex = 1;
        cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfMood];
        cell.column = 2;
        cell.line.hidden = YES;
    }else if (indexPath.section == 10){
        cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfSport];
        cell.selectedIndex = 1;
        cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfSport];
        cell.line.hidden = YES;
    }else if (indexPath.section == 12){
        cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfDrink];
        cell.selectedIndex = 1;
        cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfDrink];
        cell.line.hidden = YES;
    }else if (indexPath.section == 13){
        cell.theme = [_viewModel getThemeWithRecordTheme:kWPRecordThemeOfDrug];
        cell.selectedIndex = 1;
        cell.titles = [_viewModel getTitlesWithRecordTheme:kWPRecordThemeOfDrug];
        cell.line.hidden = YES;
    }
    [cell drawCellWithSize:CGSizeMake(kScreen_Width, [self tableView:_tableView heightForRowAtIndexPath:indexPath])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _statuses.count;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    WPRecordStatusModel *status = [_statuses objectAtIndex:indexPath.section];
    if (status.showDetail) {
        if (indexPath.section == 9) {
            return 164;
        }else if (indexPath.section == 13){
            return 82;
        }
        return 41;
    }else{
        return 0;
    }
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
        headerView.backgroundColor = kColor_2;
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
   [_tableView reloadSections:[NSIndexSet indexSetWithIndex:headerView.section] withRowAnimation:UITableViewRowAnimationNone];
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
