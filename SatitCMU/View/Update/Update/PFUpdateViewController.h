//
//  PFUpdateViewController.h
//  SatitCMU
//
//  Created by Pariwat on 5/30/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRGradientNavigationBar.h"
#import "PESatitApiManager.h"
#import "UIERealTimeBlurView.h"
#import "BBBadgeBarButtonItem.h"
#import "AFNetworking.h"

#import "UpdateCell.h"
#import "PFNotifyViewController.h"
#import "PFAccountViewController.h"
#import "PFUpdateDetailViewController.h"
#import "PFActivityDetailViewController.h"
#import "PFGalleryViewController.h"

@protocol PFUpdateViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFUpdateViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic) IBOutlet CRGradientNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PESatitApiManager *satitApi;
@property (retain, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;
@property UIERealTimeBlurView *blur;

- (IBAction)filterTapped:(id)sender;

@property (retain, nonatomic) NSString *paging;

@property (nonatomic, weak ) NSString *desText;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property AFHTTPRequestOperationManager *manager;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (retain, nonatomic) IBOutlet UILabel *loadLabel;

@end
