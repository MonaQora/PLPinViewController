//
//  PLChangePinViewController.m
//  Pods
//
//  Created by Ash Thwaites on 19/09/2016.
//
//

#import "PLChangePinViewController.h"

@interface PLEnterPinViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end


@implementation PLChangePinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = NSLocalizedString(@"CHANGE PIN", @"CHANGE PIN");
    self.messageLabel.text = NSLocalizedString(@"Enter your existing pin code", @"Enter your existing pin code");
}

-(void)correctPin:(NSString *)pin
{
    [self performSegueWithIdentifier:@"advance" sender:pin];
}


@end
