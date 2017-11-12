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
#import "TZImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WPLoginViewController.h"
#import "WPAccountManager.h"
#import "XJFHUDManager.h"
#import "UIImage+Extension.h"

@interface WPMyInfoViewController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) WPMyInfoViewModel *viewModel;
@property (nonatomic, strong) UIImage* photo;
@property (nonatomic, strong) UIButton* cancelBtn;

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
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width - 300)/2, 70, 300, 45)];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        _cancelBtn.layer.borderColor = kColor_8_With_Alpha(0.8).CGColor;
        _cancelBtn.layer.borderWidth = 0.5;
        _cancelBtn.titleLabel.font = kFont_1(15);
        [_cancelBtn setTitle:kLocalization(@"common_logout") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColor_8 forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:_cancelBtn];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = kLocalization(@"account_title");
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)setupData{
    _viewModel = [[WPMyInfoViewModel alloc] init];
}

- (void)setupViews{
    [self.view addSubview:self.tableView];
}

- (void)cancelBtnPressed{
    [[WPAccountManager defaultInstance] logout];
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
        cell.titleLabel.text = kLocalization(@"userinfo_avatar");
        cell.detailLabel.text = @"";
        cell.line.hidden = YES;
        if (_photo) {
            cell.imageIcon.image = _photo;
        }else{
            [cell.imageIcon leie_imageWithUrlStr:_userinfo.avatar phImage:kImage(@"btn-me-avatar")];
        }
    }else if (indexPath.row == 1){
        cell.rightModel = kCellRightModelNext;
        cell.icon.image = kImage(@"icon-device-unit");
        cell.titleLabel.text = kLocalization(@"userinfo_nick_name");
        cell.detailLabel.text = _userinfo.nick_name;
        cell.line.hidden = NO;
    }else if (indexPath.row == 2){
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = kLocalization(@"common_account");
        cell.detailLabel.text = _userinfo.account_id;
        NSString *account_id = kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER_ID);
        if (!account_id) {
            cell.detailLabel.text = @"";
        }else{
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",account_id];
        }
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
        config.defaultTextCancel = kLocalization(@"common_cancel");
        MMPopupItem *cameraItem = [[MMPopupItem alloc] init];
        cameraItem.handler = ^(NSInteger index) {
            [self showCamera];
        };
        cameraItem.title = kLocalization(@"common_camera");
        MMPopupItem *photoItem = [[MMPopupItem alloc] init];
        photoItem.handler = ^(NSInteger index) {
            [self showPhotos];
        };
        photoItem.title = kLocalization(@"common_photos");
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
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_camera")];

    }else{
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType = sourceType;
            picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }else{
            [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_no_camera")];
        }
    }

}

- (void)showPhotos{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else{
        [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_no_photos")];
    }
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    if (photo) {
        [self selectedImage:photo];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)selectedImage:(UIImage *)photo{
    if (photo) {
        [[XJFHUDManager defaultInstance] showLoadingHUDwithCallback:^{
            
        }];
        UIImage *avatar = [UIImage scaleImage:photo croppingForSize:CGSizeMake(120, 120)];
        [_viewModel uploadAvatar:avatar success:^(BOOL finished) {
            [[XJFHUDManager defaultInstance] hideLoading];
            if (finished) {
                [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_upload_success")];
                _photo = avatar;
                [_tableView reloadData];
            }else{
                [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_upload_failure")];
            }
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
