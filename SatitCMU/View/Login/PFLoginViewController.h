//
//  PELoginViewController.h
//  SatitCMU
//
//  Created by MRG on 2/27/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIERealTimeBlurView.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+MTAnimation.h"
#import "PESatitApiManager.h"

@protocol PFLoginViewControllerDelegate <NSObject>

- (void)PFAccountViewController:(id)sender;
- (void)PFNotifyViewController:(id)sender;

@end
@interface PFLoginViewController : UIViewController <FBLoginViewDelegate,UITextFieldDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UITextField *emailSignIn;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignIn;
@property (strong, nonatomic) PESatitApiManager *satitApi;

- (IBAction)signupTapeed:(id)sender;
- (IBAction)bgTapped:(id)sender;
- (IBAction)signinTapped:(id)sender;
- (IBAction)dateBTapped:(id)sender;
- (IBAction)sumitTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *emailSignUp;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignUp;
@property (weak, nonatomic) IBOutlet UITextField *confirmSignUp;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthSignUp;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectGender;

@property (retain, nonatomic) UIDatePicker *pick;
@property (retain, nonatomic) UIButton *pickDone;

@property (strong, nonatomic) NSString *menu;

@end
