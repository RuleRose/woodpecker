//
//  WPTempNoteView.h
//  woodpecker
//
//  Created by QiWL on 2017/10/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCalendarNote.h"

@interface WPTempNoteView : UIView
@property(nonatomic, strong) WPCalendarNote *menstrualNote;
@property(nonatomic, strong) WPCalendarNote *safeNote;
@property(nonatomic, strong) WPCalendarNote *pregnancyNote;
@property(nonatomic, strong) WPCalendarNote *ovipositNote;
@end
