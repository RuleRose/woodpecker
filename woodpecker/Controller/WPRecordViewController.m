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
#import "WPWeightPopupView.h"
#import "WPPeriodCountManager.h"

@interface WPRecordViewController ()<UITableViewDataSource,UITableViewDelegate,WPRecordHeaderViewDelegate,WPRecordDetailCellDelegate>
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
    self.title = kLocalization(@"record_title");
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    [self setMoreBarButtonWithTitle:kLocalization(@"common_save") color: kColor_7_With_Alpha(0.8)];
}

- (void)moreBarButtonPressed:(UIButton *)sender{
    [[XJFHUDManager defaultInstance] showLoadingHUDwithCallback:^{
        
    }];
    [_viewModel updatePeriodSuccess:^(BOOL finished,BOOL needUpdate) {
        if (finished) {
            [_viewModel updateEventSuccess:^(BOOL finished) {
                if (finished) {
                    [[XJFHUDManager defaultInstance] hideLoading];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [[XJFHUDManager defaultInstance] hideLoading];
                  //  [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_network_failure")];
                }
            }];
            if (needUpdate) {
                [[WPPeriodCountManager defaultInstance] recountPeriod];
            }
        }else{
            [[XJFHUDManager defaultInstance] hideLoading];
          //  [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_network_failure")];
        }

    }];
}

- (void)setupData{
    if (!_eventDate) {
        _eventDate = [NSDate date];
    }
    _eventDate =  [NSDate dateFromString:[NSDate stringFromDate:_eventDate] format:DATE_FORMATE_STRING];
    _viewModel = [[WPRecordViewModel alloc] init];
    _viewModel.eventDate = _eventDate;
    _event =  [_viewModel getEventWithDate:_eventDate];
    if (!_event) {
        _event = [[WPEventModel alloc] init];
    }
    _viewModel.event = _event;
    _statuses = _viewModel.statuses;
}

