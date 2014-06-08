//
//  PFActivityViewController.h
//  SatitCMU
//
//  Created by Pariwat on 5/30/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRGradientNavigationBar.h"
#import "PESatitApiManager.h"
#import "UIERealTimeBlurView.h"

#import "ActivityCell.h"
#import "PFActivityCalendarViewController.h"
#import "PFActivityDetailViewController.h"

@protocol PFActivityViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)HideTabbar;
- (void)ShowTabbar;

@end
@interface PFActivityViewController : UIViewController <PFActivityDetailViewControllerDelegate,PFActivityCalendarViewControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic) IBOutlet CRGradientNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSMutableArray *arrObj;

@property (weak, nonatomic) IBOutlet UILabel *mtext;
@property (strong, nonatomic) PESatitApiManager *satitApi;
@property UIERealTimeBlurView *blur;
@property (retain, nonatomic) NSString *paging;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (retain, nonatomic) IBOutlet UILabel *loadLabel;

@property (retain, nonatomic) IBOutlet UIView *headerView;

- (IBAction)filterTapped:(id)sender;

@end
