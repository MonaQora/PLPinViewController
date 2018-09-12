//
//  PLPinButton.m
//  Pods
//
//  Created by Ash Thwaites on 15/10/2016.
//
//

#import "PLPinButton.h"

@implementation PLPinButton

-(void)setup
{
    _borderColor = [UIColor blackColor];
    _borderWidth = 0;
    _cornerRadius = 0;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
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

- (void) setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.layer.backgroundColor = _backgroundColor.CGColor;
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = (highlighted) ?  [UIColor clearColor]:  self.borderColor;
}

@end
