//
//  PEAccountViewController.h
//  SatitCMU
//
//  Created by MRG on 2/17/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PESatitApiManager.h"

#import "PFEditAccountViewController.h"

#import "AsyncImageView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SDImageCache.h"
#import <FacebookSDK/FacebookSDK.h>

@protocol PFAccountViewControllerDelegate <NSObject>

- (void)PFAccountViewControllerBack;
- (void)PFAccountViewController:(id)sender viewPicture:(NSString *)link;

@end

@interface PFAccountViewController : UIViewController <UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FBLoginViewDelegate>

@property (assign, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *formView;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logoutTapped:(id)sender;
- (IBAction)picFullTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *usernameShow;
@property (weak, nonatomic) IBOutlet UITextField *facebookNameShow;
@property (weak, nonatomic) IBOutlet UITextField *emailShow;
@property (weak, nonatomic) IBOutlet UITextField *telShow;
@property NSDictionary *coreData;
@property (weak, nonatomic) IBOutlet AsyncImageView *thumUser;
@property (nonatomic, strong) UIImagePickerController *ctr;

@property (strong, nonatomic) PESatitApiManager *satitApi;

@property (retain, nonatomic) IBOutlet UISwitch *pushNewsShow;
@property (retain, nonatomic) IBOutlet UISwitch *pushShowcaseShow;
@property (retain, nonatomic) IBOutlet UISwitch *pushActivityShow;
@property (retain, nonatomic) IBOutlet UISwitch *pushFromSatitShow;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
