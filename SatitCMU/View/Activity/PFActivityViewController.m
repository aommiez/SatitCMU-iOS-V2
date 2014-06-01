//
//  PFActivityViewController.m
//  SatitCMU
//
//  Created by Pariwat on 5/30/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFActivityViewController.h"

@interface PFActivityViewController ()

@end

@implementation PFActivityViewController

BOOL loadAc;
BOOL noDataAc;
BOOL refreshDataAc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Activity";
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
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Calendar_icon"] style:UIBarButtonItemStyleDone target:nil action:@selector(caleader)];
    self.navItem.rightBarButtonItem = rightButton;
    
    loadAc = NO;
    noDataAc = NO;
    refreshDataAc = NO;
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.satitApi = [[PESatitApiManager alloc] init];
    self.satitApi.delegate = self;
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatterM = [[NSDateFormatter alloc]init];
    [dateFormatterM setDateFormat:@"MM"];
    NSString *dateStringM = [dateFormatterM stringFromDate:currDate];
    NSDateFormatter *dateFormatterY = [[NSDateFormatter alloc]init];
    [dateFormatterY setDateFormat:@"YYYY"];
    NSString *dateStringY = [dateFormatterY stringFromDate:currDate];
    
    NSDateFormatter *dateFormatterMFull = [[NSDateFormatter alloc]init];
    [dateFormatterMFull setDateFormat:@"MMMM"];
    NSString *dateStringMFull = [dateFormatterMFull stringFromDate:currDate];
    
    self.mtext.text = dateStringMFull;
    [self.satitApi getActivitiesByM:dateStringM year:dateStringY];
    
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
    // Dispose of any resources that can be recreated.
}

- (IBAction)filterTapped:(id)sender {
    
    [self.delegate HideTabbar];
    
    self.blur = [[UIERealTimeBlurView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(self.blur.frame.origin.x, self.blur.frame.origin.y+64, self.blur.frame.size.width, self.blur.frame.size.height-64)];
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://61.19.147.72/satit/api/webview/filter?type=activity&ios_token=%@",[self.satitApi getTokenGuest]];
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
    
    loadAc = NO;
    noDataAc = NO;
    refreshDataAc = NO;

    [self.blur removeFromSuperview];
    
}

- (void)caleader {
    
    [self.delegate HideTabbar];
    
    PFActivityCalendarViewController *actCalendar = [[PFActivityCalendarViewController alloc] init];
    actCalendar.delegate = self;
    [self.navController pushViewController:actCalendar animated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.timeLabel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"start_time_2"];
    cell.dateLabel.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"start_time_text_th"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate HideTabbar];
    
    PFActivityDetailViewController *actDetailViewController = [[PFActivityDetailViewController alloc] init];
    
    if (IS_WIDESCREEN){
        actDetailViewController = [[PFActivityDetailViewController alloc] initWithNibName:@"PFActivityDetailViewController_Wide" bundle:nil];
    }else{
        actDetailViewController = [[PFActivityDetailViewController alloc] initWithNibName:@"PFActivityDetailViewController"bundle:nil];
    }
    
    actDetailViewController.delegate = self;
    actDetailViewController.obj = [self.arrObj objectAtIndex:indexPath.row];
    [self.navController pushViewController:actDetailViewController animated:YES];
}

#pragma mark - Satit Delegate

- (void)PESatitApiManager:(id)sender getActivitiesByMResponse:(NSDictionary *)response {
    
    [self.waitView removeFromSuperview];
    
    for (int i=0; i < [[response objectForKey:@"data"] count]; ++i) {
        [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
    }
    
    [self.tableView reloadData];
}

- (void)PESatitApiManager:(id)sender getActivitiesByMErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFActivityCalendarViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFActivityCalendarViewController:(id)sender viewPicture:(NSString *)link {
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFActivityDetailViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFActivityDetailViewControllerPhoto:(NSString *)link {
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	//NSLog(@"%f",scrollView.contentOffset.y);
    self.loadLabel.text = @"";
    self.act.alpha = 0;
    
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
        refreshDataAc = YES;
        NSLog(@"refreshData = YES");
        
        self.satitApi = [[PESatitApiManager alloc] init];
        self.satitApi.delegate = self;
        
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
		[UIView commitAnimations];
    } else {
        self.loadLabel.text = @"";
        self.act.alpha = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    //NSLog(@"%f",offset);
    if (offset >= 0 && offset <= 5) {
        if (!noDataAc) {
            refreshDataAc = NO;
            //NSLog(@"refreshData = NO");
            self.satitApi = [[PESatitApiManager alloc] init];
            self.satitApi.delegate = self;
        }
    }
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    if (!noDataAc){
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height-270);
    } else {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    }
    
}

@end
