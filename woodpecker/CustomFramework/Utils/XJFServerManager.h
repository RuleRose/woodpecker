//
//  LeieServerManager.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/8.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJFServerManager : NSObject
@property(nonatomic, copy) NSString *serverURL;

+ (XJFServerManager *)shareManager;
- (void)loadSettingsConfig;
@end
