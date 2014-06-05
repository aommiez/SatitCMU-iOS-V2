//
//  PEActivityDetailViewController.m
//  SatitCMU
//
//  Created by MRG on 3/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFActivityDetailViewController.h"
#import "UIView+MTAnimation.h"

#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 4.0f
#define FONT_SIZE_COMMENT 14.0f

@interface PFActivityDetailViewController ()

@end

@implementation PFActivityDetailViewController

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
    
    maxH = 0;
    noData = NO;
    refreshData = NO;
    
    self.satitApi = [[PESatitApiManager alloc] init];
    self.satitApi.delegate = self;
    self.arrObj = [[NSMutableArray alloc] init];
    self.prevString = [[NSString alloc] init];
    self.paging = [[NSString alloc] init];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    NSString *mytitle = [self.obj objectForKey:@"name"];
    NSUInteger length = [mytitle length];
    int num;
    num = (int) length;
    
    if(num > 15){
        NSString *mySmallertitle= [mytitle substringToIndex:15];
        NSString *message = [NSString stringWithFormat:@"%@%@",mySmallertitle,@"..."];
        self.navigationItem.title = message;
    }else{
        self.navigationItem.title = [self.obj objectForKey:@"name"];
    }
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareactivity)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    NSString *urlStr = [[NSString alloc] init];
    if (IS_WIDESCREEN) {
        urlStr = [[NSString alloc] initWithFormat:@"%@pic/%@?display=custom&size_x=640",API_URL,[self.obj objectForKey:@"picture_id"]];
    } else {
        urlStr = [[NSString alloc] initWithFormat:@"%@pic/%@?display=custom&size_x=640",API_URL,[self.obj objectForKey:@"picture_id"]];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setImageWithURLRequest:urlRequest
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            imgView.image = image;
                                            imgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                                            [self.headerView addSubview:imgView];
                                            UIView *lineMid = [[UIView alloc] initWithFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y+imgView.frame.size.height, 220, 30)];
                                            lineMid.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];
                                            
                                            [self.headerView addSubview:lineMid];
                                            UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineMid.frame.origin.x+10, lineMid.frame.origin.y, 200, 30)];
                                            headLabel.text = [self.obj objectForKey:@"name"];
                                            headLabel.textColor = [UIColor whiteColor];
                                            [self.headerView addSubview:headLabel];
                                            
                                            self.labelMsg.text = [self.obj objectForKey:@"message"];
                                            
                                            CGRect frame = self.labelMsg.frame;
                                            frame.size = [self.labelMsg sizeOfMultiLineLabel];
                                            [self.labelMsg sizeOfMultiLineLabel];
                                            [self.labelMsg setFrame:frame];
                                            int lines = self.labelMsg.frame.size.height/14;
                                            self.labelMsg.alpha = 0;
                                            UILabel_UILabelDynamicHeight *msg = [[UILabel_UILabelDynamicHeight alloc] initWithFrame:CGRectMake(10, 30, 280, self.labelMsg.frame.size.height)];
                                            msg.text = [self.obj objectForKey:@"message"];
                                            //msg.textColor = [UIColor blackColor];
                                            msg.textColor = [UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:133.0/255.0 alpha:1.0];
                                            [msg setFont:[UIFont systemFontOfSize:14]];
                                            msg.numberOfLines = lines;
                                            
                                            UILabel *dateCreate = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 290, 14)];
                                            dateCreate.textAlignment = NSTextAlignmentRight;
                                            dateCreate.text = [self.obj objectForKey:@"created_text"];
                                            //dateCreate.textColor = [UIColor darkGrayColor];
                                            dateCreate.textColor = [UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:133.0/255.0 alpha:1.0];
                                            [dateCreate setFont:[UIFont systemFontOfSize:12]];
                                            
                                            UIView *contectView = [[UIView alloc] initWithFrame:CGRectMake(10, lineMid.frame.origin.y+30, 300, msg.frame.size.height+40)];
                                            //[contectView setBackgroundColor:RGB(204, 204, 204)];
                                            contectView.backgroundColor = [UIColor whiteColor];
                                            [contectView.layer setCornerRadius:4.0f];
                                            [contectView addSubview:dateCreate];
                                            [contectView addSubview:msg];
                                            [self.headerView addSubview:contectView];
                                            
                                            if ([[self.obj objectForKey:@"is_joined"] intValue] == 0 ) {
                                                [self.summitButton setBackgroundImage:[UIImage imageNamed:@"SubmitBottonIp5.png"] forState:UIControlStateNormal];
                                                [self.summitButton setTitle:@"Join" forState:UIControlStateNormal];
                                            } else {
                                                [self.summitButton setBackgroundImage:[UIImage imageNamed:@"ButtonOrg.png"] forState:UIControlStateNormal];
                                                [self.summitButton setTitle:@"Joined" forState:UIControlStateNormal];
                                            }
                                            
                                            self.summitButton.frame = CGRectMake(20, image.size.height+lineMid.frame.size.height+contectView.frame.size.height, self.summitButton.frame.size.width, self.summitButton.frame.size.height);
                                            self.summitButton.userInteractionEnabled = YES;
                                            [self.headerView addSubview:self.summitButton];
                                            

                                            self.headerView.frame = CGRectMake(0, 0, 320, image.size.height+lineMid.frame.size.height+contectView.frame.size.height+66);

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
                                            [self.view reloadInputViews];
                                            
                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            NSLog(@"Failed to download image: %@", error);
                                        }];
    
    [imgView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [imgView addGestureRecognizer:singleTap];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)shareactivity {
    
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
        urlString = [[NSString alloc]initWithFormat:@"%@pic/%@?display=custom&size_x=640",API_URL,[self.obj objectForKey:@"picture_id"]];
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [controller addURL:[NSURL URLWithString:urlString]];
            [controller setInitialText:[self.obj objectForKey:@"message"]];
            [self presentViewController:controller animated:YES completion:Nil];
        } else {
            
        }
    }
}

