//
//  PENotifyViewController.m
//  SatitCMU
//
//  Created by MRG on 3/24/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFNotifyViewController.h"

@interface PFNotifyViewController ()

@end

@implementation PFNotifyViewController

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
    
    self.navigationItem.title = @"Notifications";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[self.obj objectForKey:@"length"] integerValue];
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    PFNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFNotificationCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFNotificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.bg.image = [UIImage imageNamed:@"NotBoxNoReadIp5.png"];
    cell.topicLabel.text = @"Joe Smith";
    cell.timeLabel.text = @"2014-05-24 4:22 PM";
    cell.msgLabel.text = @"This is a notification. This is a notification. This is a notification. This is a notification. This is a notification. This is a notification. This is a notification.";
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFNotifyViewControllerBack)]){
            [self.delegate PFNotifyViewControllerBack];
        }
    }
    
}

@end
