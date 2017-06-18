//
//  PLConfirmPinViewController.m
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import "PLConfirmPinViewController.h"
#import "PLFormPinField.h"
#import "PLPinViewController.h"
#import "PLPinWindow.h"
#import "PLPinAppearance.h"

@import PLForm;

@interface PLConfirmPinViewController () <PLFormElementDelegate>
{
    PLFormPinFieldElement *pinElement;
}
@property (weak, nonatomic) IBOutlet PLFormPinField *pinField;
@property (weak, nonatomic) IBOutlet UIImageView *illustration;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end


@implementation PLConfirmPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // lets hook up the element
    PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
    
    pinElement = [PLFormPinFieldElement pinFieldElementWithID:0 pinLength:vc.pinLength delegate:self];
    pinElement.dotSize = [PLPinWindow defaultInstance].pinAppearance.pinSize;
    [self.pinField updateWithElement:pinElement];
    
    [self.pinField becomeFirstResponder];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    self.illustration.hidden = (result.height == 480);
    
    self.pinField.textfield.inputView = [UIView new];
    
    [self setupAppearance];
    
    //    self.navigationItem.leftBarButtonItem = [UIBarButtonItem yvp_backBarButtonItemWithTarget:self action:@selector(popBack)];
}

-(void)popBack
{
    [self performSegueWithIdentifier:@"unwindToCreatPin" sender:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.pinField becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pinField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.pinField resignFirstResponder];
}

-(void)setupAppearance
{
    self.view.backgroundColor = [PLPinWindow defaultInstance].pinAppearance.backgroundColor;
    self.titleLabel.font = [PLPinWindow defaultInstance].pinAppearance.titleFont;
    self.titleLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.titleColor;
    self.messageLabel.font = [PLPinWindow defaultInstance].pinAppearance.messageFont;
    self.messageLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.messageColor;
}

- (void)formElementDidChangeValue:(PLFormElement *)formElement;
{
    if ([pinElement.value isEqualToString:self.pin] )
    {
        PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
        if ([vc.pinDelegate respondsToSelector:@selector(pinViewController:didSetPin:)])
        {
            [vc.pinDelegate pinViewController:vc didSetPin:pinElement.value];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"unwindToCreatPin" sender:nil];
    }
}


@end
