//
//  PENotifyViewController.h
//  SatitCMU
//
//  Created by MRG on 3/24/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFNotificationCell.h"
#import "PESatitApiManager.h"
#import "AMBlurView.h"

@protocol PFNotifyViewControllerDelegate <NSObject>

- (void)PFNotifyViewControllerBack;

@end

@interface PFNotifyViewController : UIViewController

@property (assign, nonatomic) id<PFNotifyViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PESatitApiManager *satitApi;

@property (retain, nonatomic) NSArray *tableData;
@property (retain, nonatomic) NSDictionary *obj;
@property (retain, nonatomic) NSString *nString;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) IBOutlet AMBlurView *blurView;
@property (retain, nonatomic) IBOutlet UITextView *textView;

@end
