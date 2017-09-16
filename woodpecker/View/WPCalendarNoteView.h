//
//  WPCalendarNoteView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCalendarNote.h"

@interface WPCalendarNoteView : UIView
@property(nonatomic, strong) WPCalendarNote *menstrualNote;
@property(nonatomic, strong) WPCalendarNote *pregnancyNote;
@property(nonatomic, strong) WPCalendarNote *forecastNote;
@property(nonatomic, strong) WPCalendarNote *ovipositNote;

@end
