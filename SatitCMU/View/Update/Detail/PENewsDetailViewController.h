//
//  PENewsDetailViewController.h
//  SatitCMU
//
//  Created by MRG on 3/21/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "PESatitApiManager.h"
#import "PFNewsCommentCell.h"
#import "PELoginViewController.h"
#import "UILabel+UILabelDynamicHeight.h"
#import <Social/Social.h>

@protocol PENewsDetailViewControllerDelegate <NSObject>

- (void)PENewsDetailViewControllerBack;
- (void)PENewsDetailViewController:(id)sender viewPicture:(NSString *)link;

@end

@interface PENewsDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (strong, nonatomic) PESatitApiManager *satitApi;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSString *prevString;
@property (strong, nonatomic) NSString *paging;
@property (weak, nonatomic) IBOutlet AsyncImageView *newsImg;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) IBOutlet UIView *textCommentView;
@property (weak, nonatomic) IBOutlet UIButton *postBut;
@property (weak, nonatomic) IBOutlet UITextView *textComment;
- (IBAction)postCommentTapped:(id)sender;
@property (assign, nonatomic) id<PENewsDetailViewControllerDelegate> delegate;

- (IBAction)likeTapped:(id)sender;
- (IBAction)commentTapped:(id)sender;
- (IBAction)shareTapped:(id)sender;

@property (strong, nonatomic) PELoginViewController *loginView;

@end
