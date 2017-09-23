//
//  WPPeriodViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPPeriodViewController.h"
#import "WPPeriodViewModel.h"
#import "WPInfoSettingCell.h"

@interface WPPeriodViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* finishBtn;
@property (nonatomic, strong) WPPeriodViewModel *viewModel;
@end

@implementation WPPeriodViewController
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, kNavigationHeight + kStatusHeight + 14, kScreen_Width - 30, 123)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 6;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"周期信息";
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
    _viewModel = [[WPPeriodViewModel alloc] init];
}

- (void)setupViews{
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.backgroundColor = [UIColor clearColor];
    _finishBtn.layer.borderColor = kColor_8_With_Alpha(0.8).CGColor;
    _finishBtn.layer.borderWidth = 0.5;
    _finishBtn.titleLabel.font = kFont_1(15);
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_finishBtn setTitleColor:kColor_8 forState:UIControlStateNormal];
    [_finishBtn addTarget:self action:@selector(finishBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishBtn];
    [self.view addSubview:self.tableView];
    _finishBtn.frame = CGRectMake((kScreen_Width - 300)/2, _tableView.bottom + 69, 300, 45);
}

- (void)finishBtnPressed{

}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"PeriodCell";
    WPInfoSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WPInfoSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(WPInfoSettingCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = kColor_10;
    cell.layer.masksToBounds = YES;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"周期长度";
        cell.textField.text = @"1";
        cell.line.hidden = YES;
        cell.textField.enabled = NO;
    }else if (indexPath.row == 1){
        cell.titleLabel.text = @"经期长度";
        cell.textField.text = @"2";
        cell.line.hidden = NO;
        cell.textField.enabled = NO;
    }else if (indexPath.row == 2){
        cell.titleLabel.text = @"末次经期首日";
        cell.textField.text = @"3";
        cell.line.hidden = NO;
        cell.textField.enabled = NO;
    }
    [cell drawCellWithSize:CGSizeMake(kScreen_Width - 30, [self tableView:_tableView heightForRowAtIndexPath:indexPath])];
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
        
    }else if (indexPath.row == 1){
    
    }else if (indexPath.row == 2){
    
    }
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