- (void)setupViews{
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavigationHeight + kStatusHeight, kScreen_Width, 28)];
    _dateLabel.backgroundColor = kColor_7;
    _dateLabel.textColor = kColor_10;
    _dateLabel.font = kFont_2(12);
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_dateLabel];
    [self.view addSubview:self.tableView];
    NSString *dateStr = [NSDate stringFromDate:_eventDate format:kLocalization(@"record_date_format")];
    NSString *weekStr = @"";
    NSInteger weekday = [NSDate weekdayOfDate:_eventDate];
    if (weekday == 1) {
        weekStr = kLocalization(@"common_sunday");
    }else if (weekday == 2) {
        weekStr = kLocalization(@"common_monday");
    }else if (weekday == 3) {
        weekStr = kLocalization(@"common_tuesday");
    }else if (weekday == 4) {
        weekStr = kLocalization(@"common_wednesday");
    }else if (weekday == 5) {
        weekStr = kLocalization(@"common_thursday");
    }else if (weekday == 6) {
        weekStr = kLocalization(@"common_friday");
    }else{
        weekStr = kLocalization(@"common_saturday");
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@ %@",dateStr , weekStr];
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
    cell.indexPath = indexPath;
    cell.viewModel = _viewModel;
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.theme = kWPRecordThemeOfColor;
            cell.line.hidden = YES;
        }else if (indexPath.row == 1){
            cell.theme = kWPRecordThemeOfFlow;
            cell.line.hidden = NO;
        }else if (indexPath.row == 2){
            cell.theme = kWPRecordThemeOfPain;
            cell.line.hidden = NO;
        }else{
            cell.theme = kWPRecordThemeOfGore;
            cell.line.hidden = NO;
        }
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            cell.theme = kWPRecordThemeOfMucusProb;
            cell.line.hidden = YES;
        }else{
            cell.theme = kWPRecordThemeOfMucusFlow;
            cell.line.hidden = NO;
        }
    }else if (indexPath.section == 5){
        cell.theme = kWPRecordThemeOfLove;
        cell.line.hidden = YES;
    }else if (indexPath.section == 6){
        cell.theme = kWPRecordThemeOfCT;
        cell.line.hidden = YES;
    }else if (indexPath.section == 8){
        cell.theme = kWPRecordThemeOfSleep;
        cell.line.hidden = YES;
    }else if (indexPath.section == 9){
        cell.theme = kWPRecordThemeOfMood;
        cell.column = 2;
        cell.line.hidden = YES;
    }else if (indexPath.section == 10){
        cell.theme = kWPRecordThemeOfSport;
        cell.line.hidden = YES;
    }else if (indexPath.section == 12){
        cell.theme = kWPRecordThemeOfDrink;
        cell.line.hidden = YES;
    }else if (indexPath.section == 13){
        cell.theme = kWPRecordThemeOfDrug;
        cell.line.hidden = YES;
    }
    if (indexPath.section == 13) {
        cell.mixselection = YES;
    }else{
        cell.mixselection = NO;
    }
    cell.delegate = self;
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
        if ((_viewModel.period_day.type == kPeriodTypeOfMenstrual || _viewModel.period_day.type == kPeriodTypeOfMenstrualStart ||_viewModel.period_day.type == kPeriodTypeOfMenstrualEnd) || _viewModel.on) {
            //排除经期开始日
            if (_viewModel.period_day.dayInPeriod == 1 && !_viewModel.on) {
                if ( indexPath.section >= 2 && indexPath.section <=6) {
                    return 0;
                }
            }
        }else{
            if (indexPath.section >= 2 && indexPath.section <=6) {
                return 0;
            }
        }
        
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
    CGFloat height = 41;
    if (section == 0 || section == 3 || section == 7 ) {
        height = 28;
    }
    //经期或者开关打开
    if ((_viewModel.period_day.type == kPeriodTypeOfMenstrual || _viewModel.period_day.type == kPeriodTypeOfMenstrualStart ||_viewModel.period_day.type == kPeriodTypeOfMenstrualEnd) || _viewModel.on) {
        //排除经期开始日
        if (_viewModel.period_day.dayInPeriod == 1 && !_viewModel.on) {
            if (section >= 2 && section <=6) {
                height = 0;
            }
        }
    }else{
        if (section >= 2 && section <=6) {
            height = 0;
        }
    }
    return height;
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
        if (headerView.showSwitch) {
            headerView.switchView.on = _viewModel.on;
        }
        if (section == 11) {
            if ([NSString leie_isBlankString:_event.weight]) {
                headerView.detailLabel.text = @"";
            }else{
                headerView.detailLabel.text = [NSString stringWithFormat:@"%@%@",_event.weight,kLocalization(@"common_weight_unit")];
            }
        }
        if (section == 14) {
            if ([NSString leie_isBlankString:_event.comments]) {
                headerView.detailLabel.text = @"";
            }else{
                headerView.detailLabel.text = _event.comments;
            }
        }
        headerView.layer.masksToBounds = YES;
        return headerView;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}

#pragma mark WPRecordHeaderViewDelegate
- (void)showRecordHeader:(WPRecordHeaderView *)headerView{
   [_tableView reloadSections:[NSIndexSet indexSetWithIndex:headerView.section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)swithBtnChanged:(WPRecordHeaderView *)headerView on:(BOOL)isOn{
    if (isOn) {
        _viewModel.on = YES;
    }else{
        _viewModel.on = NO;
    }
    [_tableView reloadData];
}

- (void)selectedRecordHeader:(WPRecordHeaderView *)headerView{
    if (headerView.section == 11) {
        //体重
        WPWeightPopupView *popView = [[WPWeightPopupView alloc] init];
        popView.weightBlock = ^(MMPopupView *popupView, NSInteger weight1, NSInteger weight2) {
            _event.weight = [NSString stringWithFormat:@"%ld.%ld",(long)weight1,(long)weight2];
            [_tableView reloadData];
        };
        popView.attachedView = self.navigationController.view;
        [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            
        }];
    }else if (headerView.section == 14){
        //备注
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:kLocalization(@"noti_record_comments") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocalization(@"common_cancel") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        MJWeakSelf;
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:kLocalization(@"common_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (alertController.textFields.count > 0) {
                UITextField *textField = [alertController.textFields objectAtIndex:0];
                weakSelf.event.comments = textField.text;
                [weakSelf.tableView reloadData];
            }
        }];
        [alertController addAction:confirmAction];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.textColor = kColorFromRGB(0x333333);
            textField.font = [UIFont systemFontOfSize:18];
            textField.text = weakSelf.event.comments;
        }];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark WPRecordDetailCellDelegate
- (void)selectTheme:(WPRecordTheme)theme detail:(NSString *)detail cell:(WPRecordDetailCell *)cell{

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
