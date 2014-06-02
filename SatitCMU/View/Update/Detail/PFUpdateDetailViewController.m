//
//  PENewsDetailViewController.m
//  SatitCMU
//
//  Created by MRG on 3/21/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFUpdateDetailViewController.h"
#import "UIView+MTAnimation.h"
#include "PFAppDelegate.h"

#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 4.0f
#define FONT_SIZE_COMMENT 14.0f

@interface PFUpdateDetailViewController ()

@end

@implementation PFUpdateDetailViewController

int maxH;
BOOL noData;
BOOL refreshData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"%@",self.obj);
    
    maxH = 0;
    noData = NO;
    refreshData = NO;
    self.arrObj = [[NSMutableArray alloc] init];
    self.prevString = [[NSString alloc] init];
    self.paging = [[NSString alloc] init];
    self.satitApi = [[PESatitApiManager alloc] init];
    self.satitApi.delegate = self;
    [self.detailView.layer setCornerRadius:4.0f];
    [self.detailView setBackgroundColor:RGB(208, 210, 211)];
    
    self.dateLabel.text = [self.obj objectForKey:@"created_text"];
    self.dateLabel.textColor = [UIColor whiteColor];
    
    self.msgLabel.text = [self.obj objectForKey:@"message"];
    CGRect frame = self.msgLabel.frame;
    frame.size = [self.msgLabel sizeOfMultiLineLabel];
    [self.msgLabel sizeOfMultiLineLabel];
    [self.msgLabel setFrame:frame];
    int lines = self.msgLabel.frame.size.height/15;
    self.msgLabel.numberOfLines = lines;
    
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.text = self.msgLabel.text;
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    self.msgLabel.alpha = 0;
    [self.detailView addSubview:descText];
   
    
    if (![[self.obj objectForKey:@"picture_id"] isEqualToString:@"0"]) {
        
        [self.newsImg setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [self.newsImg addGestureRecognizer:singleTap];
        
        NSString *imgUrl = [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"picture"] objectForKey:@"link"]];
        self.newsImg.imageURL = [[NSURL alloc] initWithString:imgUrl];
        self.newsImg.frame = CGRectMake(self.newsImg.frame.origin.x, self.msgLabel.frame.origin.y+self.msgLabel.frame.size.height+84, self.newsImg.frame.size.width, self.newsImg.frame.size.height);
    } else {
        self.newsImg.alpha = 0;
        self.newsImg.frame = CGRectMake(self.newsImg.frame.origin.x, self.msgLabel.frame.origin.y+self.msgLabel.frame.size.height+84, 320, 2);
    }
    
    //show like
    self.likeLabel.frame = CGRectMake(self.likeLabel.frame.origin.x, self.newsImg.frame.origin.y+self.newsImg.frame.size.height-70, self.likeLabel.frame.size.width, self.likeLabel.frame.size.height);
    //self.likeLabel.text = @"14 likes";
    
    //show comment
    self.commentLabel.frame = CGRectMake(self.likeLabel.frame.origin.x+self.newsImg.frame.size.height-130, self.newsImg.frame.origin.y+self.newsImg.frame.size.height-70, self.commentLabel.frame.size.width, self.likeLabel.frame.size.height);
    //self.commentLabel.text = @"6 comments";
    
    //show tabbaricon like
    self.likeButton.frame = CGRectMake(self.likeButton.frame.origin.x, self.newsImg.frame.origin.y+self.newsImg.frame.size.height-41, self.likeButton.frame.size.width, self.likeButton.frame.size.height);
    
    //show tabbaricon comment
    self.commentButton.frame = CGRectMake(self.commentButton.frame.origin.x, self.newsImg.frame.origin.y+self.newsImg.frame.size.height-41, self.commentButton.frame.size.width, self.commentButton.frame.size.height);
    
    //show tabbaricon search
    self.searchButton.frame = CGRectMake(self.searchButton.frame.origin.x, self.newsImg.frame.origin.y+self.newsImg.frame.size.height-41, self.searchButton.frame.size.width, self.searchButton.frame.size.height);
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.newsImg.frame.origin.y+self.newsImg.frame.size.height+84);
    self.tableView.tableHeaderView = self.headerView;
    
    if (IS_WIDESCREEN) {
        self.textCommentView.frame = CGRectMake(0, 464+60, 320, 356);
    } else {
        self.textCommentView.frame = CGRectMake(0, 440, 320, 356);
    }
    self.textComment.delegate = self;
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    self.tableView.tableFooterView = fv;
    [self.view addSubview:self.textCommentView];
    
    [self.satitApi getCommentObjectId:[self.obj objectForKey:@"id"] limit:@"5" next:@"NO"];
    [self.satitApi getNewsLikeComments:[self.obj objectForKey:@"id"]];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([self.textComment.text isEqualToString:@"Add Comment"]) {
        [self.textComment setTextColor:[UIColor blackColor]];
        self.textComment.text = @"";
    }
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.33 timingFunction:kMTEaseOutSine animations:^{
        self.textCommentView.frame = CGRectMake(0, 250+60, self.textCommentView.frame.size.width, self.textCommentView.frame.size.height);
    } completion:^{

        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.tableView.frame.size.height-214);
        if (IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 250+60, self.textCommentView.frame.size.width, self.textCommentView.frame.size.height);
            if ([self.arrObj count] > 0)
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } else {
            self.textCommentView.frame = CGRectMake(0, 220, self.textCommentView.frame.size.width, self.textCommentView.frame.size.height);
            if ([self.arrObj count] > 0)
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"])
	{
        if ( maxH < 3) {
            maxH += 1;
            float diff = (textView.frame.size.height - 30);
            CGRect r = self.textCommentView.frame;
            r.size.height += diff;
            r.origin.y -= 15;
            self.textCommentView.frame = r;
            CGRect a = self.textComment.frame;
            a.size.height += 15;
            self.textComment.frame = a;
            CGRect b = self.postBut.frame;
            b.origin.y += 15;
            self.postBut.frame = b;
            return YES;
        } else {
            [self.textComment scrollRangeToVisible:NSMakeRange([self.textComment.text length], 0)];
            return YES;
        }
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.textComment scrollRangeToVisible:NSMakeRange([self.textComment.text length], 0)];
}

