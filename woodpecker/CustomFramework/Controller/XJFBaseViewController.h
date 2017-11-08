//
//  BaseViewController.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJFBaseViewController : UIViewController
@property(nonatomic, strong) UIView *bottomLine;
//显示/隐藏导航
- (void)hideNavigationBar;
- (void)showNavigationBar;

//显示/隐藏状态栏
- (void)showStatusBar;
- (void)hideStatusBar;

//显示/隐藏右菜单
- (void)showStatusRightItems;
- (void)hideStatusRightItems;

//设置左按钮
//- (void)setRightNavigationButton:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage frame:(CGRect)frame;
- (void)setNavigationButtons:(NSInteger)count
                       title:(NSArray<NSString *> *)title
                       image:(NSArray<UIImage *> *)image
            highlightedImage:(NSArray<UIImage *> *)highlightedImage
                       frame:(NSArray<NSValue *> *)frame
                     isRight:(BOOL)isRight;

- (void)navigationRightButtonClicked:(UIButton *)sender;
- (void)navigationLeftButtonClicked:(UIButton *)sender;

//设置返回按钮
- (void)setBackBarButton;
- (void)setMoreBarButtonWithTitle:(NSString *)title color:(UIColor *)color;
- (void)setMoreBarButtonWithImage:(UIImage *)image;
- (void)goBack:(UIButton *)sender;
- (void)moreBarButtonPressed:(UIButton *)sender;
- (void)navigationBarLineHidden:(BOOL)hidden;

//让左边第一个 bar button item 旋转
- (void)setLeftBarItemRotate:(BOOL)needRotate;

- (void)pushToNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated;
@end
