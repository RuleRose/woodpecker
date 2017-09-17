//
//  WPCalendarNoteView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPCalendarNoteView.h"

@implementation WPCalendarNoteView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _menstrualNote = [[WPCalendarNote alloc] initWithFrame:CGRectMake(0, 0, self.width/4, self.height)];
    _menstrualNote.backgroundColor = [UIColor clearColor];
    _menstrualNote.period = kPeriodTypeOfMenstrual;
    [self addSubview:_menstrualNote];
    _pregnancyNote = [[WPCalendarNote alloc] initWithFrame:CGRectMake(self.width/4, 0, self.width/4, self.height)];
    _pregnancyNote.backgroundColor = [UIColor clearColor];
    _pregnancyNote.period = kPeriodTypeOfPregnancy;
    [self addSubview:_pregnancyNote];
    _forecastNote = [[WPCalendarNote alloc] initWithFrame:CGRectMake(self.width/2, 0, self.width/4, self.height)];
    _forecastNote.backgroundColor = [UIColor clearColor];
    _forecastNote.period = kPeriodTypeOfForecast;
    [self addSubview:_forecastNote];
    _ovipositNote = [[WPCalendarNote alloc] initWithFrame:CGRectMake(self.width*3/4, 0, self.width/4, self.height)];
    _ovipositNote.backgroundColor = [UIColor clearColor];
    _ovipositNote.period = kPeriodTypeOfOviposit;
    [self addSubview:_ovipositNote];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
