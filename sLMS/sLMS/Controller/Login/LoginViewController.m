
//
//  LoginViewController.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomKeyboard.h"
#import "ForgetPasswordViewController.h"
#import "RegisterationViewController.h"
#import "FeedViewController.h"
@interface LoginViewController() <CustomKeyboardDelegate>
{
    //keyboard
    CustomKeyboard *customKeyboard;
    UITextField *activeTextField;
}

@end

@implementation LoginViewController
@synthesize btnRemember,txtPassword,txtUsername,imgLogo;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //init the keyboard
    if([AppGlobal getValueInDefault:key_UserId ]!=nil)
    {
        FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    customKeyboard = [[CustomKeyboard alloc] init];
    customKeyboard.delegate = self;
    
    //Default On Remember Me
    [btnRemember setSelected:YES];
    [self setDataOnView];
    [self toggleHiddenState:YES];
    // self.lblLoginStatus.text = @"";
    
    self.btnFacebook.delegate = self;
    self.btnFacebook.readPermissions = @[@"public_profile", @"email"];
    [self changeFrameAndBackgroundImg];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Set data on view
-(void)setDataOnView{
    
    //Set Login Detail
    BOOL rememberMe=[[AppGlobal getValueInDefault:key_rememberMe] boolValue];
    if (rememberMe) {  //Save Login Detail In user default
        NSString *loginID=[AppGlobal getValueInDefault:key_loginId];
        NSString *loginPassword=[AppGlobal getValueInDefault:key_loginPassword];
        [self.txtUsername setText:loginID];
        [self.txtPassword setText:loginPassword];
    }
    
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)changeFrameAndBackgroundImg
{
    
    //  _btnFacebook.frame = CGRectMake(0, _btnFacebook.frame.origin.y+14, _btnFacebook.frame.size.width, 120);
    //  _btnFacebook.frame = CGRectMake(320/2 - 93/2, self.view.frame.size.height -200, 93, 40);
    for (id loginObject in _btnFacebook.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  loginObject;
            UIImage *loginImage = [UIImage imageNamed:@"login_white.png"];
            // loginButton.alpha = 0.7;
            [loginButton setBackgroundColor:[UIColor colorWithRed:186.0 green:0.0 blue:50.0 alpha:0.0]];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            //CGSize constraint = CGSizeMake(400, 220);
            // [loginButton sizeThatFits:constraint];
            //[loginButton sizeToFit];
        }
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  loginObject;
            loginLabel.text = @"";
            loginLabel.frame = CGRectMake(0, 0, 0, 0);
        }
    }
}
#pragma mark - Private method implementation

-(void)toggleHiddenState:(BOOL)shouldHide{
    //    self.lblUsername.hidden = shouldHide;
    //    self.lblEmail.hidden = shouldHide;
    //    self.profilePicture.hidden = shouldHide;
}


#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged in.";
    
    [self toggleHiddenState:NO];
    [self changeFrameAndBackgroundImg];
}


-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    NSLog(@"%@", user);
    //if user is already sign in Then validate with server.
    
    // get user id
    NSString *userid=[NSString  stringWithFormat:@"%@",[user objectForKey:@"id"]];
    
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] FBloginWithUserID:userid success:^(UserDetail *userDetail) {
        [AppGlobal setValueInDefault:key_UserId value:userDetail.userId];
        [AppGlobal setValueInDefault:key_UserName value:userDetail.userFirstName];
        [AppGlobal setValueInDefault:key_UserEmail value:userDetail.userEmail];
        [self loginSucessFullWithFB];
        
        //Hide Indicator
        [appDelegate hideSpinner];
    }
                                     failure:^(NSError *error) {
                                         //Hide Indicator
                                         [appDelegate hideSpinner];
                                         NSLog(@"failure JsonData %@",[error description]);
                                         [self loginError:error];
                                         [self loginViewShowingLoggedOutUser:loginView];

                                     }];
    
    
    // if user valid then navigate to main screen.
    
    //    self.profilePicture.profileID = user.id;
    //    self.lblUsername.text = user.name;
    //    self.lblEmail.text = [user objectForKey:@"email"];
}

