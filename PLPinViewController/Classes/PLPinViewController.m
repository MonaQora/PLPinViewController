//
//  PLPinViewController.m
//  Pods
//
//  Created by Ash Thwaites on 17/09/2016.
//
//

#import "PLPinViewController.h"
#import "PLCreatePinViewController.h"
#import "PLEnterPinViewController.h"
#import "PLPinWindow.h"
#import "PLSlideTransition.h"
#import "PLFormPinField.h"
#import "PLStyleButton.h"
#import "PLPinAppearance.h"

#define IS_SHORTSCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@interface PLPinViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutletCollection(PLStyleButton) NSArray *numberButtons;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic,strong) NSString *lastIdentifier;
@property (nonatomic,strong) NSString *initialIdentifier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keypadHeightConstraint;

@end

@implementation PLPinViewController

+ (void)showControllerWithAction:(PLPinViewControllerAction)action enableCancel:(BOOL)enableCancel delegate:(id<PLPinViewControllerDelegate>)delegate animated:(BOOL)animated
{
    [self showControllerWithAction:action enableCancel:enableCancel pinLength:4 delegate:delegate animated:animated];
}

+ (void)showControllerWithAction:(PLPinViewControllerAction)action enableCancel:(BOOL)enableCancel  pinLength:(NSInteger)pinLength delegate:(id<PLPinViewControllerDelegate>)delegate animated:(BOOL)animated
{
    PLPinViewController *vc = (PLPinViewController*)[PLPinWindow defaultInstance].rootViewController;
    vc.pinDelegate = delegate;
    vc.enableCancel = enableCancel;
    vc.pinLength = pinLength;
    
    switch (action) {
        case PLPinViewControllerActionCreate:
            vc.initialIdentifier = @"showCreatePin";
            break;
        case PLPinViewControllerActionChange:
            vc.initialIdentifier = @"showChangePin";
            break;
        case PLPinViewControllerActionEnter:
            vc.initialIdentifier = @"showEnterPin";
            break;
            
        default:
            break;
    }
    
    if (vc.initialIdentifier  && [vc isViewLoaded] && vc.view.window)
    {
        [vc performSegueWithIdentifier:vc.initialIdentifier sender:nil];
    }
    [[PLPinWindow defaultInstance] showAnimated:animated];
}

