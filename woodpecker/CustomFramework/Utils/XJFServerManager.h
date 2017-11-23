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
@property (nonatomic,copy) NSString *APP_ID;
@property (nonatomic,copy) NSString *APP_SECRET;

+ (XJFServerManager *)shareManager;
- (void)loadSettingsConfig;
@end
