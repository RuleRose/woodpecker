//
//  WPEventModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/8.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPEventModel : XJFBaseModel
@property(nonatomic, copy)NSString *date;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *theme_type;
@property(nonatomic, copy)NSString *detail;
@property(nonatomic, copy)NSString *extra_data;
@property(nonatomic, copy)NSString *software_rev;
@property(nonatomic, copy)NSString *lastupdate;
@property(nonatomic, copy)NSString *removed;
@end