-(void)loginSucessFullWithFB{
    // if FB Varification is done then navigate the main screen
    
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged out";
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [self toggleHiddenState:YES];
}

#pragma mark - Login Action

-(IBAction)btnRememberClick:(id)sender{
    
    if ([btnRemember isSelected]) {
        [btnRemember setSelected:NO];
    }else{
        [btnRemember setSelected:YES];
    }
}



- (IBAction)btnLoginClick:(id)sender {
    NSString *loginID=[[txtUsername text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password=[[txtPassword text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([loginID length] <= 0) {
        [AppGlobal showAlertWithMessage:MISSING_LOGIN_ID title:@""];
    }else if ([password length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_PASSWORD title:@""];
    }
    else{
        [txtUsername resignFirstResponder];
        [txtPassword resignFirstResponder];
        
        //Show Indicator
        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
        
        [[appDelegate _engine] loginWithUserName:loginID password:password  rememberMe:[btnRemember isSelected]
                                         success:^(UserDetail *userDetail) {
                                             [AppGlobal setValueInDefault:key_UserId value:userDetail.userId];
                                             [AppGlobal setValueInDefault:key_UserName value:userDetail.userFirstName];
                                             [AppGlobal setValueInDefault:key_UserEmail value:userDetail.userEmail];
                                             [self loginSucessFull];
                                             
                                             //Hide Indicator
                                             [appDelegate hideSpinner];
                                         }
                                         failure:^(NSError *error) {
                                             //Hide Indicator
                                             [appDelegate hideSpinner];
                                             NSLog(@"failure JsonData %@",[error description]);
                                             [self loginError:error];
                                             
                                         }];
    }
    
    
    
}

- (IBAction)btnCreatAccount:(id)sender {
    RegisterationViewController *viewController= [[RegisterationViewController alloc]initWithNibName:@"RegisterationViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnForgetpasswordClick:(id)sender {
    ForgetPasswordViewController *forgetViewController= [[ForgetPasswordViewController alloc]initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgetViewController animated:YES];
}





-(void)loginSucessFull{
    
   
    [txtUsername setText:@""];
    [txtPassword setText:@""];
    [self dismissViewControllerAnimated:YES completion:^{}];
    FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}

//- (void) loginButton:	(FBSDKLoginButton *)loginButton didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
//error:	(NSError *)error
//{
//    if ([FBSDKAccessToken currentAccessToken]) {
//        // User is logged in, do work such as go to next view controller.
//    }
//}
//- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
//    
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        [storage deleteCookie:cookie];
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES ];
}
#pragma --
#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //[self setPositionOfLoginBaseViewWhenStartEditing];
    
    activeTextField = textField;
    
    UIToolbar* toolbar;
    if (textField.tag == 10) {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:FALSE :TRUE];
        
    }
    else if (textField.tag == 11)
    {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:TRUE :FALSE];
        
    }
    [textField setInputAccessoryView:toolbar];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    [self nextClicked:textField.tag];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}
#pragma mark Custom Keyboard Delegate

- (void)nextClicked:(NSUInteger)selectedId
{
    NSInteger nextTag = activeTextField.tag + 1;
    
    UITextField *nextResponder = (UITextField*)[self.view viewWithTag:nextTag];
    
    if (!nextResponder.enabled) {
        nextResponder = (UITextField*)[self.view  viewWithTag:nextTag+1];
    }
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        //Not found, so remove keyboard.
        [nextResponder resignFirstResponder];
    }
}
- (void)previousClicked:(NSUInteger)selectedId
{
    NSInteger nextTag = activeTextField.tag -1;
    
    UITextField *nextResponder = (UITextField*) [self.view  viewWithTag:nextTag];
    
    while(!nextResponder.enabled)
    {
        nextResponder = (UITextField*)[self.view  viewWithTag:nextTag-1];
    }
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [nextResponder resignFirstResponder];
        
    }
    
}
- (void)doneClicked:(NSUInteger)selectedId
{
    
    
    [activeTextField resignFirstResponder];
    
}



@end
