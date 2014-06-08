//
//  PEAccountViewController.m
//  SatitCMU
//
//  Created by MRG on 2/17/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFAccountViewController.h"
#import "PFAppDelegate.h"

@interface PFAccountViewController ()

@end

@implementation PFAccountViewController

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
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.satitApi = [[PESatitApiManager alloc] init];
    self.satitApi.delegate = self;
    self.coreData = [[NSDictionary alloc] initWithDictionary:[self.satitApi getCoreData]];
    [self.satitApi getUserSetting];
    
    self.scrollView.contentSize = CGSizeMake(self.formView.frame.size.width, self.formView.frame.size.height+20);
    self.formView.frame = CGRectMake(10, 10, self.formView.frame.size.width,self.formView.frame.size.height);
    [self.scrollView addSubview:self.formView];
    
    CALayer *logoutbt = [self.logoutButton layer];
    [logoutbt setMasksToBounds:YES];
    [logoutbt setCornerRadius:5.0f];
    
    CALayer *formViewradius = [self.formView layer];
    [formViewradius setMasksToBounds:YES];
    [formViewradius setCornerRadius:5.0f];
    
    CALayer *thumUser = [self.thumUser layer];
    [thumUser setMasksToBounds:YES];
    [thumUser setCornerRadius:5.0f];    
    
    self.navigationItem.title = @"Profile Setting";
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editProfileTapped)];
    [anotherButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName:@"Helvetica" size:17.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    self.usernameShow.text = [self.coreData objectForKey:@"username"];
    NSString *fbname = [[NSString alloc] initWithFormat:@"facebook.com/%@",[self.coreData objectForKey:@"username"]];
    self.facebookNameShow.text = fbname;
    self.emailShow.text = [self.coreData objectForKey:@"email_show"];
    self.telShow.text = [self.coreData objectForKey:@"phone_show"];
    
    NSString *picStr = [[NSString alloc] initWithFormat:@"%@user/%@/picture",API_URL,[self.coreData objectForKey:@"id"]];
    self.thumUser.imageURL = [[NSURL alloc] initWithString:picStr];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)editProfileTapped {
    
    PFEditAccountViewController *editView = [[PFEditAccountViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        editView = [[PFEditAccountViewController alloc] initWithNibName:@"PFEditAccountViewController_Wide" bundle:nil];
    } else {
        editView = [[PFEditAccountViewController alloc] initWithNibName:@"PFEditAccountViewController" bundle:nil];
    }
    editView.delegate = self;
    [self.navigationController pushViewController:editView animated:YES];

}

- (IBAction)logoutTapped:(id)sender {

        [FBSession.activeSession closeAndClearTokenInformation];
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
        
        //--- Listing file by name sort
        //NSLog(@"\n File list %@",fileList);
        
        for(NSString *filePath in fileList){
            NSString *resourceDocPath = [[NSString alloc] initWithString:[[[[NSBundle mainBundle]  resourcePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Documents"]];
            NSString *nameId = [[NSString alloc] initWithFormat:@"%@",filePath];
            NSString *filePathz = [resourceDocPath stringByAppendingPathComponent:nameId];
            [manager removeItemAtPath:filePathz error:nil];
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    
    //}
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    //NSLog(@"fb logout");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    //--- Listing file by name sort
    //NSLog(@"\n File list %@",fileList);
    
    for(NSString *filePath in fileList){
        NSString *resourceDocPath = [[NSString alloc] initWithString:[[[[NSBundle mainBundle]  resourcePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Documents"]];
        NSString *nameId = [[NSString alloc] initWithFormat:@"%@",filePath];
        NSString *filePathz = [resourceDocPath stringByAppendingPathComponent:nameId];
        [manager removeItemAtPath:filePathz error:nil];
    }

    [self.delegate ShowTabbar];
    
    PFUpdateViewController *news = [[PFUpdateViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        news = [[PFUpdateViewController alloc] initWithNibName:@"PFUpdateViewController_Wide" bundle:nil];
    } else {
        news = [[PFUpdateViewController alloc] initWithNibName:@"PFUpdateViewController" bundle:nil];
    }
    
    [self presentViewController:news animated:NO completion:NULL];
    
    //exit(0);
}

- (IBAction)picFullTapped:(id)sender {
    NSString *picStr = [[NSString alloc] initWithFormat:@"%@user/%@/picture?display=full",API_URL,[self.coreData objectForKey:@"id"]];
    [self.delegate PFAccountViewController:self viewPicture:picStr];
}

- (void)PESatitApiManager:(id)sender getUserSettingResponse:(NSDictionary *)response {
    
    [self.waitView removeFromSuperview];
    
    [self.satitApi saveUserSettingToCoreDataWithUpdare:[response objectForKey:@"new_update"] showcase:[response objectForKey:@"new_showcase"] newsFromSatit:[response objectForKey:@"news_from_dancezone"]];
    
    if ( [[response objectForKey:@"new_update"] intValue] == 0 ) {
        self.pushNewsShow.on = NO;
    } else {
        self.pushNewsShow.on = YES;
    }
    if ( [[response objectForKey:@"new_showcase"] intValue] == 0 ) {
        self.pushShowcaseShow.on = NO;
    } else {
        self.pushShowcaseShow.on = YES;
    }
    if ( [[response objectForKey:@"news_from_dancezone"] intValue] == 0 ) {
        self.pushFromSatitShow.on = NO;
    } else {
        self.pushFromSatitShow.on = YES;
    }

}
- (void)PESatitApiManager:(id)sender getUserSettingErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)PFEditAccountViewControllerBack {
    [self viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFAccountViewControllerBack)]){
            [self.delegate PFAccountViewControllerBack];
        }
    }
    
}


@end
