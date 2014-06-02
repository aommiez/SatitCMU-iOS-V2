//
//  PFAppDelegate.h
//  SatitCMU
//
//  Created by MRG on 5/30/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFTabBarViewController.h"
#import "PFTabBarItemButton.h"

#import "PESatitApiManager.h"

#import "PFUpdateViewController.h"
#import "PFShowcaseViewController.h"
#import "PFActivityViewController.h"
#import "PFContactViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import "SDImageCache.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface PFAppDelegate : UIResponder <UIApplicationDelegate,MWPhotoBrowserDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PFTabBarViewController *tabBarViewController;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (strong, nonatomic) PESatitApiManager *satitApi;

@end