- (void)loadComment {
    if (!noData){
        refreshData = NO;
        [self.satitApi getCommentObjectId:[self.obj objectForKey:@"id"] limit:@"NO" next:self.paging];
    }
}

- (IBAction)postCommentTapped:(id)sender {
    
    [self.tableView reloadData];
    [UIView mt_animateViews:@[self.textCommentView] duration:0.34 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.50
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [self.textComment resignFirstResponder];
    
    if ([[self.satitApi getAuth] isEqualToString:@"NO Login"]) {
        [self.satitApi setTokenForGuest];
        
        self.loginView = [[PFLoginViewController alloc] init];
        [self.view addSubview:self.loginView.view];

    } else {
        if (![self.textComment.text isEqualToString:@""]) {
            [self.satitApi CommentObjectId:[self.obj objectForKey:@"id"] msg:self.textComment.text];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textComment resignFirstResponder];
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.34 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.50
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.textComment.text isEqualToString:@""]) {
        [self.textComment setTextColor:[UIColor lightGrayColor]];
        self.textComment.text = @"Add Comment";
    }
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.arrObj count] < 4 ) {
        return 0;
    } else {
        return  44.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    UIImageView *imgViewPrev = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 3)];
    UIImageView *imgViewLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, 300, 3)];
    imgViewLine.image = [UIImage imageNamed:@"LineCommentBoxIp5.png"];
    imgViewPrev.image = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5@2x"] deg:180];;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(loadComment)
     forControlEvents:UIControlEventTouchDown];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:self.prevString forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 3, 300, 40);
    [button setContentMode:UIViewContentModeScaleAspectFit];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"linePrev.png"] forState:UIControlStateNormal];

    [headerView addSubview:button];
    [headerView addSubview:imgViewPrev];
    [headerView addSubview:imgViewLine];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = [[NSString alloc] init];
    str =  [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    NSString *text = str;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_COMMENT] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 24.0f) + 10;
    
    NSString *h = [[NSString alloc] initWithFormat:@"%f",height + (CELL_CONTENT_MARGIN * 2)];
    
    int lineValue = [h intValue]/16;
    int heightLable = 20*lineValue;
    return heightLable+40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFNewsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCommnetCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsCommnetCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *str = [[NSString alloc] init];
    str =  [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    NSString *text = str;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_COMMENT] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 24.0f) + 10;
    
    NSString *h = [[NSString alloc] initWithFormat:@"%f",height + (CELL_CONTENT_MARGIN * 2)];
    
    int lineValue = [h intValue]/16;
    cell.commentLabel.numberOfLines = 0;
    int heightLable = 20*lineValue;
    cell.delegate = self;
    cell.commentLabel.frame = CGRectMake(cell.commentLabel.frame.origin.x, cell.commentLabel.frame.origin.y, cell.commentLabel.frame.size.width, heightLable);
    
    cell.timeComment.frame = CGRectMake(cell.timeComment.frame.origin.x,heightLable +14, cell.timeComment.frame.size.width, cell.timeComment.frame.size.height);
    cell.timeComment.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"created_text"];
    
    cell.imgBut.tag = [[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"from"] objectForKey:@"id"] intValue];
    cell.commentLabel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"message"];
    cell.nameLabel.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"from"] objectForKey:@"username"];
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://satitcmu-api.pla2app.com/user/%@/picture",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"from"] objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    cell.myImageView.imageURL = url;
    
    NSInteger sectionsAmount = [tableView numberOfSections];
    NSInteger rowsAmount = [tableView numberOfRowsInSection:[indexPath section]];
    
    if ([self.arrObj count] < 4 ) {
        if (indexPath.row == 0 ) {
            if ([self.arrObj count] > 1 ) {
                UIImage *image2 = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5@2x"] deg:180];
                cell.lineImg.image = [UIImage imageNamed:@"LineCommentBoxIp5"];
                //cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];;
                cell.headImg.image = image2;
            } else {
                //cell.headImg.image = [UIImage imageNamed:@"HeadCommentBoxIp5"];
                cell.lineImg.image = [UIImage imageNamed:@"FootCommentBoxEndIp5"];
                UIImage *image2 = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5"] deg:180];
                cell.headImg.image = image2;
            }
        } else if ([indexPath section] == sectionsAmount - 1 && [indexPath row] == rowsAmount - 1) {
            cell.lineImg.image = [UIImage imageNamed:@"FootCommentBoxEndIp5"];
            cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];
        } else {
            cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];
        }
    } else {
        if (indexPath.row == 0 ) {
            if ([self.arrObj count] > 1 ) {
                //UIImage *image2 = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5@2x"] deg:180];
                cell.lineImg.image = [UIImage imageNamed:@"LineCommentBoxIp5"];
                cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];;
                //cell.headImg.image = [UIImage imageNamed:@"HeadCommentBoxIp5"];
            } else {
                //cell.headImg.image = [UIImage imageNamed:@"HeadCommentBoxIp5"];
                cell.lineImg.image = [UIImage imageNamed:@"FootCommentBoxEndIp5"];
                //UIImage *image2 = [self imageRotatedByDegrees:[UIImage imageNamed:@"FootCommentBoxEndIp5"] deg:180];
                cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];;
            }
        } else if ([indexPath section] == sectionsAmount - 1 && [indexPath row] == rowsAmount - 1) {
            cell.lineImg.image = [UIImage imageNamed:@"FootCommentBoxEndIp5"];
            cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];
        } else {
            cell.headImg.image = [UIImage imageNamed:@"BodyCommentBoxIp5"];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)PESatitApiManager:(id)sender getCommentObjectIdResponse:(NSDictionary *)response {
    
    //NSLog(@"%@",response);
    
    if (!refreshData) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            //[self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
            [self.arrObj insertObject:[[response objectForKey:@"data"] objectAtIndex:i] atIndex:0];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noData = YES;
    } else {
        noData = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    self.prevString = [[NSString alloc]initWithFormat:@"View previous comments %@ total %@",[[response objectForKey:@"paging"] objectForKey:@"current"],[[response objectForKey:@"paging"] objectForKey:@"length"]];
    
    [self reloadData:YES];
}

