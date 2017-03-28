//
//  PLViewController.m
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import "PLExampleViewController.h"

@import PLPinViewController;

@interface PLExampleViewController ()   

@end

@implementation PLExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // configure the appearance
    PLPinAppearance *pinAppearance = [PLPinAppearance defaultAppearance];
    pinAppearance.backgroundColor = [UIColor lightGrayColor];
    pinAppearance.statusBarStyle = UIStatusBarStyleLightContent;
    [PLPinWindow defaultInstance].pinAppearance = pinAppearance;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createPinPressed:(id)sender {
    [PLPinViewController showControllerWithAction:PLPinViewControllerActionCreate enableCancel:NO delegate:self animated:YES];
}

- (IBAction)changePinPressed:(id)sender {
    [PLPinViewController showControllerWithAction:PLPinViewControllerActionChange enableCancel:YES delegate:self animated:YES];
}


- (IBAction)enterPinPressed:(id)sender {
    [PLPinViewController showControllerWithAction:PLPinViewControllerActionEnter enableCancel:YES delegate:self animated:YES];
}

- (void)pinViewControllerDidCancel:(PLPinViewController *)controller;
{
    [PLPinViewController dismiss];
}

- (void)pinViewControllerDidLogout:(PLPinViewController *)controller;
{
    [PLPinViewController dismiss];
}

- (void)pinViewController:(PLPinViewController *)controller didChangePin:(NSString*)pin;
{
    [PLPinViewController dismiss];
    
}

- (BOOL)pinViewController:(PLPinViewController *)controller shouldAcceptPin:(NSString*)pin;
{
    return [pin isEqualToString:@"1111"];
}

- (void)pinViewController:(PLPinViewController *)controller didEnterPin:(NSString*)pin;
{
    [PLPinViewController dismiss];
    
}

- (void)pinViewController:(PLPinViewController *)controller didSetPin:(NSString*)pin;
{
    [PLPinViewController dismiss];
    
}





@end
