//
//  PESeeAccountViewController.h
//  SatitCMU
//
//  Created by MRG on 3/15/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

#import "PESatitApiManager.h"

@protocol PFSeeAccountViewControllerDelegate <NSObject>

- (void)PFSeeAccountViewController:(id)sender viewPicture:(NSString *)link;

@end

@interface PFSeeAccountViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) PESatitApiManager *satitManager;

@property (weak, nonatomic) IBOutlet AsyncImageView *userPicture;
@property (weak, nonatomic) IBOutlet UITextField *displayName;
@property (weak, nonatomic) IBOutlet UITextField *emailShow;
@property (weak, nonatomic) IBOutlet UITextField *phoneShow;

- (IBAction)userPictureTapped:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
