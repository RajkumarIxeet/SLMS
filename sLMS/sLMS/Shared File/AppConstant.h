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
#define USER_FORGETPASSWORD_URL(username) [NSString stringWithFormat:APP_URL@"SLMS/rest/user /forgetPwd/userId/%@",username]

#define USER_REGISTER_URL APP_URL@"SLMS/rest/user/register"
#define USER_SET_FB_URL(userName,fbId) [NSString stringWithFormat:APP_URL@"SLMS/rest/user/setFBId/userName/%@/userFbId/%@",userName,fbId]
#define USER_VALIDATE_FB_URL(fbId) [NSString stringWithFormat:APP_URL@"SLMS/rest/user/getByFBId/userFbId/%@",fbId]

#define USER_COURSE_URL APP_URL@"SLMS/rest/course/getCourses"
#define USER_MODULE_DETAIL_URL APP_URL@"SLMS/rest/course/getModuleDetail"
//Key For UserDefault

#define key_loginId @"LoginId"
#define key_loginPassword @"LoginPassword"
#define key_rememberMe @"rememberMe"
#define key_UserId @"UserId"
#define key_UserName @"UserName"
#define key_UserEmail @"UserEmail"
//App Delegate Reference
#define appDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

//server Respond Key
#define key_severRespond_Status @"status"
#define key_severRespond_StatusMessage @"statusMessage"

// Error Msg
#define ERROR_DEFAULT_MSG @"There seems to be a problem connecting with server. Please check your network connection."
#define MISSING_LOGIN_ID @"Please enter user id."
#define MISSING_PASSWORD @"Please enter password."
#define MISSING_PASSWORD_LENGTH @"Password can not less then 8 char and greater then 15"
#define MISSING_PASSWORD_NUMBER @"Password have at least one number."
#define MISSING_PASSWORD_CHAR @"Password have at least one letter."

#define MISSING_EMAIL_ID @"Please enter email id."
#define MISSING_FIRST_NAME @"Please enter first name."
#define MISSING_LAST_NAME @"Please enter last name."
#define MISSING_EMAIL_ID @"Please enter email id."
#define MISSING_CNF_PASSWORD @"Your new password and confirm password do not match."
#define MISSING_CNF_PASSWORD_NOT_MATCH @"Your new password and confirm password do not match."
#define MISSING_SCHOOL @"Please select school name."
#define MISSING_CLASS @"Please select class name."
#define MISSING_HOME @"Please select home room"
#define MISSING_ADMIN_EMAIL @"Please enter admin email id."


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
#endif
