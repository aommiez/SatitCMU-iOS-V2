//
//  PFGalleryViewController.h
//  SatitCMU
//
//  Created by Pariwat on 6/1/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRGradientNavigationBar.h"

@protocol PFGalleryViewControllerDelegate <NSObject>

- (void)PFGalleryViewControllerBack;

@end

@interface PFGalleryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic) IBOutlet CRGradientNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (assign, nonatomic) id <PFGalleryViewControllerDelegate> delegate;

@end
