//
//  PLEnterPinViewController.m
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import "PLEnterPinViewController.h"
#import "PLPinViewController.h"
#import "PLPinWindow.h"
#import "PLPinAppearance.h"


@interface PLEnterPinViewController ()

@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *forgottenPinLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property CGFloat errorMessageVisibleDuration;

@end


@implementation PLEnterPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
    self.cancelButton.hidden = !vc.enableCancel;

    [self setupAppearance];
}


-(void)setupAppearance
{
    self.view.backgroundColor = [PLPinWindow defaultInstance].pinAppearance.backgroundColor;
    self.errorView.backgroundColor = [PLPinWindow defaultInstance].pinAppearance.backgroundColor;
    self.titleLabel.font = [PLPinWindow defaultInstance].pinAppearance.titleFont;
    self.titleLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.titleColor;
    self.messageLabel.font = [PLPinWindow defaultInstance].pinAppearance.messageFont;
    self.messageLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.messageColor;
    self.forgottenPinLabel.font = [PLPinWindow defaultInstance].pinAppearance.logoutLabelFont;
    self.forgottenPinLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.logoutLabelTextColor;
    self.errorLabel.font = [PLPinWindow defaultInstance].pinAppearance.errorFont;
    self.errorLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.errorColor;

    self.titleLabel.text = NSLocalizedString(@"WELCOME BACK", @"WELCOME BACK");
    self.messageLabel.text = NSLocalizedString(@"Enter your pin code to log in", @"Enter your pin code to log in");
    self.forgottenPinLabel.text = NSLocalizedString(@"Forgotten Pin?", "Forgotten Pin?");
    self.errorLabel.text = NSLocalizedString(@"You have entered an incorrect pin.", "You have entered an incorrect pin.");
    
    [self.cancelButton setTitle: NSLocalizedString(@"", @"") forState: UIControlStateNormal];
    self.cancelButton.titleLabel.font = [PLPinWindow defaultInstance].pinAppearance.cancelButtonFont;
    [self.cancelButton setTitleColor:[PLPinWindow defaultInstance].pinAppearance.cancelButtonTextColor forState:UIControlStateNormal];
    
    [self.cancelButton setTitleColor:[PLPinWindow defaultInstance].pinAppearance.cancelButtonTextColor forState:UIControlStateNormal];

    [self.cancelButton setTintColor:[PLPinWindow defaultInstance].pinAppearance.cancelButtonTintColor];
    
    [self.logoutButton setTitle: NSLocalizedString(@"Log Out", @"Log Out") forState: UIControlStateNormal];
    self.logoutButton.titleLabel.font = [PLPinWindow defaultInstance].pinAppearance.logoutButtonFont;
    [self.logoutButton setTitleColor:[PLPinWindow defaultInstance].pinAppearance.logoutButtonTextColor forState:UIControlStateNormal];
    
    self.errorMessageVisibleDuration = [PLPinWindow defaultInstance].pinAppearance.enterPinErrorMessageVisibleDuration;
    
    self.errorView.alpha = 0.0f;
}


- (void)pinWasEntered:(NSString *)pin;
{
    PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
    if ([vc.pinDelegate respondsToSelector:@selector(pinViewController:shouldAcceptPin:)])
    {
        if ([vc.pinDelegate pinViewController:vc shouldAcceptPin:pin])
        {
            [self correctPin: pin];
        }
        else
        {
            [self incorrectPin: pin];
        }
    }
}


-(void)correctPin:(NSString *)pin
{
    PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
    if ([vc.pinDelegate respondsToSelector:@selector(pinViewController:didEnterPin:)])
    {
        [vc.pinDelegate pinViewController:vc didEnterPin:pin];
    }
}


-(void)incorrectPin:(NSString *)pin
{
    self.errorView.alpha = 0.0f;
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3f animations:^{
        self.errorView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        
        //reset dots
        [self.navigationController.delegate navigationController: self.navigationController
                                           didShowViewController:self
                                                        animated:NO];
        
        [UIView animateWithDuration:0.3f
                              delay:self.errorMessageVisibleDuration
                            options:0
                         animations:^{
                             self.errorView.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                         }];
        
    }];
    
    return;
}


- (IBAction)logoutPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Logout", @"Logout")
                                          message:NSLocalizedString(@"Are you sure you want to logout?",@"Are you sure you want to logout?")
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
                                   if ([vc.pinDelegate respondsToSelector:@selector(pinViewControllerDidLogout:)])
                                   {
                                       [vc.pinDelegate pinViewControllerDidLogout:vc];
                                   }
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)cancelPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
    if ([vc.pinDelegate respondsToSelector:@selector(pinViewControllerDidCancel:)])
    {
        [vc.pinDelegate pinViewControllerDidCancel:vc];
    }
}


@end
