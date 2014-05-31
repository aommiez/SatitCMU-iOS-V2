//
//  PFNewsCommentCell.h
//  DanceZone
//
//  Created by aOmMiez on 9/26/56 BE.
//  Copyright (c) 2556 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol PFNewsCommentCellDelegate <NSObject>

- (void)DidUserId:(NSString *)userId;

@end

@interface PFNewsCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;

- (IBAction)userImgTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *imgBut;
@property (assign, nonatomic) id <PFNewsCommentCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet AsyncImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgComment;
@property (weak, nonatomic) IBOutlet UIImageView *lineImg;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *timeComment;

@end
