//
//  WPEventModel.m
//  woodpecker
//
//  Created by QiWL on 2017/10/8.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPEventModel.h"

@implementation WPEventModel
- (void)setTheme:(WPRecordTheme)theme detail:(NSString *)detail{
    switch (theme) {
        case kWPRecordThemeOfColor:
            self.color = detail;
            break;
        case kWPRecordThemeOfFlow:
            self.flow = detail;
            break;
        case kWPRecordThemeOfPain:
            self.pain = detail;
            break;
        case kWPRecordThemeOfGore:
            self.gore = detail;
            break;
        case kWPRecordThemeOfMucusProb:
            self.mucus_prob = detail;
            break;
        case kWPRecordThemeOfMucusFlow:
            self.mucus_flow = detail;
            break;
        case kWPRecordThemeOfLove:
            self.love = detail;
            break;
        case kWPRecordThemeOfCT:
            self.ct = detail;
            break;
        case kWPRecordThemeOfSleep:
            self.sleep = detail;
            break;
        case kWPRecordThemeOfMood:
            self.mood = detail;
            break;
        case kWPRecordThemeOfSport:
            self.sport = detail;
            break;
        case kWPRecordThemeOfDrink:
            self.drink = detail;
            break;
        case kWPRecordThemeOfDrug:
            self.drug = detail;
            break;
        case kWPRecordThemeOfComments:
            self.comments = detail;
            break;
        case kWPRecordThemeOfWeight:
            self.weight = detail;
            break;
    }
}
@end
