//
//  PLPinField.m
//  PLPinViewController
//
//  Created by Ash Thwaites on 11/12/2015.
//  Copyright (c) 2015 Pitch Labs. All rights reserved.
//


#import "PLPinField.h"

@import PureLayout;

@interface PLPinField ()
{
    UITapGestureRecognizer *insideTapGestureRecognizer;
    UITapGestureRecognizer *outsideTapGestureRecognizer;

    NSArray *dotViews;
    NSArray *underlineViews;
}

@end

@implementation PLPinField
{
    NSCharacterSet *numberSet;
    NSCharacterSet *noNumberSet;
}

-(void)setup
{
    //set up the reject character set
    NSMutableCharacterSet *numSet = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
    [numSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    numberSet = numSet;
    noNumberSet = [numberSet invertedSet];
    
    insideTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapInside:)];
    [self addGestureRecognizer:insideTapGestureRecognizer];
    outsideTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOutside:)];
    
    _unselectedUnderlineColor = [UIColor darkGrayColor];
    _highlightedUnderlineColor = [UIColor darkGrayColor];
    _selectedUnderlineColor = [UIColor darkGrayColor];
    
    _borderColor = [UIColor blackColor];
    _borderWidth = 0;
    _cornerRadius = 0;
}

-(void)dealloc
{
    [outsideTapGestureRecognizer.view removeGestureRecognizer:outsideTapGestureRecognizer];
    [insideTapGestureRecognizer.view removeGestureRecognizer:insideTapGestureRecognizer];
}

- (void) setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void) setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void) setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)onTapInside:(UIGestureRecognizer*)sender
{
    UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
    [frontWindow addGestureRecognizer:outsideTapGestureRecognizer];
}

- (void)onTapOutside:(UIGestureRecognizer*)sender
{
    [sender.view removeGestureRecognizer:outsideTapGestureRecognizer];
}



@end
