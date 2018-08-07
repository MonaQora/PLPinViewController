//
//  PLPinButton.h
//  Pods
//
//  Created by Ash Thwaites on 15/10/2016.
//
//

#import <UIKit/UIKit.h>

@interface PLPinButton : UIButton

@property (nonatomic,strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat borderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

@end
