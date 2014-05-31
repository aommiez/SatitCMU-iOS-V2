//
//  ShowCaseCell.h
//  SatitCMU
//
//  Created by MRG on 2/13/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ShowCaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet AsyncImageView *thumbnails;

@end
