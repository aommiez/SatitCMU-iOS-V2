//
//  PFShowcaseViewController.h
//  SatitCMU
//
//  Created by Pariwat on 5/30/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRGradientNavigationBar.h"
#import "ShowCaseCell.h"
#import "PESatitApiManager.h"

#import "PFGalleryViewController.h"

@protocol PFShowcaseViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFShowcaseViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PESatitApiManager *satitApi;
@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic) IBOutlet CRGradientNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *arrObj;
@property (retain, nonatomic) NSMutableArray *arrObjGallery;
@property (retain, nonatomic) NSMutableArray *sum;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (retain, nonatomic) NSString *paging;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (retain, nonatomic) IBOutlet UILabel *loadLabel;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
