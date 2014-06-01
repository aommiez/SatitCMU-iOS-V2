//
//  PESeeAccountViewController.m
//  SatitCMU
//
//  Created by MRG on 3/15/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFSeeAccountViewController.h"

@interface PFSeeAccountViewController ()

@end

@implementation PFSeeAccountViewController

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
    
    self.navigationItem.title = @"Profile";
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.satitManager = [[PESatitApiManager alloc] init];
    self.satitManager.delegate = self;
    [self.satitManager getUserById:self.userId];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)PESatitApiManager:(id)sender getUserByIdResponse:(NSDictionary *)response {
    
    [self.waitView removeFromSuperview];
    
    NSString *picStr = [[NSString alloc] initWithFormat:@"%@user/%@/picture",API_URL,[response objectForKey:@"id"]];
    self.userPicture.imageURL = [[NSURL alloc] initWithString:picStr];
    self.displayName.text = [response objectForKey:@"username"];
    self.emailShow.text = [response objectForKey:@"email_show"];
    self.phoneShow.text = [response objectForKey:@"phone_show"];
    
}

-(void)PESatitApiManager:(id)sender getUserByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (IBAction)userPictureTapped:(id)sender {
    NSString *picStr = [[NSString alloc] initWithFormat:@"%@user/%@/picture?display=full",API_URL,self.userId];
    [self.delegate PFSeeAccountViewController:self viewPicture:picStr];
}

@end
