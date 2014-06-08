//
//  PEEditAccountViewController.m
//  SatitCMU
//
//  Created by Pariwat on 5/29/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFEditAccountViewController.h"
#import "PFAppDelegate.h"

@interface PFEditAccountViewController ()

@end

@implementation PFEditAccountViewController

BOOL newMedia;

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
    
    //self.navigationItem.title = @"Profile Setting";
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(SaveProfile)];
    [anotherButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName:@"Helvetica" size:17.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    CALayer *editProfileViewradius = [self.editProfileView layer];
    [editProfileViewradius setMasksToBounds:YES];
    [editProfileViewradius setCornerRadius:5.0f];
    
    CALayer *picImg = [self.picImg layer];
    [picImg setMasksToBounds:YES];
    [picImg setCornerRadius:5.0f];
    
    self.satitApi = [[PESatitApiManager alloc] init];
    self.satitApi.delegate = self;
    self.coreData = [[NSDictionary alloc] initWithDictionary:[self.satitApi getCoreData]];
    [self.satitApi getUserSetting];
    
    self.scrollView.contentSize = CGSizeMake(self.editProfileView.frame.size.width, self.editProfileView.frame.size.height+20);
    self.editProfileView.frame = CGRectMake(10, 10, self.editProfileView.frame.size.width,self.editProfileView.frame.size.height);
    [self.scrollView addSubview:self.editProfileView];
    
    self.editDisplayNameTextField.delegate = self;
    self.editFacebookNameTextField.delegate = self;
    self.editEmailTextField.delegate = self;
    self.editPhoneNumberTextField.delegate = self;
    self.editPasswordTextField.delegate = self;
    
    NSString *picStr = [[NSString alloc] initWithFormat:@"%@user/%@/picture",API_URL,[self.coreData objectForKey:@"id"]];
    self.picImg.imageURL = [[NSURL alloc] initWithString:picStr];
    NSString *editfbname = [[NSString alloc] initWithFormat:@"facebook.com/%@",[self.coreData objectForKey:@"username"]];
    
    self.editFacebookNameTextField.text = editfbname;
    self.editDisplayNameTextField.text = [self.coreData objectForKey:@"username"];
    
    self.editEmailTextField.text = [self.coreData objectForKey:@"email_show"];
    self.editPhoneNumberTextField.text =  [self.coreData objectForKey:@"phone_show"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)hideKeyboard {
    [self.editDisplayNameTextField resignFirstResponder];
    [self.editFacebookNameTextField resignFirstResponder];
    [self.editEmailTextField resignFirstResponder];
    [self.editPhoneNumberTextField resignFirstResponder];
    [self.editPasswordTextField resignFirstResponder];
}

#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointMake(0, 307 - 170) animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)uploadPictureTapped:(id)sender {
    [self alertUpload];
}

- (void)alertUpload {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Profile Picture"
                                  delegate:self
                                  cancelButtonTitle:@"cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Camera", @"Camera Roll", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
    //[self.actionSheet showInView:self.view];
}

- (void)SaveProfile {
    
    [self hideKeyboard];
    
    [self.satitApi updateUserProfileEmail:self.editEmailTextField.text phone:self.editPhoneNumberTextField.text];
    
    if (self.pushNews.on){
        [self.satitApi setPushNews:@"new_update" onoff:@"1"];
    } else {
        [self.satitApi setPushNews:@"new_update" onoff:@"0"];
    }
    if (self.pushShowcase.on){
        [self.satitApi setPushShowcase:@"new_showcase" onoff:@"1"];
    } else {
        [self.satitApi setPushShowcase:@"new_showcase" onoff:@"0"];
    }
    if (self.pushFromSatit.on){
        [self.satitApi setPushFrom:@"news_from_dancezone" onoff:@"1"];
    } else {
        [self.satitApi setPushFrom:@"news_from_dancezone" onoff:@"0"];
    }
    [self alertComplete];

}

- (void)alertComplete {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Setting Profile."
                                                    message:@"Update Profile Complete."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}
//
//- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        
//    } else {
//        //go to profile setting
//    }
//}

- (void)PESatitApiManager:(id)sender getUserSettingResponse:(NSDictionary *)response {
    
    [self.waitView removeFromSuperview];
    
    [self.satitApi saveUserSettingToCoreDataWithUpdare:[response objectForKey:@"new_update"] showcase:[response objectForKey:@"new_showcase"] newsFromSatit:[response objectForKey:@"news_from_dancezone"]];
    
    if ( [[response objectForKey:@"new_update"] intValue] == 0 ) {
        self.pushNews.on = NO;
    } else {
        self.pushNews.on = YES;
    }
    if ( [[response objectForKey:@"new_showcase"] intValue] == 0 ) {
        self.pushShowcase.on = NO;
    } else {
        self.pushShowcase.on = YES;
    }
    if ( [[response objectForKey:@"news_from_dancezone"] intValue] == 0 ) {
        self.pushFromSatit.on = NO;
    } else {
        self.pushFromSatit.on = YES;
    }
    
}
- (void)PESatitApiManager:(id)sender getUserSettingErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ( buttonIndex == 0 ) {
        [self useCamera];
    } else if ( buttonIndex == 1 ) {
        [self useCameraRoll];
        
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
        [self presentViewController:imagePicker animated:YES completion:nil];
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
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    image = [self squareImageWithImage:image scaledToSize:CGSizeMake(640, 640)];
    NSData *imageData1 = UIImageJPEGRepresentation(image, 75);
    [self.satitApi uploadPicture:imageData1];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.picImg.image = image;
        
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache clearDisk];
        [imageCache cleanDisk];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFEditAccountViewControllerBack)]){
            [self.delegate PFEditAccountViewControllerBack];
        }
    }
    
}

@end
