//
//  WPThermometerClockViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerClockViewController.h"
#import "WPThermometerClockViewModel.h"
#import "TableViewCell.h"
#import "WPClockPopupView.h"

@interface WPThermometerClockViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property(nonatomic, strong) WPThermometerClockViewModel *viewModel;
@end

@implementation WPThermometerClockViewController
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
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 260)];
        headerView.backgroundColor = [UIColor clearColor];
        UIImageView *clockIcon = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 168)/2, 24, 147, 168)];
        clockIcon.backgroundColor = [UIColor clearColor];
        clockIcon.image = kImage(@"ima-alarm");
        [headerView addSubview:clockIcon];
        UILabel *clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, clockIcon.bottom  +15, kScreen_Width, 38)];
        clockLabel.backgroundColor = [UIColor clearColor];
        clockLabel.textColor = kColor_7;
        clockLabel.font = kFont_1(12);
        clockLabel.numberOfLines = 2;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.lineSpacing = 3;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:kLocalization(@"clock_prompt") attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
        clockLabel.attributedText = attributeStr;
        [headerView addSubview:clockLabel];
        _tableView.tableHeaderView = headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"闹钟";
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
    _viewModel = [[WPThermometerClockViewModel alloc] init];
}

- (void)setupViews{
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"ClockCell";
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
    if (indexPath.row == 0) {
        cell.rightModel = kCellRightModelSwitch;
        cell.titleLabel.text = kLocalization(@"clock_measurement");
        cell.detailLabel.text = @"05:30";
        cell.line.hidden = YES;
    }else if (indexPath.row == 1){
        cell.rightModel = kCellRightModelNext;
        cell.titleLabel.text = kLocalization(@"clock_wakeup_time");
        cell.detailLabel.text = @"未设置";
        cell.line.hidden = NO;
    }
    [cell drawCellWithSize:CGSizeMake(kScreen_Width, [self tableView:_tableView heightForRowAtIndexPath:indexPath])];
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
    if (indexPath.row == 1) {
        WPClockPopupView *popView = [[WPClockPopupView alloc] init];
        NSLog(@"1=====%f",popView.attachedView.size.height);
        [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            NSLog(@"2=====%f",popView.attachedView.size.height);
        }];
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
