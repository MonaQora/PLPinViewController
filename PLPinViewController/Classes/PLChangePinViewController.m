//
//  PLChangePinViewController.m
//  Pods
//
//  Created by Ash Thwaites on 19/09/2016.
//
//

#import "PLChangePinViewController.h"

@implementation PLChangePinViewController

-(void)correctPin:(NSString *)pin
{
    [self performSegueWithIdentifier:@"advance" sender:pin];
}


@end
