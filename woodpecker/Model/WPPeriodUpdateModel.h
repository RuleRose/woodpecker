//
//  WPPeriodUpdateModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/22.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPPeriodUpdateModel : XJFBaseModel
@property(nonatomic, copy)NSString *period_id;
@property(nonatomic, copy)NSString *modify; //update、delete、create
@end
