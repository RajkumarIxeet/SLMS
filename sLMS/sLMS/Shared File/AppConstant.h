//
//  AppConstant.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#ifndef sLMS_AppConstant_h
#define sLMS_AppConstant_h

#define  APP_URL  @"http://191.239.57.54:8080/"

#define MASTER_DATA_URL APP_URL@"SLMS/rest/common/getMasterData"
#define USER_REGISTER_URL APP_URL@"SLMS/rest/user/register"
#define USER_LOGIN_URL APP_URL@"SLMS/rest/user/login"
#define USER_LOGUT_URL APP_URL@"SLMS/rest/user/logout"
#define USER_FORGETPASSWORD_URL(username) [NSString stringWithFormat:APP_URL@"SLMS/rest/user/forgetPwd/userId/%@",username]

#define USER_REGISTER_URL APP_URL@"SLMS/rest/user/register"
#define USER_SET_FB_URL(userName,fbId) [NSString stringWithFormat:APP_URL@"SLMS/rest/user/setFBId/userName/%@/userFbId/%@",userName,fbId]
#define USER_VALIDATE_FB_URL(fbId) [NSString stringWithFormat:APP_URL@"SLMS/rest/user/getByFBId/userFbId/%@",fbId]

#define USER_COURSE_URL APP_URL@"SLMS/rest/course/getCourses"
#define USER_MODULE_DETAIL_URL APP_URL@"SLMS/rest/course/getModuleDetail"
//Key For UserDefault
//Comment and like URL
#define CMT_ON_RESOURCE_URL APP_URL@"SLMS/rest/course/commentOnResourse"
#define LIKE_ON_RESOURCE_URL(username,resourceid) [NSString stringWithFormat:APP_URL@"SLMS/rest/course/likeOnResource/username/%@/resourceId/%@",username,resourceid]

#define CMT_ON_CMT_URL APP_URL@"/SLMS/rest/course/commentOnComment"

#define LIKE_ON_CMT_URL(useremail,commentId) [NSString stringWithFormat:APP_URL@"SLMS/rest/course/likeOnResource/username/%@/commentId/%@",useremail,commentId]

#define key_Custom_DateFormate @"yyyy-MM-dd HH:mm:ss.S"
#define key_loginId @"LoginId"
#define key_loginPassword @"LoginPassword"
//#define key_rememberMe @"rememberMe"
//#define key_UserId @"UserId"
//#define key_UserName @"UserName"
//#define key_UserEmail @"UserEmail"
//#define key_IsLoginFromFB @"IsLoginFromFB"
#define key_FBUSERID @"FBUSERID"
//App Delegate Reference
#define appDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

//server Respond Key
#define key_severRespond_Status @"status"
#define key_severRespond_StatusMessage @"statusMessage"
#define REGISTER_SUCCESS_MSG @"Thank you for registering with SLMS, your registration is pending for approval from school admin. You will be notified in email if you are approved."
#define FORGET_SUCCESS_MSG(useremail)[NSString stringWithFormat:@"Your password is sent to %@, please check SPAM folder if not received in inbox.",useremail]

// Error Msg
#define ERROR_DEFAULT_MSG @"There seems to be a problem connecting with server. Please check your network connection."
#define MISSING_LOGIN_ID_PWD @"Email and Password can't empty, please enter a valid email and password."
#define MISSING_LOGIN_ID @"Email can't be empty, please enter a valid email."
#define MISSING_PASSWORD @"Password can't be empty, please enter a valid password."
#define MISSING_PASSWORD_LENGTH @"Short passwords are easy to guess. Try one with at least 8 characters including a alphabet and a number."
#define MISSING_PASSWORD_NUMBER @"Short passwords are easy to guess. Try one with at least 8 characters including a alphabet and a number."
#define MISSING_PASSWORD_CHAR @"Short passwords are easy to guess. Try one with at least 8 characters including a alphabet and a number."
#define MISSING_FORGET_EMAIL  @"Email can't be empty, please enter a registered email id to get password."
#define MISSING_VALID_EMAIL_ID @"Enter a valid email id including '@' and '.'."
#define MISSING_FIRST_NAME @"First name can't be empty."
#define MISSING_LAST_NAME @"Last name can't be empty."
#define MISSING_EMAIL_ID @"Email can't be empty."
#define MISSING_CNF_PASSWORD @"Confirm Password does n't match with password."
#define MISSING_CNF_PASSWORD_NOT_MATCH @"Your new password and confirm password do not match."
#define MISSING_SCHOOL @"School name is not selected."
#define MISSING_CLASS @" Class is not selected."
#define MISSING_TITLE @" Title is not selected."
#define MISSING_HOME @"Home room is not selected."
#define MISSING_ADMIN_EMAIL @" School email can't be empty."
#define MISSING_ADMIN_VLID_EMAIL @" School email seems to be incorrect, Enter a valid email id  including '@' and '.' "


// Success Message Alert Title

#define SUCCESS_MESSAGE_ALERT_TITLE @"Info"
#define DATA_LOADING_MSG @"Please wait..."

//Dropdown Enums
typedef NS_ENUM(NSInteger, AppDropdownType){
   
    SCHOOL_DATA,
    CLASS_DATA,
    ROOM_DATA,
    TITLE_DATA,
    COURSE_DATA
};
typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

typedef enum ActionOn {
    Resource,
    Comment,
   
} ActionOn;
#endif
