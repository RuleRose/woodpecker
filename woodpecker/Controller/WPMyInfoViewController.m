//
//  WPMyInfoViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPMyInfoViewController.h"
#import "WPMyInfoViewModel.h"
#import "WPTableViewCell.h"
#import "WPSheetView.h"
#import "WPNicknameViewController.h"

@interface WPMyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) WPMyInfoViewModel *viewModel;

@end

@implementation WPMyInfoViewController
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight + kStatusHeight, kScreen_Width, kScreen_Height - (kNavigationHeight + kStatusHeight))];
        _tableView.backgroundColor = [UIColor clearColor];
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
    self.title = @"个人信息";
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    [_tableView reloadData];
}

- (void)setupData{
    _viewModel = [[WPMyInfoViewModel alloc] init];
}

- (void)setupViews{
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"ThermometerCell";
    WPTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(WPTableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = kColor_10;
    cell.layer.masksToBounds = YES;
    cell.leftModel = kCellLeftModelNone;
    if (indexPath.row == 0) {
        cell.rightModel = kCellRightModelImageNext;
        cell.imageIcon.image = kImage(@"btn-me-avatar");
        cell.imageSize = CGSizeMake(51, 51);
        cell.titleLabel.text = @"头像";
        cell.detailLabel.text = @"";
        cell.line.hidden = YES;
        [cell.imageIcon leie_imageWithUrlStr:_userinfo.avatar phImage:kImage(@"btn-me-avatar")];
    }else if (indexPath.row == 1){
        cell.rightModel = kCellRightModelNext;
        cell.icon.image = kImage(@"icon-device-unit");
        cell.titleLabel.text = @"昵称";
        cell.detailLabel.text = _userinfo.nick_name;
        cell.line.hidden = NO;
    }else if (indexPath.row == 2){
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = @"账号";
        cell.detailLabel.text = _userinfo.account_id;
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
    if (indexPath.row == 0) {
        return 82;
    }else{
        return 41;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
        config.defaultTextCancel = @"取消";
        MMPopupItem *cameraItem = [[MMPopupItem alloc] init];
        cameraItem.handler = ^(NSInteger index) {
            [self showCamera];
        };
        cameraItem.title = @"拍照";
        MMPopupItem *photoItem = [[MMPopupItem alloc] init];
        photoItem.handler = ^(NSInteger index) {
            [self showPhotos];
        };
        photoItem.title = @"从相册中选择";
        WPSheetView *sheetView = [[WPSheetView alloc] initWithTitle:@"" items:@[cameraItem, photoItem]];
        [sheetView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            
        }];
    }else if (indexPath.row == 1){
        WPNicknameViewController *nickVC = [[WPNicknameViewController alloc] init];
        nickVC.userinfo = _userinfo;
        [self.navigationController pushViewController:nickVC animated:YES];
    }
}

- (void)showCamera{
    
}

- (void)showPhotos{

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
