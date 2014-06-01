//
//  PEActivityDetailViewController.h
//  SatitCMU
//
//  Created by MRG on 3/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UILabel+UILabelDynamicHeight.h"
#import "PESatitApiManager.h"
#import <Social/Social.h>

#import "PFNewsCommentCell.h"
#import "PFSeeAccountViewController.h"

@protocol PFActivityDetailViewControllerDelegate <NSObject>

- (void)PFActivityDetailViewControllerPhoto:(NSString *)link;
- (void)PFActivityDetailViewControllerBack;

@end

@interface PFActivityDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,PFNewsCommentCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSDictionary *obj;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *labelMsg;
@property (strong, nonatomic) IBOutlet UIButton *summitButton;
@property (strong, nonatomic) PESatitApiManager *satitApi;

- (IBAction)bgTapped:(id)sender;
- (IBAction)joinTapped:(id)sender;
- (IBAction)postCommentTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *textCommentView;
@property (weak, nonatomic) IBOutlet UIButton *postBut;
@property (weak, nonatomic) IBOutlet UITextView *textComment;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSString *prevString;
@property (strong, nonatomic) NSString *paging;

@property (assign, nonatomic) id <PFActivityDetailViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIView *waitView;
@property (retain, nonatomic) IBOutlet UIView *popupwaitView;

@end
