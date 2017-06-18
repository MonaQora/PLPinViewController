//
//  PLConfirmPinViewController.h
//  PLPinViewController
//
//  Created by Ash Thwaites on 09/17/2016.
//  Copyright (c) 2016 Ash Thwaites. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLConfirmPinViewController : UIViewController

@property (nonatomic, strong) NSString *pin;
- (void)pinWasEntered:(NSString *)pin;

@end
