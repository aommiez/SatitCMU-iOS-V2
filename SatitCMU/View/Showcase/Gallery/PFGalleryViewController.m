//
//  PFGalleryViewController.m
//  SatitCMU
//
//  Created by Pariwat on 6/1/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFGalleryViewController.h"

@interface PFGalleryViewController ()

@end

@implementation PFGalleryViewController

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
    
//    // Navbar setup
//    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:146.0f/255.0f green:90.0f/255.0f blue:202.0f/255.0f alpha:1.0f]];
//    
//    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
//    
//    [[self.navController navigationBar] setTranslucent:YES];
//    [self.view addSubview:self.navController.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.navigationController.visibleViewController != self) {
        if([self.delegate respondsToSelector:@selector(PFGalleryViewControllerBack)]){
            [self.delegate PFGalleryViewControllerBack];
        }
    }

}

@end
