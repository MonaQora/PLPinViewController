//
//  PLPinAppearance.m
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import "PLPinAppearance.h"

@implementation PLPinAppearance


+ (instancetype)defaultAppearance {
    PLPinAppearance *defaultAppearance = [[PLPinAppearance alloc]init];
    return defaultAppearance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDefaultAppearance];
    }
    return self;
}

-(void)setupDefaultAppearance {
    UIColor *defaultColor = [UIColor colorWithRed:46.0f / 255.0f green:192.0f / 255.0f blue:197.0f / 255.0f alpha:1];
    UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0f];
    
    self.numberButtonColor = defaultColor;
    self.numberButtonTitleColor = [UIColor blackColor];
    self.numberButtonStrokeColor = defaultColor;
    self.numberButtonStrokeWitdh = 0.8f;
    self.numberButtonFont = defaultFont;
    
    self.deleteButtonColor = defaultColor;
    
    self.pinFillColor = [UIColor blackColor];
    self.pinHighlightedColor = defaultColor;
    self.pinSize = 20;

    self.backgroundColor = [UIColor whiteColor];
    self.titleFont = [UIFont systemFontOfSize:17];
    self.titleColor = [UIColor colorWithRed:30.0f / 255.0f green:175.0f / 255.0f blue:216.0f / 255.0f alpha:1];
    self.messageFont = [UIFont systemFontOfSize:17];
    self.messageColor = [UIColor colorWithRed:131.0f / 255.0f green:136.0f / 255.0f blue:152.0f / 255.0f alpha:1];
    
    self.statusBarStyle = UIStatusBarStyleDefault;
}

@end