- (void)PESatitApiManager:(id)sender getCommentObjectIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    
    if (animated) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.5];
        [[self.tableView layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
    }
}

- (void)PESatitApiManager:(id)sender getNewsLikeCommentsResponse:(NSDictionary *)response {
    NSString *likeStr = [[NSString alloc] initWithFormat:@"%d Likes",[[[response objectForKey:@"like"] objectForKey:@"length"] intValue]];
    self.likeLabel.text = likeStr;
    NSString *commentStr = [[NSString alloc] initWithFormat:@"%d Comments",[[[response objectForKey:@"comment"] objectForKey:@"length"] intValue]];
    self.commentLabel.text = commentStr;
    if ( [[[response objectForKey:@"like"] objectForKey:@"is_liked"] intValue] == 1 ) {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"LikeBottonOnIp5"] forState:UIControlStateNormal];
    }
}

- (void)PESatitApiManager:(id)sender getNewsLikeCommentsErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFUpdateDetailViewControllerBack)]){
            [self.delegate PFUpdateDetailViewControllerBack];
        }
    }
    
}

- (IBAction)likeTapped:(id)sender {
    
    if ([[self.satitApi getAuth] isEqualToString:@"NO Login"]) {
        [self.satitApi setTokenForGuest];
        
        self.loginView = [[PFLoginViewController alloc] init];
        [self.view addSubview:self.loginView.view];
        
    } else {
        [self.likeButton setHighlighted:YES];
        [self.satitApi checkLikeObject:[self.obj objectForKey:@"id"]];
    }
}

