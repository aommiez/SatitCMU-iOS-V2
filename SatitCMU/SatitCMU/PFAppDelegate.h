//
//  PFAppDelegate.h
//  SatitCMU
//
//  Created by MRG on 5/30/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFUpdateViewController.h"
#import "PFtabbar.h"

@interface PFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PFUpdateViewController *update;
@property (strong, nonatomic) PFtabbar *tabbar;

@end
