//
//  PLConfirmPinViewController.m
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import "PLConfirmPinViewController.h"
#import "PLPinField.h"
#import "PLPinViewController.h"
#import "PLPinWindow.h"
#import "PLPinAppearance.h"


@interface PLConfirmPinViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end


@implementation PLConfirmPinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = NSLocalizedString(@"REPEAT PIN", @"REPEAT PIN");
    self.messageLabel.text = NSLocalizedString(@"Repeat your pin code to confirm it's correct", @"Repeat your pin code to confirm it's correct");
    
    [self setupAppearance];
}


-(void)setupAppearance
{
    self.view.backgroundColor = [PLPinWindow defaultInstance].pinAppearance.backgroundColor;
    self.titleLabel.font = [PLPinWindow defaultInstance].pinAppearance.titleFont;
    self.titleLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.titleColor;
    self.messageLabel.font = [PLPinWindow defaultInstance].pinAppearance.messageFont;
    self.messageLabel.textColor = [PLPinWindow defaultInstance].pinAppearance.messageColor;
}


- (void)pinWasEntered:(NSString *)pin
{
    if ([pin isEqualToString:self.pin] )
    {
        PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
        if ([vc.pinDelegate respondsToSelector:@selector(pinViewController:didSetPin:)])
        {
            [vc.pinDelegate pinViewController:vc didSetPin:pin];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"unwindToCreatPin" sender:nil];
    }
}


@end
