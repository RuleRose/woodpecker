//
//  UIButton+SD.m
//  storyhouse2
//
//  Created by 肖君 on 16/7/5.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import "UIButton+SD.h"

@implementation UIButton (leie_SD)
/**
 *  imageView展示网络图片
 *
 *  @param urlStr  图片地址
 *  @param phImage 占位图片
 */
-(void)leie_imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage{
    
    if(urlStr==nil) return;
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:phImage];
}

/**
 *  带有进度的网络图片展示
 *
 *  @param urlStr         图片地址
 *  @param phImage        占位图片
 *  @param completedBlock 完成
 */
-(void)leie_imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage state:(UIControlState)state completedBlock:(SDWebImageCompletionBlock)completedBlock{
    
    if(urlStr==nil) return;
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    SDWebImageOptions options = SDWebImageLowPriority | SDWebImageRetryFailed;
    
    [self sd_setImageWithURL:url forState:state placeholderImage:phImage options:options completed:completedBlock];
}
@end
