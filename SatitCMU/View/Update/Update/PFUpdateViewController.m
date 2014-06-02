//
//  PFUpdateViewController.m
//  SatitCMU
//
//  Created by Pariwat on 5/30/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFUpdateViewController.h"

@interface PFUpdateViewController ()

@end

@implementation PFUpdateViewController

BOOL loadNe;
BOOL noDataNe;
BOOL refreshDataNe;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Update";
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        shadow.shadowOffset = CGSizeMake(0, 1);
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                               shadow, NSShadowAttributeName, nil]];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:146.0f/255.0f green:90.0f/255.0f blue:202.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    
    //self.navController.delegate = self;
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(account)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Notification_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(notify)];
    
    self.navItem.leftBarButtonItem = leftButton;
    self.navItem.rightBarButtonItem = rightButton;
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    loadNe = NO;
    noDataNe = NO;
    refreshDataNe = NO;
    
    self.satitApi = [[PESatitApiManager alloc] init];
    self.satitApi.delegate = self;
    [self.satitApi feedLimit:@"5" link:@"NO"];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = hv;
    
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    self.tableView.tableFooterView = fv;
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)account {
    
//    [self.delegate HideTabbar];
//    PFAccountViewController *accountView = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController_Wide" bundle:nil];
//    accountView.delegate = self;
//    [self.navController pushViewController:accountView animated:YES];
    
}

- (void)notify {
    
    if ([[self.satitApi getAuth] isEqualToString:@"NO Login"]) {
        [self.satitApi setTokenForGuest];
        self.loginView = [[PFLoginViewController alloc] init];
        self.loginView.menu = @"notify";
        self.loginView.delegate = self;
        [self.view addSubview:self.loginView.view];
    } else {
    
    [self.delegate HideTabbar];
    PFNotifyViewController *notifyView = [[PFNotifyViewController alloc] initWithNibName:@"PFNotifyViewController_Wide" bundle:nil];
    notifyView.delegate = self;
    [self.navController pushViewController:notifyView animated:YES];
        
    }
    
}

- (IBAction)filterTapped:(id)sender {
    
    [self.delegate HideTabbar];
    
    self.blur = [[UIERealTimeBlurView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(self.blur.frame.origin.x, self.blur.frame.origin.y+64, self.blur.frame.size.width, self.blur.frame.size.height-64)];
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://satitcmu-api.pla2app.com/webview/filter?type=update&ios_token=%@",[self.satitApi getTokenGuest]];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(doneFilter)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.frame = CGRectMake(self.blur.frame.origin.x, self.blur.frame.origin.y+20, 320.0, 40.0);
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    button.titleLabel.font = [UIFont fontWithName: @"Helvetica" size: 17];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 14)];
    
    [self.blur addSubview:button];
    [self.blur addSubview:webView];
    [self.view addSubview:self.blur];
}

- (void)doneFilter {
    
    [self.delegate ShowTabbar];
    
    loadNe = NO;
    noDataNe = NO;
    refreshDataNe = NO;
    
    [self.blur removeFromSuperview];
    
}

- (void)PESatitApiManager:(id)sender feedResponse:(NSDictionary *)response {
    
    //NSLog(@"%@",response);
    if (!refreshDataNe) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataNe = YES;
    } else {
        noDataNe = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self reloadData:YES];
}

