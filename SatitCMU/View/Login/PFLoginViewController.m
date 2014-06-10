//
//  PELoginViewController.m
//  SatitCMU
//
//  Created by MRG on 2/27/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFLoginViewController.h"

@interface PFLoginViewController ()

@end

@implementation PFLoginViewController

NSString *gender;
NSString *password;

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
    
    gender = nil;
    self.pick = [[UIDatePicker alloc] init];
    self.pickDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pickDone setFrame:CGRectMake(50, 370, 200, 44)];
    self.pickDone.alpha = 0;
    [self.pick setFrame:CGRectMake(0,200,320,120)];
    self.pick.alpha = 0;
    
    // Do any additional setup after loading the view from its nib.
    self.loginView.layer.masksToBounds = NO;
    self.loginView.layer.cornerRadius = 4; // if you like rounded corners
    self.loginView.layer.shadowOffset = CGSizeMake(-5, 10);
    self.loginView.layer.shadowRadius = 5;
    self.loginView.layer.shadowOpacity = 0.5;
    
    self.registerView.layer.masksToBounds = NO;
    self.registerView.layer.cornerRadius = 4; // if you like rounded corners
    self.registerView.layer.shadowOffset = CGSizeMake(-5, 10);
    self.registerView.layer.shadowRadius = 5;
    self.registerView.layer.shadowOpacity = 0.5;
    
    self.satitApi = [[PESatitApiManager alloc] init];
    self.satitApi.delegate = self;
    
    FBLoginView *fbView = [[FBLoginView alloc] init];
    fbView.delegate = self;
    fbView.frame = CGRectMake(20, 123, 240, 60);
    fbView.readPermissions = @[@"basic_info", @"email"];
    FBSession *session = [[FBSession alloc] initWithPermissions:@[@"basic_info", @"email"]];
    [FBSession setActiveSession:session];
    [self.loginView addSubview:fbView];
    
    self.registerView.frame = CGRectMake(20, 600, self.registerView.frame.size.width, self.registerView.frame.size.height);
    self.loginView.frame = CGRectMake(20, 600, self.loginView.frame.size.width, self.loginView.frame.size.height);
    
    [self.view addSubview:self.loginView];

    [UIView mt_animateViews:@[self.loginView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
        self.loginView.frame = CGRectMake(20, 80, self.loginView.frame.size.width, self.loginView.frame.size.height);
    } completion:^{
        NSLog(@"animation ok");
    }];
    
    self.menu = @"";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - function helper
- (void)delView {
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{self.blurView.alpha = 0;}
                     completion:^(BOOL finished){ [self.view removeFromSuperview]; }];
    
}
- (void)hideKeyboard {
    
    [self.emailSignIn resignFirstResponder];
    [self.passwordSignIn resignFirstResponder];
    [self.username resignFirstResponder];
    [self.emailSignUp resignFirstResponder];
    [self.passwordSignUp resignFirstResponder];
    [self.confirmSignUp resignFirstResponder];
}

-(void)dateBirthButtonClicked {
    self.registerView.alpha = 1;
    self.blurView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.0
                          delay:0.0  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseInOut
                     animations:^ {
                         //[self.scrollView setAlpha:1];
                         NSString *dateString = [NSDateFormatter localizedStringFromDate:self.pick.date
                                                                               dateStyle:NSDateFormatterShortStyle
                                                                               timeStyle:NSDateFormatterNoStyle];
                         [self.dateOfBirthSignUp setText:dateString];
                         self.pick.alpha = 0;
                         self.pickDone.alpha = 0;
                         [self.pickDone removeFromSuperview];
                         [self.pick removeFromSuperview];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (void)closeBox {
    [self hideKeyboard];
    
    [UIView mt_animateViews:@[self.loginView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
        self.loginView.frame = CGRectMake(20, 600, self.loginView.frame.size.width, self.loginView.frame.size.height);
    } completion:^{
        //[self.view removeFromSuperview];
    }];
    [UIView mt_animateViews:@[self.registerView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
        self.registerView.frame = CGRectMake(20, 600, self.registerView.frame.size.width, self.registerView.frame.size.height);
    } completion:^{
        //[self.view removeFromSuperview];
    }];
    [self performSelector:@selector(delView) withObject:self afterDelay:0.2 ];
    
}
#pragma - action
- (IBAction)signupTapeed:(id)sender {
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    scrollview.contentSize = CGSizeMake(320, 700);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollview addGestureRecognizer:singleTap];
    
    [scrollview addSubview:self.registerView];
    [self.view addSubview:scrollview];
    
    [UIView mt_animateViews:@[self.loginView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
        self.loginView.frame = CGRectMake(20, 600, self.loginView.frame.size.width, self.loginView.frame.size.height);
    } completion:^{
        [UIView mt_animateViews:@[self.registerView] duration:0.0 timingFunction:kMTEaseOutBack animations:^{
            self.registerView.frame = CGRectMake(20, 70, self.registerView.frame.size.width, self.registerView.frame.size.height);
        } completion:^{
            NSLog(@"animation ok");
        }];
    }];
    
}

- (IBAction)bgTapped:(id)sender {
    [self closeBox];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self closeBox];
}

- (IBAction)signinTapped:(id)sender {
    if ([self validateEmail:[self.emailSignIn text]]) {
        if ( self.passwordSignIn.text.length > 3 )
        {
            [self hideKeyboard];
            [self.satitApi loginWithEmail:self.emailSignIn.text Password:self.passwordSignIn.text deviceToken:@"a"];
        }
    }
}

