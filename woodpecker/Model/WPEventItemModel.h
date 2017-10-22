//
//  WPEventItemModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/22.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPEventItemModel : XJFBaseModel
@property(nonatomic, copy) NSString *event_id;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *brief;
@property(nonatomic, copy) NSString *extra_data;
@property(nonatomic, copy) NSString *lastupdate;
@property(nonatomic, copy) NSString *removed;

@end
