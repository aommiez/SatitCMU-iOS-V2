//
//  PEContactViewController.m
//  SatitCMU
//
//  Created by MRG on 1/31/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFContactViewController.h"
#import "PagedImageScrollView.h"

@interface PFContactViewController ()

@end

@implementation PFContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Contact";
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
    
    self.cellSize = [[NSString alloc] init];
    self.view.autoresizesSubviews = NO;
    self.imgMap = [[UIImage alloc] init];
    self.obj = [[NSDictionary alloc] init];
    self.satitApi = [[PESatitApiManager alloc] init];
    self.satitApi.delegate = self;

    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:146.0f/255.0f green:90.0f/255.0f blue:202.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];

    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    CALayer *mapbutton = [self.mapButton layer];
    [mapbutton setMasksToBounds:YES];
    [mapbutton setCornerRadius:7.0f];
    
    self.mapButton.frame = CGRectMake(0, 0, 290, 140);
    
    [self reloadView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapFullimg:)];
    [self.headerView addGestureRecognizer:singleTap];
    
    self.current = @"0";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)reloadView {
    
    [self.satitApi getContact];
}

- (void)PagedImageScrollView:(id)sender current:(NSString *)current {
    self.current = current;
}

- (void)singleTapFullimg:(UITapGestureRecognizer *)gesture
{
    int sum;
    sum = [self.current intValue]/32;
    NSString *num = [NSString stringWithFormat:@"%d",sum];
    [self.delegate PFGalleryViewController:self sum:self.arrcontactimg current:num];
}

- (NSArray *)imageToArray:(NSDictionary *)images {
    NSMutableArray *ArrImgs = [[NSMutableArray alloc] init];
    int countPicture = [[images objectForKey:@"pictures"] count];
    for (int i = 0; i < countPicture; i++) {
        NSString *urlStr = [[NSString alloc] initWithFormat:@"%@",[[[images objectForKey:@"pictures"] objectAtIndex:i] objectForKey:@"link"]];
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        NSData *data = [NSData dataWithContentsOfURL : url];
        UIImage *image = [UIImage imageWithData: data];
        [ArrImgs addObject:image];
    }
    return ArrImgs;
}

- (void)PESatitApiManager:(id)sender getContactResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    NSString *add = [response objectForKey:@"address"];
    self.address.text = add;
    
    NSString *phone = [response objectForKey:@"phone"];
    [self.phoneButton setTitle:phone forState:UIControlStateNormal];
    
    NSString *website = [response objectForKey:@"website"];
    [self.websiteButton setTitle:website forState:UIControlStateNormal];
    
    NSString *email = [response objectForKey:@"email"];
    [self.emailButton setTitle:email forState:UIControlStateNormal];
    
    NSString *facebook = [response objectForKey:@"facebook"];
    [self.facebookButton setTitle:facebook forState:UIControlStateNormal];
    
    NSString *youtube = [response objectForKey:@"youtube"];
    [self.youtubeButton setTitle:youtube forState:UIControlStateNormal];
    
    self.lat = [response objectForKey:@"lat"];
    self.lng = [response objectForKey:@"lng"];
    
    self.arrcontactimg = [[NSMutableArray alloc] init];
    for (int i=0; i<[[response objectForKey:@"pictures"] count]; ++i) {
        [self.arrcontactimg addObject:[[[response objectForKey:@"pictures"] objectAtIndex:i] objectForKey:@"link"]];
    }
    
    PagedImageScrollView *pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    pageScrollView.delegate = self;
    [pageScrollView setScrollViewContents:[self imageToArray:response]];
    pageScrollView.pageControlPos = PageControlPositionCenterBottom;
    [self.headerView addSubview:pageScrollView];
    //
    
    CALayer *mapradius = [self.mapImage layer];
    [mapradius setMasksToBounds:YES];
    [mapradius setCornerRadius:7.0f];
    
    NSString *urlmap = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"http://maps.googleapis.com/maps/api/staticmap?center=",self.lat,@",",self.lng,@"&zoom=16&size=6400x280&sensor=false&markers=color:red%7Clabel:Satit%7C",self.lat,@",",self.lng];
    
    [DLImageLoader loadImageFromURL:urlmap
                          completed:^(NSError *error, NSData *imgData) {
                              self.mapImage.image = [UIImage imageWithData:imgData];
    }];

    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footView;
    [self.tableView reloadData];
}

- (void)PESatitApiManager:(id)sender getContactErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

-(void)resizeHeightForLabel: (UILabel*)label {
    label.numberOfLines = 0;
    UIView *superview = label.superview;
    [label removeFromSuperview];
    [label removeConstraints:label.constraints];
    CGRect labelFrame = label.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect expectedFrame = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, 9999)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 label.font, NSFontAttributeName,
                                                                 nil]
                                                        context:nil];
        labelFrame.size = expectedFrame.size;
        labelFrame.size.height = ceil(labelFrame.size.height); //iOS7 is not rounding up to the nearest whole number
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        labelFrame.size = [label.text sizeWithFont:label.font
                                 constrainedToSize:CGSizeMake(label.frame.size.width, 9999)
                                     lineBreakMode:label.lineBreakMode];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    label.frame = labelFrame;
    [superview addSubview:label];
}
- (IBAction)mapTapped:(id)sender {
    
    [self.delegate HideTabbar];
    PFMapViewController *mapView = [[PFMapViewController alloc] init];
    
    if (IS_WIDESCREEN){
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController_Wide" bundle:nil];
    }else{
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController"bundle:nil];
    }
    
    mapView.delegate = self;
    mapView.locationname = [self.obj objectForKey:@"description"];
    mapView.lat = self.lat;
    mapView.lng = self.lng;
    
    [self.navController pushViewController:mapView animated:YES];
    
}

