//
//  PFAppDelegate.m
//  SatitCMU
//
//  Created by MRG on 5/30/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFAppDelegate.h"


@implementation PFAppDelegate

BOOL newMedia;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    [FBLoginView class];
    
    self.satitApi = [[PESatitApiManager alloc] init];
    if ([[self.satitApi getAuth] isEqualToString:@"NO Login"]) {
        [self.satitApi setTokenForGuest];
        NSLog(@"No Login");
    } else {
        NSLog(@"Login");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
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
    
    update.delegate = self;
    showcase.delegate = self;
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
    self.window.rootViewController = self.tabBarViewController;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:@"deviceToken"];
    [defaults synchronize];
    
    NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return (UIInterfaceOrientationMaskAll);
}

- (void)HideTabbar {
    [self.tabBarViewController hideTabBarWithAnimation:YES];
}

- (void)ShowTabbar {
    [self.tabBarViewController showTabBarWithAnimation:YES];
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL uploadp = NO;
    photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:link]];
    [photos addObject:photo];
    enableGrid = NO;
    self.photos = photos;
    self.thumbs = thumbs;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.uploadButton = uploadp;
    [browser setCurrentPhotoIndex:0];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
    
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current {
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    BOOL uploadp = NO;
    
    for (int i=0; i<[sum count]; i++) {
        NSString *t = [[NSString alloc] initWithFormat:@"%@",[sum objectAtIndex:i]];
        photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:t]];
        [photos addObject:photo];
    }
    
    enableGrid = NO;
    self.photos = photos;
    self.thumbs = thumbs;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.uploadButton = uploadp;
    [browser setCurrentPhotoIndex:[current intValue]];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser DoneTappedDelegate:(NSUInteger)index {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    //[self showTabbar];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser uploadTappedDelegate:(NSUInteger)index {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Profile Picture"
                                  delegate:self
                                  cancelButtonTitle:@"cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Camera", @"Camera Roll", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 0 ) {
        [self useCamera];
    } else if ( buttonIndex == 1 ) {
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
            [self useCameraRoll];
        }];
        
    }
}

- (void) useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:   UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =   [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = YES;
        imagePicker.editing = YES;
        imagePicker.navigationBarHidden=YES;
        imagePicker.view.userInteractionEnabled=YES;
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
    }
}

- (void) useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =   [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =   UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePicker.allowsEditing = YES;
        imagePicker.editing = YES;
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    image = [self squareImageWithImage:image scaledToSize:CGSizeMake(640, 640)];
    NSData *imageData1 = UIImageJPEGRepresentation(image, 75);
    [self.satitApi uploadPicture:imageData1];
    [picker dismissViewControllerAnimated:YES completion:^{
        //accView.thumUser.image = image;
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache clearDisk];
        [imageCache cleanDisk];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
