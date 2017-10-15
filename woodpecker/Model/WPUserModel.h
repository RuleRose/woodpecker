//
//  WPUserModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/6.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPUserModel : XJFBaseModel
@property(nonatomic, copy)NSString *account_type;
@property(nonatomic, copy)NSString *account_id;
@property(nonatomic, copy)NSString *time_registered;
@property(nonatomic, copy)NSString *nick_name;
@property(nonatomic, copy)NSString *avatar;
@property(nonatomic, copy)NSString *birthday;
@property(nonatomic, copy)NSString *height;
@property(nonatomic, copy)NSString *weight;
@property(nonatomic, copy)NSString *user_id;
@property(nonatomic, copy)NSString *profile_id;
@property(nonatomic, copy)NSString *device_id;

@end
