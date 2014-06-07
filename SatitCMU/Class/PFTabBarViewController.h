//
//  PFTabBarViewController.h
//  PFTabbarContoller
//
//  Created by MRG on 5/19/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCustomBadge.h"
#import "PFTabBarItemButton.h"
#import "AMBlurView.h"

@protocol PFTabBarViewControllerDelegate <NSObject>
@optional

- (void)PFTabBarViewController:(id)sender selectedIndex:(int)index;

@end

@interface PFTabBarViewController : UIViewController

@property (strong, nonatomic) AMBlurView *mainView;
@property (strong, nonatomic) AMBlurView *tabBarView;
@property (strong, nonatomic) UIImageView *tabBarBackgroundImageView;
@property (assign, nonatomic) id <PFTabBarViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *mesg0Label;
@property (weak, nonatomic) IBOutlet UILabel *mesg1Label;
@property (weak, nonatomic) IBOutlet UILabel *mesg2Label;

@property (nonatomic, strong) NSMutableArray *itemButtons;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic, weak) UIView* notificationView;

@property (nonatomic) int selectedIndex;
@property (readonly, nonatomic) int shownNotificationIndex;

- (id)initWithBackgroundImage:(UIImage*)image viewControllers:(id)firstObj, ... ;

- (void)hideTabBarWithAnimation:(BOOL)isAnimated;
- (void)showTabBarWithAnimation:(BOOL)isAnimated;

- (void)setNotificationViewForIndex:(NSUInteger)tabIndex mesg0:(NSString*)mesg0 mesg1:(NSString*)mesg1 mesg2:(NSString*)mesg2;
- (void)hideNotificationView;

@end