+(void)dismiss
{
    [[PLPinWindow defaultInstance] hideAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupAppearance];
    
    if (self.initialIdentifier)
    {
        [self performSegueWithIdentifier:self.initialIdentifier sender:nil];
        return;
    }
    
    [self performSegueWithIdentifier:@"showEnterPin" sender:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [[PLPinWindow defaultInstance].pinAppearance statusBarStyle];
}

-(void)viewDidLayoutSubviews
{
    for (PLStyleButton *button in self.numberButtons)
    {
        button.cornerRadius = button.bounds.size.width / 2.0f;
    }
    
}

-(void)setupAppearance
{
    PLPinAppearance *appearance = [PLPinWindow defaultInstance].pinAppearance;
    for (PLStyleButton *button in self.numberButtons)
    {
        [button setTintColor:appearance.numberButtonColor];
        [button setTitleColor:appearance.numberButtonTitleColor forState:UIControlStateNormal];
        [button setTitleColor:appearance.numberButtonTitleColor forState:UIControlStateSelected];
        [button setTitleColor:appearance.numberButtonTitleColor forState:UIControlStateHighlighted];
        
        [button.titleLabel setFont:appearance.numberButtonFont];
        button.borderColor = [PLPinWindow defaultInstance].pinAppearance.numberButtonStrokeColor;
        button.borderWidth = [PLPinWindow defaultInstance].pinAppearance.numberButtonStrokeWitdh;
        [button setNeedsDisplay];
    }
    
    [self.deleteButton setTintColor:appearance.deleteButtonColor];
    
    if (IS_SHORTSCREEN)
    {
        self.keypadHeightConstraint.constant = 160;
    }
    else
    {
        self.keypadHeightConstraint.constant = 240;
    }
    
    id dotAppearance = [PLFormPinDot appearanceWhenContainedInInstancesOfClasses:@[[PLPinWindow class]]];
    [dotAppearance setUnselectedBorderColor:[UIColor clearColor]];
    [dotAppearance setHighlightedBorderColor:[UIColor clearColor]];
    [dotAppearance setSelectedBorderColor:appearance.pinHighlightedColor];
    
    [dotAppearance setUnselectedColor:appearance.pinFillColor];
    [dotAppearance setHighlightedColor:appearance.pinFillColor];
    [dotAppearance setSelectedColor:appearance.pinHighlightedColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    self.lastIdentifier = [segue.identifier copy];
    self.initialIdentifier = nil;
    
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        ((UINavigationController*)segue.destinationViewController).delegate = self;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    
}
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    PLSlideTransition *transition = [PLSlideTransition new];
    transition.operation = operation;
    return transition;
}


-(void)presentContainedViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated
{
    if (viewControllerToPresent == nil)
    {
        [_currentController willMoveToParentViewController:nil];
        [_currentController.view removeFromSuperview];
        [_currentController removeFromParentViewController];
        _currentController = nil;
        return;
    }
    
    
    [self addChildViewController:viewControllerToPresent];
    [_currentController willMoveToParentViewController:nil];
    
    viewControllerToPresent.view.frame = self.view.bounds;
    viewControllerToPresent.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (animated)
    {
        viewControllerToPresent.view.alpha = 0.0f;
        
        [self transitionFromViewController:_currentController toViewController:viewControllerToPresent duration:0.3f options:0
                                animations:^
         {
             _currentController.view.alpha = 0.0f;
             viewControllerToPresent.view.transform = CGAffineTransformIdentity;
             viewControllerToPresent.view.alpha = 1.0f;
         }
                                completion:^(BOOL finished)
         {
             [self.view bringSubviewToFront:self.inputView];
             [viewControllerToPresent didMoveToParentViewController:self];
             [_currentController removeFromParentViewController];
             _currentController = viewControllerToPresent;
         }];
    }
    else
    {
        [self.view addSubview:viewControllerToPresent.view];
        [self.view bringSubviewToFront:self.inputView];
        
        [_currentController.view removeFromSuperview];
        [_currentController removeFromParentViewController];
        [viewControllerToPresent didMoveToParentViewController:self];
        _currentController = viewControllerToPresent;
    }
}

- (IBAction)numberButtonPressed:(UIButton*)sender {
    NSString *input = @(sender.tag).stringValue;
    
    UIViewController *vc = _currentController;
    if ([_currentController isKindOfClass:[UINavigationController class]])
    {
        vc = ((UINavigationController*)_currentController).topViewController;
    }
    PLFormPinField *pinField = [self firstPinFieldInView:vc.view];
    if (pinField)
    {
        NSString *text = pinField.textfield.text;
        NSRange insertRange = NSMakeRange(0, 0);
        if (text.length > 0)
        {
            insertRange = NSMakeRange(text.length, 0);
        }
        
        [pinField.textfield.delegate textField:pinField.textfield shouldChangeCharactersInRange:insertRange replacementString:input];
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    UIViewController *vc = _currentController;
    if ([_currentController isKindOfClass:[UINavigationController class]])
    {
        vc = ((UINavigationController*)_currentController).topViewController;
    }
    PLFormPinField *pinField = [self firstPinFieldInView:vc.view];
    if (pinField)
    {
        NSString *text = pinField.textfield.text;
        NSRange deleteRange = NSMakeRange(0, 0);
        if (text.length > 0)
        {
            deleteRange = NSMakeRange(text.length - 1, 1);
        }
        [pinField.textfield.delegate textField:pinField.textfield shouldChangeCharactersInRange:deleteRange replacementString:@""];
    }
}


//
-(PLFormPinField*)firstPinFieldInView:(UIView*)view
{
    for (UIView *subView in view.subviews)
    {
        if ([subView isKindOfClass:[PLFormPinField class]])
            return (PLFormPinField*)subView;
        
        if (subView.subviews.count)
        {
            PLFormPinField *tf = [self firstPinFieldInView:subView];
            if (tf) return tf;
        }
    }
    return nil;
}
@end
