//
//  BaseViewController.m
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import "XJFBaseViewController.h"

@interface XJFBaseViewController ()
@property(nonatomic, strong) NSArray *rightBarItems;
@end

@implementation XJFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:kColor_NavigationBar];
    [self.navigationController.navigationBar setTintColor:kClear];
    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
    self.view.backgroundColor = kColor_1;
    [self navigationBarLineHidden:YES];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:19], NSForegroundColorAttributeName : kColor_Text1 };
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DDLogInfo(@"dealloc class : %@", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hideNavigationBar {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)showNavigationBar {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)showStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)hideStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)showStatusRightItems {
    self.navigationItem.rightBarButtonItems = self.rightBarItems;
}

- (void)hideStatusRightItems {
    self.navigationItem.rightBarButtonItems = nil;
}

//- (void)setRightNavigationButton:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage frame:(CGRect)frame {
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (title) {
//        [button setTitle:title forState:UIControlStateNormal];
//        //        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
//    }
//    [button addTarget:self action:@selector(navigationRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [button setFrame:frame];
//    if (image) {
//        [button setImage:image forState:UIControlStateNormal];
//    }
//    if (highlightedImage) {
//        [button setImage:highlightedImage forState:UIControlStateHighlighted];
//    }
//    //    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
//
//    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    //    negativeSpacer.width = -5;
//    //    negativeSpacer.tintColor = kRandom_Color;
//
//    self.navigationItem.rightBarButtonItem = rightBar;
//}

/**
 *  设置navigation bar 按钮。如果是左边按钮，第一个按钮在最左边，tag为0；如果是右边按钮，第一个按钮在最右边，tag为0
 *
 *  @param count            button数量
 *  @param title            button title数组，可选
 *  @param image            普通状态 image数组，可选
 *  @param highlightedImage 高亮状态 image数组，可选
 *  @param frame            button大小数组，可选
 *  @param isRight          右边按钮，或者左边按钮
 *   */
- (void)setNavigationButtons:(NSInteger)count
                       title:(NSArray<NSString *> *)title
                       image:(NSArray<UIImage *> *)image
            highlightedImage:(NSArray<UIImage *> *)highlightedImage
                       frame:(NSArray<NSValue *> *)frame
                     isRight:(BOOL)isRight {
    NSMutableArray *btnList = [[NSMutableArray alloc] init];

    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -8;
    [btnList addObject:negativeSeperator];

    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (isRight) {
            [button addTarget:self action:@selector(navigationRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [button addTarget:self action:@selector(navigationLeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }

        if (title) {
            [button setTitle:[title leie_objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setTitleColor:kColor_Text1 forState:UIControlStateNormal];
        }

        if (image) {
            [button setImage:[image leie_objectAtIndex:i] forState:UIControlStateNormal];
        }

        if (highlightedImage) {
            [button setImage:[highlightedImage leie_objectAtIndex:i] forState:UIControlStateHighlighted];
        }

        if (frame) {
            [button setFrame:[(NSValue *)[frame leie_objectAtIndex:i] CGRectValue]];
        } else {
            [button setFrame:CGRectMake(0, 0, 44, 44)];
        }

        button.tag = i;

        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];

        [btnList addObject:rightBar];
    }

    if (isRight) {
        self.navigationItem.rightBarButtonItems = btnList;
        self.rightBarItems = btnList;
    } else {
        self.navigationItem.leftBarButtonItems = btnList;
    }
}

//点击操作需要被子类继承
- (void)navigationRightButtonClicked:(UIButton *)sender {
}

- (void)navigationLeftButtonClicked:(UIButton *)sender {
}

- (void)setBackBarButton {
    if (self.navigationController.viewControllers.count <= 1) {
        return;
    }
    //设置返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:kImage(@"titel_button_fanhui") forState:UIControlStateNormal];
    [button setImage:kImage(@"titel_button_fanhui_highlight") forState:UIControlStateHighlighted];
    [button.titleLabel setFont:kFont16];
    [button setTitleColor:kColor_2_With_Alpha(0.8) forState:UIControlStateNormal];
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem* leftSpaceItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
    leftSpaceItem.width = -20;
    self.navigationItem.leftBarButtonItems = @[leftSpaceItem, leftbutton];
}

//返回
- (void)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//隐藏导航栏下面的细线
- (void)navigationBarLineHidden:(BOOL)hidden {
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        NSArray *list = self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)obj;
                NSArray *list2 = imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2 = (UIImageView *)obj2;
                        imageView2.hidden = hidden;
                    }
                }
            }
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//让左边第一个 bar button item 旋转
- (void)setLeftBarItemRotate:(BOOL)needRotate {
    UIBarButtonItem *leftItem = self.navigationItem.leftBarButtonItems[1];
    if (needRotate) {
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        rotationAnimation.duration = 2;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        [leftItem.customView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    } else {
        [leftItem.customView.layer removeAllAnimations];
    }
}

- (void)pushToNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated{    UIViewController *vc = navigationController.topViewController;
    if ([vc isKindOfClass:[self class]]) {
        return;
    }
    [navigationController pushViewController:self animated:animated];
}
@end
