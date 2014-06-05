//
//  PFShowcaseViewController.m
//  SatitCMU
//
//  Created by Pariwat on 5/30/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFShowcaseViewController.h"

@interface PFShowcaseViewController ()

@end

BOOL loadz;
BOOL noDatazz;
BOOL refreshDataz;

NSString *totalImg;
NSString *titleText;
NSString *detailText;

@implementation PFShowcaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Showcase";
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
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    loadz = NO;
    noDatazz = NO;
    refreshDataz = NO;

    self.satitApi = [[PESatitApiManager alloc] init];
    self.satitApi.delegate = self;
    [self.satitApi galleryLimit:@"5" link:@"NO"];
    
    self.arrObj = [[NSMutableArray alloc] init];
    self.arrObjGallery = [[NSMutableArray alloc] init];
    self.sum = [[NSMutableArray alloc] init];
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:146.0f/255.0f green:90.0f/255.0f blue:202.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
    self.tableView.tableFooterView = fv;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShowCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowCaseCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShowCaseCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell.detailView.layer setCornerRadius:10.0f];
    [cell.detailView setBackgroundColor:RGB(204, 204, 204)];
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.thumbnails.imageURL = [[NSURL alloc] initWithString:[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"link"]];
    
    cell.labelTitle.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    totalImg = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"picture_length"];
    titleText = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    detailText = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    [self.arrObjGallery removeAllObjects];
    [self.sum removeAllObjects];
    
    [self.satitApi galleryPictureByid:[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"id"]];
}

- (void)PESatitApiManager:(id)sender galleryPictureByIdResponse:(NSDictionary *)response {
    
    //[self.waitView removeFromSuperview];
    
    for (int i = 0; i < [[response objectForKey:@"data"] count]; i++) {
        
        [self.arrObjGallery addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
    
    }
    
    for (int i = 0; i < [[response objectForKey:@"data"] count]; i++) {
        
        [self.sum addObject:[[[self.arrObjGallery objectAtIndex:i] objectForKey:@"picture"] objectForKey:@"link"]];
        
    }
    
    [self.delegate HideTabbar];
    
    PFGalleryViewController *showcaseGallery = [[PFGalleryViewController alloc] initWithNibName:@"PFGalleryViewController_Wide" bundle:nil];
    
    showcaseGallery.delegate = self;
    
    showcaseGallery.arrObj = self.arrObjGallery;
    showcaseGallery.sumimg = self.sum;
    showcaseGallery.totalImg = totalImg;
    showcaseGallery.titleText = titleText;
    showcaseGallery.detailText = detailText;
    
    [self.navController pushViewController:showcaseGallery animated:YES];
    
    
}

- (void)PESatitApiManager:(id)sender galleryPictureByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

#pragma mark - API Delegate

- (void)PESatitApiManager:(id)sender galleryResponse:(NSDictionary *)response {
    
    [self.waitView removeFromSuperview];
    
    //NSLog(@"%@",response);
    
    if (!refreshDataz) {
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
        noDatazz = YES;
    } else {
        noDatazz = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self reloadData:YES];
}

- (void)PESatitApiManager:(id)sender galleryErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFFullimageViewController:(NSMutableArray *)sum current:(NSString *)current {
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFGalleryViewControllerBack {
    [self.delegate ShowTabbar];
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
        refreshDataz = YES;
        
        self.satitApi = [[PESatitApiManager alloc] init];
        self.satitApi.delegate = self;
        [self.satitApi galleryLimit:@"5" link:@"NO"];
        
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
        if (!noDatazz) {
            refreshDataz = NO;
            //NSLog(@"refreshData = NO");
            self.satitApi = [[PESatitApiManager alloc] init];
            self.satitApi.delegate = self;
            [self.satitApi galleryLimit:@"NO" link:self.paging];
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
    if (!noDatazz){
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height-270);
    } else {
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
    }
    
}

@end
