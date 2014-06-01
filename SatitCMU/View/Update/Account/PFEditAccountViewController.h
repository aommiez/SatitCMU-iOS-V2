//
//  PEEditAccountViewController.h
//  SatitCMU
//
//  Created by Pariwat on 5/29/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PESatitApiManager.h"

#import "AsyncImageView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SDImageCache.h"
#import <FacebookSDK/FacebookSDK.h>

@protocol PFEditAccountViewControllerDelegate <NSObject>

- (void)PFEditAccountViewControllerBack;

@end

@interface PFEditAccountViewController : UIViewController <UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)alertUpload;

@property NSDictionary *coreData;
@property (strong, nonatomic) IBOutlet UIView *editProfileView;

@property (weak, nonatomic) IBOutlet UITextField *editDisplayNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *editFacebookNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *editEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *editPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *editPasswordTextField;

@property (strong, nonatomic) PESatitApiManager *satitApi;

- (IBAction)uploadPictureTapped:(id)sender;
@property (weak, nonatomic) IBOutlet AsyncImageView *picImg;

@property (retain, nonatomic) IBOutlet UISwitch *pushNews;
@property (retain, nonatomic) IBOutlet UISwitch *pushShowcase;
@property (retain, nonatomic) IBOutlet UISwitch *pushFromSatit;

- (IBAction)pushUpdateChange:(id)sender;
- (IBAction)pushShowCaseChange:(id)sender;
- (IBAction)pushNewsFromSatitChange:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
