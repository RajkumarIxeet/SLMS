//
//  ProfileViewController.m
//  sLMS
//
//  Created by Mayank on 30/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "CourseViewController.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize lblClass,lblEmail,lblFirstName,lblLastName,lblHomeRoom,lblSchoolAdminEmail,lblSchoolName,btnLogout,fbview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self toggleHiddenState:YES];
    // self.lblLoginStatus.text = @"";
   
    if(  [AppSingleton sharedInstance].isUserFBLoggedIn ==YES)
    {
        self.fbview.hidden=YES;
      
    }else{
        self.fbview.hidden=NO;
        self.fbview.delegate = self;
        self.fbview.readPermissions = @[@"public_profile", @"email"];
        [self changeFrameAndBackgroundImg];
    }
    [self setUserProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    NSLog(@"%@", user);
    //if user is already sign in Then validate with server.
    
    // get user id
    NSString *fbuserid=[NSString  stringWithFormat:@"%@",[user objectForKey:@"id"]];
    //set user Profile
    //Show Indicator
    NSString *username=[AppSingleton sharedInstance].userDetail.userEmail;
   
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] SetFBloginWithUserID:username FBID:fbuserid success:^(bool status) {
        self.fbview.hidden=YES;
        [self loginSucessFullWithFB:fbuserid];
        //Hide Indicator
        [appDelegate hideSpinner];


    } failure:^(NSError *error) {
                                         //Hide Indicator
                                         [appDelegate hideSpinner];
                                         NSLog(@"failure JsonData %@",[error description]);
                                         [self loginViewShowingLoggedOutUser:loginView];
                                         
                                         [self loginError:error];
                                         
                                     }];
    
}
-(void)setUserProfile {
   // UserDetails *user=[AppGlobal readUserDetail];
    UserDetails *user=[AppSingleton sharedInstance].userDetail;
    
    lblFirstName.text=user.userFirstName;
    lblLastName.text=user.userLastName;
    lblEmail.text=user.userEmail;
    lblSchoolName.text=user.schoolName;
    lblSchoolAdminEmail.text=user.adminEmailId;
    lblClass.text=user.className;
    lblHomeRoom.text=user.homeRoomName;
    if(user.userFBID==nil)
    {
        //need to validate
        fbview.hidden=NO;
    }else{
    //FB allready validated
        fbview.hidden=YES;
    }
    }
-(void)loginSucessFullWithFB:(NSString*)userid {
    // if FB Varification is done then navigate the main screen
    
    [AppGlobal  setValueInDefault:userid value:key_FBUSERID];
    
}
-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
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
-(void)changeFrameAndBackgroundImg
{
    
    //  _btnFacebook.frame = CGRectMake(0, _btnFacebook.frame.origin.y+14, _btnFacebook.frame.size.width, 120);
    //  _btnFacebook.frame = CGRectMake(320/2 - 93/2, self.view.frame.size.height -200, 93, 40);
    for (id loginObject in fbview.subviews)
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
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged out";
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [self toggleHiddenState:YES];
}
- (IBAction)btnLogoutClick:(id)sender {
    if(  [AppSingleton sharedInstance].isUserFBLoggedIn==YES)
    {
        [self loginViewShowingLoggedOutUser:fbview];
    }
    [AppSingleton sharedInstance].isUserFBLoggedIn=NO;
    [AppSingleton sharedInstance].isUserLoggedIn=NO;
    LoginViewController *viewCont= [[LoginViewController alloc]init];
    [self.navigationController pushViewController:viewCont animated:YES];
  
}
- (IBAction)btnAssignmentClick:(id)sender {
}

- (IBAction)btnCourseClick:(id)sender {
       CourseViewController *courseView= [[CourseViewController alloc]init];
       [self.navigationController pushViewController:courseView animated:YES];
    //    //    [self.navigationController pushViewController:module animated:YES];
//    ModuleDetailViewController *module= [[ModuleDetailViewController alloc]init];
//    [self.navigationController pushViewController:module animated:YES];
    
}

- (IBAction)btnNotificationClick:(id)sender {
}

- (IBAction)btnUpdateClick:(id)sender {
}
- (IBAction)btnMoreClick:(id)sender {
}
@end
