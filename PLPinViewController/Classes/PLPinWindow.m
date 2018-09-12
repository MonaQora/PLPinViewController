//
//  PLPinWindow.m
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import "PLPinWindow.h"
#import "PLPinViewController.h"
#import "PLPinAppearance.h"

@interface PLPinWindow ()

@end

@implementation PLPinWindow

+ (instancetype)defaultInstance {
    static PLPinWindow *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedInstance.pinAppearance = [PLPinAppearance defaultAppearance];
        
        // attempt to load from main bundle so host app can override
        UIStoryboard *storyboard = nil;
        @try {
            storyboard = [UIStoryboard storyboardWithName:@"PLPinViewController" bundle:nil];
        }
        @catch (NSException *exception) {
            NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
            NSURL *bundleUrl = [podBundle URLForResource:@"PLPinViewController" withExtension:@"bundle"];
            NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
            storyboard = [UIStoryboard storyboardWithName:@"PLPinViewController" bundle:bundle];
        }

        PLPinViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PLPinViewController"];
        sharedInstance.rootViewController = vc;
    });
    return sharedInstance;
}

-(void)dealloc
{
    NSLog(@"dealloc pin windows");
}

-(void)showAnimated:(BOOL)animated
{
    if (animated)
    {
        self.alpha = 0.0;
        self.hidden = NO;
        [self.window makeKeyAndVisible];
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            // do anything here?
        }];
    }
    else
    {
        self.alpha = 1.0;
        self.hidden = NO;
        [self makeKeyAndVisible];
    }
}

-(void)hideAnimated:(BOOL)animated
{
    // need to find the main window of the app delegate
    if (animated)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            // get the original window.. (bit of an assumption)
            [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyAndVisible];

            self.hidden = YES;
            
            PLPinViewController *vc = (PLPinViewController*)self.rootViewController;
            [vc presentContainedViewController:nil animated:NO];
        }];
    }
    else
    {
        self.alpha = 0.0;
        self.hidden = YES;
        // get the original window.. (bit of an assumption)
        [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyAndVisible];
        
        PLPinViewController *vc = (PLPinViewController*)self.rootViewController;
        [vc presentContainedViewController:nil animated:NO];
    }
}


+ (CAGradientLayer*) gradianLayer:(CGRect)frame {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects:(id)[[PLPinWindow defaultInstance].pinAppearance.gradienUpperColor CGColor],(id)[[PLPinWindow defaultInstance].pinAppearance.gradienBottomColor CGColor], nil];
    return gradient;
}

@end
