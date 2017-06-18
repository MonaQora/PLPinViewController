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
#define DOT_CONTAINER_TAG 1111

@interface PLPinViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutletCollection(PLStyleButton) NSArray *numberButtons;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic,strong) NSString *lastIdentifier;
@property (nonatomic,strong) NSString *initialIdentifier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keypadHeightConstraint;

@property (nonatomic, strong) NSMutableString *currentPin;

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
    
    self.currentPin = [[NSMutableString alloc] init];
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
    
    id dotAppearance = [PLFormPinDot appearanceWhenContainedInInstancesOfClasses:@[[UIStackView class]]];
    [dotAppearance setUnselectedBorderColor:[UIColor clearColor]];
    [dotAppearance setHighlightedBorderColor:[UIColor clearColor]];
    [dotAppearance setSelectedBorderColor:appearance.pinHighlightedColor];
    
    [dotAppearance setUnselectedColor:appearance.pinFillColor];
    [dotAppearance setHighlightedColor:appearance.pinHighlightedColor];
    [dotAppearance setSelectedColor:appearance.pinHighlightedColor];
}


- (void)setupDots
{
    UIStackView *containerView = [self firstPinContainerInView:self.view];
    
    if (containerView.subviews.count == 0)
    {
        NSInteger dotSize = [PLPinWindow defaultInstance].pinAppearance.pinSize;
        
        for (int i=0; i < self.pinLength; i++)
        {
            PLFormPinDot *dot = [PLFormPinDot new];
            dot.tag = i;
            
            [dot.heightAnchor constraintEqualToConstant:dotSize].active = YES;
            [dot.widthAnchor constraintEqualToConstant:dotSize].active = YES;
            
            [containerView addArrangedSubview: dot];
        }
    }
    
    for (PLFormPinDot *dot in containerView.subviews)
    {
        dot.state = PLPinDotStateUnselected;
    }
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


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    [self.currentPin setString:@""];
    [self setupDots];
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


- (IBAction)numberButtonPressed:(UIButton*)sender
{
    [self.currentPin appendString:@(sender.tag).stringValue];
    NSInteger currentPinCharacter = self.currentPin.length - 1;
    
    [self setState:PLPinDotStateHighlighted forDotWithTag:currentPinCharacter];
    
    if (self.currentPin.length == self.pinLength)
    {
        UINavigationController *nc = (UINavigationController *)self.currentController;
        id currentlyDisplayingController = nc.topViewController;
        
        if ([currentlyDisplayingController respondsToSelector:@selector(pinWasEntered:)])
        {
            [currentlyDisplayingController pinWasEntered:[self.currentPin copy]];
        }
    }
}


- (IBAction)deleteButtonPressed:(id)sender
{
    if (self.currentPin.length > 0)
    {
        [self.currentPin deleteCharactersInRange:NSMakeRange([self.currentPin length] - 1, 1)];
        NSInteger currentPinCharacter = self.currentPin.length;
        
        [self setState:PLPinDotStateUnselected forDotWithTag:currentPinCharacter];
    }
}


- (void)setState:(PLPinDotState)state forDotWithTag:(NSInteger)tag
{
    UIStackView *containerView = [self firstPinContainerInView:self.view];
    PLFormPinDot *dot = (PLFormPinDot *)[containerView viewWithTag:tag];
    dot.state = state;
}


-(UIStackView*)firstPinContainerInView:(UIView*)view
{
    for (UIView *subView in view.subviews)
    {
        if (subView.tag == DOT_CONTAINER_TAG)
        {
            return (UIStackView*)subView;
        }
        
        if (subView.subviews.count)
        {
            UIStackView *sv = [self firstPinContainerInView:subView];
            
            if (sv)
            {
                return sv;
            }
        }
    }
    return nil;
}


@end
