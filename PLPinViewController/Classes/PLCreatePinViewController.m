//
//  PLCreatePinViewController.m
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import "PLCreatePinViewController.h"
#import "PLPinAppearance.h"
#import "PLPinViewController.h"
#import "PLPinWindow.h"


@interface PLCreatePinViewController () 


@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end


@implementation PLCreatePinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
    
    NSString *messageText = [NSString stringWithFormat:NSLocalizedString(@"Enter a %ld digit pin to keep your data safe", @"Enter a %ld digit pin to keep your data safe"), (long)vc.pinLength];
    self.messageLabel.text = messageText;
    self.titleLabel.text = NSLocalizedString(@"CREATE PIN", @"CREATE PIN");
    self.errorLabel.text = NSLocalizedString(@"Your pin does not match.", @"Your pin does not match.");

    self.errorLabel.alpha = 0;

    [self setupAppearance];
}


-(void)setupAppearance
{
    self.view.backgroundColor = [PLPinWindow defaultInstance].pinAppearance.backgroundColor;
    CAGradientLayer *gradient = [PLPinWindow gradianLayer:self.view.frame];
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    [bgView.layer addSublayer:gradient];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
    
    self.titleLabel.font = [PLPinWindow defaultInstance].pinAppearance.titleFont;
    self.titleLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.titleColor;
    self.messageLabel.font = [PLPinWindow defaultInstance].pinAppearance.messageFont;
    self.messageLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.messageColor;
    self.errorLabel.font = [PLPinWindow defaultInstance].pinAppearance.errorFont;
    self.errorLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.errorColor;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = [segue destinationViewController];
    // set the view controllers user info (same as the ours)
    SEL sel = NSSelectorFromString(@"pin");
    if ([vc respondsToSelector:sel])
    {
        [vc setValue:(NSString *)sender forKey:@"pin"];
    }
}


- (void)pinWasEntered:(NSString *)pin
{
    [self performSegueWithIdentifier:@"advance" sender:pin];
}


- (IBAction)unwindToCreatPin:(UIStoryboardSegue *)unwindSegue
{
    self.errorLabel.alpha = 1;
}

@end
