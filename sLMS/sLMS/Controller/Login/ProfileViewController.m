//
//  ProfileViewController.m
//  sLMS
//
//  Created by Mayank on 30/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize lblClass,lblEmail,lblFirstName,lblLastName,lblHomeRoom,lblSchoolAdminEmail,lblSchoolName,userid;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    // self.lblLoginStatus.text = @"";
   
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
   
    
}

//- (IBAction)btnAssignmentClick:(id)sender {
//}
//
//- (IBAction)btnCourseClick:(id)sender {
//       CourseViewController *courseView= [[CourseViewController alloc]init];
//       [self.navigationController pushViewController:courseView animated:YES];
//     
//}
//
//- (IBAction)btnNotificationClick:(id)sender {
//}
//
//- (IBAction)btnUpdateClick:(id)sender {
//}
//- (IBAction)btnMoreClick:(id)sender {
//}
@end