- (IBAction)commentTapped:(id)sender {
    [self.textComment becomeFirstResponder];
}

- (IBAction)shareTapped:(id)sender {
    
    [self.textComment resignFirstResponder];
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.34 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.50
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.textComment.text isEqualToString:@""]) {
        [self.textComment setTextColor:[UIColor lightGrayColor]];
        self.textComment.text = @"Add Comment";
    }
    
    if ([[self.satitApi getAuth] isEqualToString:@"NO Login"]) {
        [self.satitApi setTokenForGuest];
        self.loginView = [[PFLoginViewController alloc] init];
        [self.view addSubview:self.loginView.view];

    } else {
        NSString *urlString = [[NSString alloc]init];
        urlString = [[NSString alloc]initWithFormat:@"%@",[self.obj objectForKey:@"share_link"]];
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [controller addURL:[NSURL URLWithString:urlString]];
            [controller setInitialText:[self.obj objectForKey:@"message"]];
            [self presentViewController:controller animated:YES completion:Nil];
        } else {
        
        }
    }
}

- (void)PESatitApiManager:(id)sender checkLikeObjectResponse:(NSDictionary *)response {
    if ( [[[response objectForKey:@"like"] objectForKey:@"is_liked"] intValue] == 1 ) {
        [self.satitApi unlikeObject:[self.obj objectForKey:@"id"]];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"LikeBottonIp5"] forState:UIControlStateNormal];
        int likeCount = [[self.likeLabel.text substringToIndex:2]intValue]-1;
        self.likeLabel.text = [[NSString alloc]initWithFormat:@"%d Likes",likeCount];
    } else {
        [self.satitApi likeObject:[self.obj objectForKey:@"id"]];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"LikeBottonOnIp5@2x"] forState:UIControlStateNormal];
        int likeCount = [[self.likeLabel.text substringToIndex:2]intValue]+1;
        self.likeLabel.text = [[NSString alloc]initWithFormat:@"%d Likes",likeCount];
    }
    [self.likeButton setHighlighted:NO];
}

- (void)PESatitApiManager:(id)sender checkLikeObjectErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PESatitApiManager:(id)sender CommentObjectIdResponse:(NSDictionary *)response {
    [self.textComment resignFirstResponder];
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.34 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.50
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.tableView.frame.size.height);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.textComment.text isEqualToString:@""]) {
        [self.textComment setTextColor:[UIColor lightGrayColor]];
        self.textComment.text = @"Add Comment";
    }
    [self.arrObj insertObject:response atIndex:[self.arrObj count]];
    [self.tableView reloadData];
    [self.textComment setTextColor:[UIColor lightGrayColor]];
    self.textComment.text = @"Add Comment";
    if ([self.arrObj count] > 0)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
}

- (void)PESatitApiManager:(id)sender CommentObjectIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    NSString *picStr = [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"picture"] objectForKey:@"link"]];
    [self.delegate PFUpdateDetailViewController:self viewPicture:picStr];
    
    [self.textComment resignFirstResponder];
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.0 timingFunction:kMTEaseOutSine animations:^{
        if ( IS_WIDESCREEN) {
            self.textCommentView.frame = CGRectMake(0, 464+60, 320, 44);
        } else {
            self.textCommentView.frame = CGRectMake(0, 440, 320, 44);
        }
        self.textComment.frame = CGRectMake(10, 7, 236, 30);
        self.postBut.frame = CGRectMake(254, 7, 54, 30);
    } completion:^{
        
    }];
    
    [UIView animateWithDuration:0.0
                          delay:0.1  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseOut
                     animations:^ {
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.view.frame.size.height-44);
                         if ([self.arrObj count] > 0)
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrObj count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.textComment.text isEqualToString:@""]) {
        [self.textComment setTextColor:[UIColor lightGrayColor]];
        self.textComment.text = @"Add Comment";
    }
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)DidUserId:(NSString *)userId {
    PFSeeAccountViewController *seeAct = [[PFSeeAccountViewController alloc] initWithNibName:@"PFSeeAccountViewController_Wide" bundle:nil];
    seeAct.delegate = self;
    seeAct.userId = userId;
    [self.navigationController  pushViewController:seeAct animated:YES];
}

@end
