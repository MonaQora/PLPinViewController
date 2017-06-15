//
//  PLPinViewController.h
//  Pods
//
//  Created by Ash Thwaites on 17/09/2016.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLPinViewControllerAction) {
    PLPinViewControllerActionCreate = 0,
    PLPinViewControllerActionChange,
    PLPinViewControllerActionEnter
};

@class PLPinViewController;
@class PLPinAppearance;

@protocol PLPinViewControllerDelegate <NSObject>

@optional

- (void)pinViewControllerDidCancel:(PLPinViewController *)controller;
- (void)pinViewControllerDidLogout:(PLPinViewController *)controller;
- (void)pinViewController:(PLPinViewController *)controller didChangePin:(NSString*)pin;
- (void)pinViewController:(PLPinViewController *)controller didEnterPin:(NSString*)pin;
- (BOOL)pinViewController:(PLPinViewController *)controller shouldAcceptPin:(NSString*)pin;
- (void)pinViewController:(PLPinViewController *)controller didSetPin:(NSString*)pin;

@end

@interface PLPinViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *currentController;
@property (weak) id<PLPinViewControllerDelegate> pinDelegate;
@property (nonatomic, assign) BOOL enableCancel;
@property (nonatomic, assign) NSInteger pinLength;


+ (void)showControllerWithAction:(PLPinViewControllerAction)action enableCancel:(BOOL)enableCancel delegate:(id<PLPinViewControllerDelegate>)delegate animated:(BOOL)animated __attribute__((deprecated("Replaced by + (void)showControllerWithAction:(PLPinViewControllerAction)action enableCancel:(BOOL)enableCancel  pinLength:(NSInteger)pinLength delegate:(id<PLPinViewControllerDelegate>)delegate animated:(BOOL)animated")));

+ (void)showControllerWithAction:(PLPinViewControllerAction)action enableCancel:(BOOL)enableCancel pinLength:(NSInteger)pinLength delegate:(id<PLPinViewControllerDelegate>)delegate animated:(BOOL)animated;



+(void)dismiss;


-(void)presentContainedViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated;

@end