- (IBAction)callTapped:(id)sender {
    NSString *phone = [[NSString alloc] initWithFormat:@"telprompt://%@",[self.obj objectForKey:@"phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    
}

- (IBAction)websiteTapped:(id)sender {
    
    [self.delegate HideTabbar];
    PFWebViewViewController *webView = [[PFWebViewViewController alloc] init];
    
    if (IS_WIDESCREEN){
        webView = [[PFWebViewViewController alloc] initWithNibName:@"PFWebViewViewController_Wide" bundle:nil];
    }else{
        webView = [[PFWebViewViewController alloc] initWithNibName:@"PFWebViewViewController"bundle:nil];
    }
    
    NSString *toRecipents = [self.obj objectForKey:@"website"];
    webView.url = toRecipents;
    webView.delegate = self;
    [self.navController pushViewController:webView animated:YES];

}

- (IBAction)emailTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Menu"
                                  delegate:self
                                  cancelButtonTitle:@"cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Send Email", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
    //[self.actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Send Email"]) {
        NSLog(@"Send Email");
        // Email Subject
        NSString *emailTitle = @"Satit Email";
        // Email Content
        NSString *messageBody = @"Satit is so fun!";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:[self.obj objectForKey:@"email"]];
        //[self.obj objectForKey:@"email"]
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:146.0f/255.0f green:90.0f/255.0f blue:202.0f/255.0f alpha:1.0f]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc.navigationBar setTintColor:[UIColor whiteColor]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];

    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel");
    }
}

- (IBAction)facebookTapped:(id)sender {
    
    [self.delegate HideTabbar];
    PFWebViewViewController *webView = [[PFWebViewViewController alloc] init];
    
    if (IS_WIDESCREEN){
        webView = [[PFWebViewViewController alloc] initWithNibName:@"PFWebViewViewController_Wide" bundle:nil];
    }else{
        webView = [[PFWebViewViewController alloc] initWithNibName:@"PFWebViewViewController"bundle:nil];
    }
    
    NSString *facebook = [self.obj objectForKey:@"facebook"];
    webView.url = facebook;
    webView.delegate = self;
    [self.navController pushViewController:webView animated:YES];
    
}

- (IBAction)youtubeTapped:(id)sender {
    
    [self.delegate HideTabbar];
    PFWebViewViewController *webView = [[PFWebViewViewController alloc] init];
    
    if (IS_WIDESCREEN){
        webView = [[PFWebViewViewController alloc] initWithNibName:@"PFWebViewViewController_Wide" bundle:nil];
    }else{
        webView = [[PFWebViewViewController alloc] initWithNibName:@"PFWebViewViewController"bundle:nil];
    }
    
    NSString *youtube = [self.obj objectForKey:@"youtube"];
    webView.url = youtube;
    webView.delegate = self;
    [self.navController pushViewController:webView animated:YES];

}

- (IBAction)insideTapped:(id)sender {
    
    [self.delegate HideTabbar];
    PFWebViewViewController *webView = [[PFWebViewViewController alloc] init];
    
    if (IS_WIDESCREEN){
        webView = [[PFWebViewViewController alloc] initWithNibName:@"PFWebViewViewController_Wide" bundle:nil];
    }else{
        webView = [[PFWebViewViewController alloc] initWithNibName:@"PFWebViewViewController"bundle:nil];
    }
    
    NSString *inside = @"http://satitcmu-api.pla2app.com/insidewebview";
    webView.url = inside;
    webView.delegate = self;
    [self.navController pushViewController:webView animated:YES];
    
}

- (IBAction)powerbyTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pla2fusion.com/"]];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //[self reloadView];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)PFWebViewViewControllerBack {
    [self.delegate ShowTabbar];
}

- (void)PFMapViewControllerBack {
    [self.delegate ShowTabbar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactLabelDescCell *cell = [self tableView:self.tableView cellForRowAtIndexPath: indexPath];
    NSString *note = cell.descText.text;
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize bounds = [note sizeWithAttributes:@{NSFontAttributeName:font}];
    return (CGFloat) cell.bounds.size.height + bounds.height-16;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    ContactLabelDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactLabelDescCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactLabelDescCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.descText.text = [self.obj objectForKey:@"description"];
    
    CGRect frame = cell.descText.frame;
    frame.size = [cell.descText sizeOfMultiLineLabel];
    [cell.descText sizeOfMultiLineLabel];
    [cell.descText setFrame:frame];
    int lines = cell.descText.frame.size.height/15;
    cell.descText.numberOfLines = lines;
    
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.text = cell.descText.text;
    descText.textColor = [UIColor blackColor];
    
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    [descText setTextAlignment:NSTextAlignmentCenter];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end