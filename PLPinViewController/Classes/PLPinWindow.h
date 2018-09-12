//
//  PLPinWindow.h
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLPinAppearance;

@interface PLPinWindow : UIWindow

+ (instancetype)defaultInstance;

@property (nonatomic, strong) PLPinAppearance *pinAppearance;

-(void)showAnimated:(BOOL)animated;
-(void)hideAnimated:(BOOL)animated;
+ (CAGradientLayer*) gradianLayer:(CGRect)frame;

@end
