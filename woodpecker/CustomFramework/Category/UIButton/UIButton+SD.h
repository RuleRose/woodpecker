//
//  UIButton+SD.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/5.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (leie_SD)
/**
 *  普通网络图片展示
 *
 *  @param urlStr  图片地址
 *  @param phImage 占位图片
 */
-(void)leie_imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage;


/**
 *  带有进度的网络图片展示
 *
 *  @param urlStr         图片地址
 *  @param phImage        占位图片
 *  @param completedBlock 完成
 */
-(void)leie_imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage state:(UIControlState)state completedBlock:(SDWebImageCompletionBlock)completedBlock;

@end