- (IBAction)dateBTapped:(id)sender {
    [self hideKeyboard];
    self.registerView.alpha = 0;
    self.blurView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.0
                          delay:0.0  /* starts the animation after 3 seconds */
                        options:UIViewAnimationCurveEaseInOut
                     animations:^ {
                         [self.pickDone setFrame:CGRectMake(50, 370, 200, 44)];
                         [self.pickDone setTintColor:[UIColor whiteColor]];
                         [self.pickDone setTitle:@"Ok !" forState:UIControlStateNormal];
                         [self.pickDone addTarget:self action:@selector(dateBirthButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                         self.pickDone.alpha = 1;
                         [self.view addSubview:self.pickDone];
                         self.pick.alpha = 1;
                         [self.pick setFrame:CGRectMake(0,200,320,120)];
                         self.pick.backgroundColor = [UIColor whiteColor];
                         self.pick.hidden = NO;
                         self.pick.datePickerMode = UIDatePickerModeDate;
                         self.pick.tintColor = [UIColor whiteColor];
                         [self.view addSubview:self.pick];
                         //[self.scrollView setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)sumitTapped:(id)sender {
    
    password = self.passwordSignUp.text;
    
    if (self.selectGender.selectedSegmentIndex == 0) {
        gender = @"Male";
    } else {
        gender = @"Female";
    }
    if ( [self.username.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Satit CMU!"
                                                          message:@"Username Incorrect"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else if ( [self.emailSignUp.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Satit CMU!"
                                                          message:@"Email Incorrect"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else if ( ![self validateEmail:[self.emailSignUp text]] ) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Satit CMU!"
                                                          message:@"Enter a valid email address"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else if ( [self.passwordSignUp.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Satit CMU"
                                                          message:@"Password Incorrect"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else if (![self.passwordSignUp.text isEqualToString:self.confirmSignUp.text]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Satit CMU!"
                                                          message:@"And password do not match."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }  else if ( [self.dateOfBirthSignUp.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Satit CMU!"
                                                          message:@"Birth of Date Incorrect"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    } else {
        [self.satitApi signupWithUsername:self.username.text email:self.emailSignUp.text password:self.passwordSignUp.text gender:gender dateOfBirth:self.dateOfBirthSignUp.text];
    }
}

#pragma mark - Satit Api Delegate
- (void)PESatitApiManager:(id)sender loginWithEmailResponse:(NSDictionary *)response {
    if ([[[response objectForKey:@"error"] objectForKey:@"code"] intValue] == 401 ) {
        [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                    message:[[response objectForKey:@"error"] objectForKey:@"message"]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [self.satitApi saveToCoreData:response];
        [self closeBox];
        
        if ([self.menu isEqualToString:@"account"]) {
            self.menu = @"";
            [self.delegate PFAccountViewController:self];
            
        } else if ([self.menu isEqualToString:@"notify"]) {
            self.menu = @"";
            [self.delegate PFNotifyViewController:self];
            
        }
    }
}

- (void)PESatitApiManager:(id)sender loginWithEmailErrorResponse:(NSString *)errorResponse {
    [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                message:errorResponse
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)PESatitApiManager:(id)sender signupWithUsernameResponse:(NSDictionary *)response {
    
    NSLog(@"%@",response);
    if ([response objectForKey:@"error"] != nil ) {
        [[[UIAlertView alloc] initWithTitle:@"Signup failed"
                                    message:[[response objectForKey:@"error"] objectForKey:@"message"]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [self.satitApi saveCoreData:response];
        [self closeBox];
        [self hideKeyboard];
    
        //[self.satitApi loginWithEmail:[response objectForKey:@"username"] Password:password deviceToken:@"a"];
    }
}

- (void)PESatitApiManager:(id)sender signupWithUsernameErrorResponse:(NSString *)errorResponse {
    [[[UIAlertView alloc] initWithTitle:@"Signup failed"
                                message:errorResponse
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)PESatitApiManager:(id)sender loginWithFacebookResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    [self.satitApi saveToCoreData:response];
    [self closeBox];
    
    if ([self.menu isEqualToString:@"account"]) {
        self.menu = @"";
        [self.delegate PFAccountViewController:self];
        
    } else if ([self.menu isEqualToString:@"notify"]) {
        self.menu = @"";
        [self.delegate PFNotifyViewController:self];
    
    }
    
}
- (void)PESatitApiManager:(id)sender loginWithFacebookErrorResponse:(NSString *)errorResponse {
    [[[UIAlertView alloc] initWithTitle:@"Login failed"
                                message:errorResponse
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - Facebook Delegate
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    [self.satitApi loginWithFacebook:[user objectForKey:@"email"] fbid:[user objectForKey:@"id"] firstName:[user objectForKey:@"first_name"] lastName:[user objectForKey:@"last_name"] username:[user objectForKey:@"username"] deviceToken:@"no"];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"You're logged in as");
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"You're not logged in!");
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField  {
    
    [self.emailSignIn resignFirstResponder];
    [self.passwordSignIn resignFirstResponder];
    
    [self.username resignFirstResponder];
    [self.emailSignUp resignFirstResponder];
    [self.passwordSignUp resignFirstResponder];
    [self.confirmSignUp resignFirstResponder];
    
    return YES;
}

@end