- (void)PESatitApiManager:(id)sender feedErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"news"]) {
        if (![[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"news"] objectForKey:@"picture_id"]  isEqualToString:@"0"]) {
            return 316;
        } else {
            return 120;
        }
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"activity"]) {
        if (![[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"picture_id"]  isEqualToString:@"0"]) {
            return 316;
        } else {
            return 120;
        }
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"gallery"]) {
        if (![[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"gallery"] objectForKey:@"picture_id"]  isEqualToString:@"0"]) {
            return 300;
        } else {
            return 120;
        }
    }
    return 316;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.waitView removeFromSuperview];
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"news"]) {
        
        if (![[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"news"] objectForKey:@"picture_id"]  isEqualToString:@"0"]) {
            
            UpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpdateCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            NSString *urlStr = [[NSString alloc] initWithFormat:@"%@news/%@?fields=like,comment&auth_token=%@",API_URL,[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"news"] objectForKey:@"id"],[self.satitApi getUserToken]];
            
            self.manager = [AFHTTPRequestOperationManager manager];
            [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"%@",responseObject);
                //[self.delegate PESatitApiManager:self getNewsLikeCommentsResponse:responseObject];
                
                NSString *likeStr = [[NSString alloc] initWithFormat:@"%d Likes",[[[responseObject objectForKey:@"like"] objectForKey:@"length"] intValue]];
                cell.like.text = likeStr;
                
                NSString *commentStr = [[NSString alloc] initWithFormat:@"%d Comments",[[[responseObject objectForKey:@"comment"] objectForKey:@"length"] intValue]];
                cell.comment.text = commentStr;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            }];
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            cell.thumbnails.imageURL = [[NSURL alloc] initWithString:[[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"news"]  objectForKey:@"picture"] objectForKey:@"link"]];
            cell.createdText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"news"] objectForKey:@"created_text"];
            cell.createdText.textColor = [UIColor whiteColor];
            cell.messageText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"news"] objectForKey:@"message"];
            [cell.detailView.layer setCornerRadius:5.0f];
            [cell.detailView setBackgroundColor:RGB(204, 204, 204)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else {
            
            UpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell"];
            
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpdateNoPicCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.createdText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"news"] objectForKey:@"created_text"];
            cell.createdText.textColor = [UIColor whiteColor];
            cell.messageText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"news"] objectForKey:@"message"];
            
            [cell.messageText sizeToFit];
            [cell.detailView.layer setCornerRadius:5.0f];
            [cell.detailView setBackgroundColor:RGB(204, 204, 204)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
            
        }
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"activity"]) {
        
        if ([[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"picture_id"]  isEqualToString:@"0"]) {
            
            UpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityNoPicCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            NSString *urlStrAc = [[NSString alloc] initWithFormat:@"%@activity/%@?fields=like,comment&auth_token=%@",API_URL,[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"id"],[self.satitApi getUserToken]];
            
            self.manager = [AFHTTPRequestOperationManager manager];
            [self.manager GET:urlStrAc parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSString *commentStr = [[NSString alloc] initWithFormat:@"%d Comments",[[[responseObject objectForKey:@"comment"] objectForKey:@"length"] intValue]];
                cell.comment.text = commentStr;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            }];
            
            cell.createdText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"created_text"];
            cell.messageText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"message"];
            
            [cell.messageText sizeToFit];
            cell.createdText.textColor = [UIColor whiteColor];
            [cell.detailView.layer setCornerRadius:5.0f];
            [cell.detailView setBackgroundColor:RGB(204, 204, 204)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else {
            
            UpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityNoCommentCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            NSString *urlStr = [[NSString alloc] init];
            if (IS_WIDESCREEN) {
                urlStr = [[NSString alloc] initWithFormat:@"%@pic/%@?display=custom&size_x=640",API_URL,[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"picture_id"] ];
            } else {
                urlStr = [[NSString alloc] initWithFormat:@"%@pic/%@?display=custom&size_x=320",API_URL,[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"picture_id"]];
            }
            
            NSString *urlStrAcNo = [[NSString alloc] initWithFormat:@"%@activity/%@?fields=like,comment&auth_token=%@",API_URL,[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"id"],[self.satitApi getUserToken]];
            
            self.manager = [AFHTTPRequestOperationManager manager];
            [self.manager GET:urlStrAcNo parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSString *commentStr = [[NSString alloc] initWithFormat:@"%d Comments",[[[responseObject objectForKey:@"comment"] objectForKey:@"length"] intValue]];
                cell.comment.text = commentStr;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSURL *url = [[NSURL alloc]initWithString:urlStr];
            cell.thumbnails.imageURL = url;
            cell.createdText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"created_text"];
            cell.messageText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"] objectForKey:@"message"];
            
            cell.createdText.textColor = [UIColor whiteColor];
            [cell.detailView.layer setCornerRadius:5.0f];
            [cell.detailView setBackgroundColor:RGB(204, 204, 204)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"gallery"]) {
        
        UpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GalleryNoCommentCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.thumbnails.imageURL = [[NSURL alloc] initWithString:[[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"gallery"]  objectForKey:@"thumb"] objectForKey:@"link"]];
        
        cell.thumbnails.layer.masksToBounds = YES;
        cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.createdText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"gallery"] objectForKey:@"created_text"];
        cell.createdText.textColor = [UIColor whiteColor];
        cell.messageText.text = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"gallery"] objectForKey:@"description"];
        
        [cell.detailView.layer setCornerRadius:5.0f];
        [cell.detailView setBackgroundColor:RGB(204, 204, 204)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate HideTabbar];
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"activity"]) {
        
        PFActivityDetailViewController *actDetailViewController = [[PFActivityDetailViewController alloc] init];
        
        if (IS_WIDESCREEN){
            actDetailViewController = [[PFActivityDetailViewController alloc] initWithNibName:@"PFActivityDetailViewController_Wide" bundle:nil];
        }else{
            actDetailViewController = [[PFActivityDetailViewController alloc] initWithNibName:@"PFActivityDetailViewController"bundle:nil];
        }
        
        actDetailViewController.obj = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"activity"];
        actDetailViewController.delegate = self;
        [self.navController pushViewController:actDetailViewController animated:YES];
        
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"gallery"]) {
        
        PFGalleryViewController *gallery = [[PFGalleryViewController alloc] init];
        
        if (IS_WIDESCREEN){
            gallery = [[PFGalleryViewController alloc] initWithNibName:@"PFGalleryViewController_Wide" bundle:nil];
        }else{
            gallery = [[PFGalleryViewController alloc] initWithNibName:@"PFGalleryViewController"bundle:nil];
        }
        
        gallery.delegate = self;
        [self.navController pushViewController:gallery animated:YES];
        
    } else {
        
        PFUpdateDetailViewController *updateDeatail = [[PFUpdateDetailViewController alloc] init];
        
        if (IS_WIDESCREEN){
            updateDeatail = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController_Wide" bundle:nil];
        }else{
            updateDeatail = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController"bundle:nil];
        }
        
        updateDeatail.obj = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"news"];
        updateDeatail.delegate = self;
        [self.navController pushViewController:updateDeatail animated:YES];
        
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	//NSLog(@"%f",scrollView.contentOffset.y);
	//[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ( scrollView.contentOffset.y < 0.0f ) {
        //NSLog(@"refreshData < 0.0f");
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
        self.act.alpha =1;
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60.0f ) {
        refreshDataNe = YES;
        
        self.satitApi = [[PESatitApiManager alloc] init];
        self.satitApi.delegate = self;
        [self.satitApi feedLimit:@"5" link:@"NO"];
    } else {
        self.loadLabel.text = @"";
        self.act.alpha = 0;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ( scrollView.contentOffset.y < -100.0f ) {
        //NSLog(@"refreshData < -100.0f");
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        self.tableView.frame = CGRectMake(0, 60, 320, self.tableView.frame.size.height);
		[UIView commitAnimations];
        [self performSelector:@selector(resizeTable) withObject:nil afterDelay:2];
    } else {
        self.loadLabel.text = @"";
        self.act.alpha = 0;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataNe) {
            refreshDataNe = NO;
            //NSLog(@"refreshData = NO");
            self.satitApi = [[PESatitApiManager alloc] init];
            self.satitApi.delegate = self;
            [self.satitApi feedLimit:@"NO" link:self.paging];
        }
    }
}
- (void)resizeTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
    [UIView commitAnimations];
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    if (!noDataNe){
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    } else {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    }
}

//- (void)PENotifyViewController:(id)sender{
//    [self.delegate HideTabbar];
//    
//    PFNotifyViewController *notifyView = [[PFNotifyViewController alloc] initWithNibName:@"PFNotifyViewController_Wide" bundle:nil];
//    notifyView.delegate = self;
//    [self.navController pushViewController:notifyView animated:YES];
//}

- (void)PFAccountViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFNotifyViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFAccountViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFUpdateDetailViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFUpdateDetailViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFActivityDetailViewControllerPhoto:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFActivityDetailViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFGalleryViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
