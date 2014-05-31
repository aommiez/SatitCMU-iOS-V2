//
//  PEContactViewController.h
//  SatitCMU
//
//  Created by MRG on 1/31/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRGradientNavigationBar.h"
#import "DLImageLoader.h"
#import "PESatitApiManager.h"
#import "UILabel+UILabelDynamicHeight.h"
#import <MessageUI/MessageUI.h> 
#import "ContactLabelDescCell.h"
#import "PFWebViewViewController.h"
#import "PFMapViewController.h"

@protocol PFContactViewControllerDelegate <NSObject>

- (void)PFContactViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFContactViewController : UIViewController<MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,PFWebViewViewControllerDelegate,PFMapViewControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (weak, nonatomic) IBOutlet CRGradientNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *mapImage;
@property (strong, nonatomic) UIImage *imgMap;
@property (strong, nonatomic) PESatitApiManager *satitApi;
@property NSMutableArray *ArrImgs;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *descLabel;
@property (strong, nonatomic) NSDictionary *obj;

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *youtubeButton;

@property (weak, nonatomic) IBOutlet UIView *menuListView;
- (IBAction)mapTapped:(id)sender;

- (IBAction)callTapped:(id)sender;
- (IBAction)websiteTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
- (IBAction)facebookTapped:(id)sender;
- (IBAction)youtubeTapped:(id)sender;
- (IBAction)insideTapped:(id)sender;
- (IBAction)powerbyTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) NSString *cellSize;

@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) IBOutlet UILabel *address;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *phoneshow;

@property (retain, nonatomic) NSMutableArray *arrcontactimg;
@property (strong, nonatomic) NSString *current;

@end
