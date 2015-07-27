//
//  LoginViewController.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnRemember;
- (IBAction)btnRememberClick:(id)sender;
- (IBAction)btnLoginClick:(id)sender;
- (IBAction)btnCreatAccount:(id)sender;

- (IBAction)btnForgetpasswordClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet FBLoginView *btnFacebook;

@end
