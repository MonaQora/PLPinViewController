//
//  PLPinAppearance.h
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLPinAppearance : NSObject

+ (instancetype)defaultAppearance;

@property (nonatomic, strong) UIColor *numberButtonColor;
@property (nonatomic, strong) UIColor *numberButtonTitleColor;
@property (nonatomic, strong) UIColor *numberButtonStrokeColor;
@property (nonatomic, assign) CGFloat numberButtonStrokeWitdh;
@property (nonatomic, strong) UIFont *numberButtonFont;

@property (nonatomic, strong) UIColor *deleteButtonColor;

@property (nonatomic, strong) UIColor *pinFillColor;
@property (nonatomic, strong) UIColor *pinHighlightedColor;
@property (nonatomic, assign) CGFloat pinSize;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIColor *messageColor;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end