- (void)joinTapped:(id)sender {
    if ( [self.summitButton.titleLabel.text isEqualToString:@"Join"]) {
        [self.satitApi joinActivityById:[self.obj objectForKey:@"id"]];
    } else  if ( [self.summitButton.titleLabel.text isEqualToString:@"Joined"]) {
        [self showConfirmAlert];
    }
}

- (void)showConfirmAlert
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Confirm"];
    [alert setMessage:@"ต้องการยกเลิกการร่วมกิจกรรม ?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0)
    {
        [self.satitApi unjoinActivityById:[self.obj objectForKey:@"id"]];
    }
    else if (buttonIndex == 1)
    {

    }
}

- (void)PESatitApiManager:(id)sender joinActivityResponse:(NSDictionary *)response {
    [self.summitButton setTitle:@"Joined" forState:UIControlStateNormal];
    [self.summitButton setBackgroundImage:[UIImage imageNamed:@"ButtonOrg.png"] forState:UIControlStateNormal];
}

- (void)PESatitApiManager:(id)sender joinActivityErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PESatitApiManager:(id)sender unjoinActivityResponse:(NSDictionary *)response {
    [self.summitButton setTitle:@"Join" forState:UIControlStateNormal];
    [self.summitButton setBackgroundImage:[UIImage imageNamed:@"SubmitBottonIp5.png"] forState:UIControlStateNormal];
}

- (void)PESatitApiManager:(id)sender unjoinActivityErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (IBAction)bgTapped:(id)sender {
    
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([self.textComment.text isEqualToString:@"Add Comment"]) {
        [self.textComment setTextColor:[UIColor blackColor]];
        self.textComment.text = @"";
    }
    
    [UIView mt_animateViews:@[self.textCommentView] duration:0.33 timingFunction:kMTEaseOutSine animations:^{
        self.textCommentView.frame = CGRectMake(0, 250+60, self.textCommentView.frame.size.width, self.textCommentView.frame.size.height);
    } completion:^{
        
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, self.tableView.frame.size.height-215);
        //214
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self bgTapped:self];
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
    
    [self.waitView removeFromSuperview];
    
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

- (IBAction)postCommentTapped:(id)sender {
    
    [self.tableView reloadData];
    [self bgTapped:self];
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

- (void)PESatitApiManager:(id)sender CommentObjectIdResponse:(NSDictionary *)response {
    [self bgTapped:self];
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

- (void)DidUserId:(NSString *)userId {
    PFSeeAccountViewController *seeAct = [[PFSeeAccountViewController alloc] initWithNibName:@"PFSeeAccountViewController_Wide" bundle:nil];
    seeAct.delegate = self;
    seeAct.userId = userId;
    [self.navigationController  pushViewController:seeAct animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([self.navigationController.visibleViewController isKindOfClass:[PFSeeAccountViewController class]]) {
        
    } else {
        if (self.navigationController.visibleViewController != self) {
            if([self.delegate respondsToSelector:@selector(PFActivityDetailViewControllerBack)]){
                [self.delegate PFActivityDetailViewControllerBack];
            }
        } else {
            
        }
    }
}

- (void)PFSeeAccountViewController:(id)sender viewPicture:(NSString *)link {
    [self.delegate PFActivityDetailViewControllerPhoto:link];
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    NSString *picStr = [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"picture"] objectForKey:@"link"]];
    [self.delegate PFActivityDetailViewControllerPhoto:picStr];
    
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

}

@end
