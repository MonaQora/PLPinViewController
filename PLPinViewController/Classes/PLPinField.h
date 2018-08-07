//
//  PLPinField.h
//  PLPinViewController
//
//  Created by Ash Thwaites on 11/12/2015.
//  Copyright (c) 2015 Pitch Labs. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PLPinDot.h"

@interface PLPinField : UIView

@property (nonatomic,strong) UIColor *unselectedUnderlineColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor *selectedUnderlineColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor *highlightedUnderlineColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

@end
