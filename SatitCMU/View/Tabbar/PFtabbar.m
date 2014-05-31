//
//  PFtabbar.m
//  PFTabbarContoller
//
//  Created by MRG on 5/19/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFtabbar.h"

@interface PFtabbar ()

@end

@implementation PFtabbar

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
    // Do any additional setup after loading the view from its nib.
    
    PFUpdateViewController *update = [[PFUpdateViewController alloc] init];
    PFShowcaseViewController *showcase = [[PFShowcaseViewController alloc] init];
    PFActivityViewController *activity = [[PFActivityViewController alloc] init];
    PFContactViewController *contact = [[PFContactViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        update = [[PFUpdateViewController alloc] initWithNibName:@"PFUpdateViewController_Wide" bundle:nil];
        showcase = [[PFShowcaseViewController alloc] initWithNibName:@"PFShowcaseViewController_Wide" bundle:nil];
        activity = [[PFActivityViewController alloc] initWithNibName:@"PFActivityViewController_Wide" bundle:nil];
        contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController_Wide" bundle:nil];
    
    } else {
        update = [[PFUpdateViewController alloc] initWithNibName:@"PFUpdateViewController" bundle:nil];
        showcase = [[PFShowcaseViewController alloc] initWithNibName:@"PFShowcaseViewController" bundle:nil];
        activity = [[PFActivityViewController alloc] initWithNibName:@"PFActivityViewController" bundle:nil];
        contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController" bundle:nil];
    
    }
    
    activity.delegate = self;
    contact.delegate = self;
    
    self.tabBarViewController = [[PFTabBarViewController alloc] initWithBackgroundImage:nil viewControllers:update,showcase,activity,contact,nil];
    
    if(IS_WIDESCREEN){
        
        PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
        [item0 setHighlightedImage:[UIImage imageNamed:@"icon_update_onIp5"]];
        [item0 setStanbyImage:[UIImage imageNamed:@"icon_update_offIp5"]];
        
        PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
        [item1 setHighlightedImage:[UIImage imageNamed:@"icon_showcase_onIp5"]];
        [item1 setStanbyImage:[UIImage imageNamed:@"icon_showcase_offIp5"]];
        
        PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
        [item2 setHighlightedImage:[UIImage imageNamed:@"icon_activity_onIp5"]];
        [item2 setStanbyImage:[UIImage imageNamed:@"icon_activity_offIp5"]];
        
        PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
        [item3 setHighlightedImage:[UIImage imageNamed:@"icon_contact_onIp5"]];
        [item3 setStanbyImage:[UIImage imageNamed:@"icon_contact_offIp5"]];
        
    }else{
        
        PFTabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
        [item0 setHighlightedImage:[UIImage imageNamed:@"icon_update_onIp4"]];
        [item0 setStanbyImage:[UIImage imageNamed:@"icon_update_offIp4"]];
        
        PFTabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
        [item1 setHighlightedImage:[UIImage imageNamed:@"icon_showcase_onIp4"]];
        [item1 setStanbyImage:[UIImage imageNamed:@"icon_showcase_offIp4"]];
        
        PFTabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
        [item2 setHighlightedImage:[UIImage imageNamed:@"icon_activity_onIp4"]];
        [item2 setStanbyImage:[UIImage imageNamed:@"icon_activity_offIp4"]];
        
        PFTabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
        [item3 setHighlightedImage:[UIImage imageNamed:@"icon_contact_onIp4"]];
        [item3 setStanbyImage:[UIImage imageNamed:@"icon_contact_offIp4"]];
        
    }
    
    [self.tabBarViewController setSelectedIndex:0];
    [self.view addSubview:_tabBarViewController.view];
}

- (void)HideTabbar {
    [self.tabBarViewController hideTabBarWithAnimation:YES];
}

- (void)ShowTabbar {
    [self.tabBarViewController showTabBarWithAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
