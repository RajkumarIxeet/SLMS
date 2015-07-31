//
//  AppEngine.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "AppEngine.h"
#import "LoginHandler.h"
#import "UserDetail.h"
#import "NSString+AESCrypt.h"
#import "CourseHandler.h"

@implementation AppEngine

#pragma mark - User login


//User Login with credentials (user id and password)
-(void)loginWithUserName:(NSString*)userName password:(NSString*)password rememberMe:(BOOL)rememberMe success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    
    
    LoginHandler *login=[[LoginHandler alloc] init];
    // convert to AES 256 Exncryption
    NSString  *encpassword=password;//=  [password AES256EncryptWithKey:@"m@zd@10017017Int33r@IT"];
    //  NSString  *decpassword=  [encpassword AES256DecryptWithKey:@"m@zd@10017017Int33r@IT"];
    [login loginWithUserName:userName password:encpassword  success:^(UserDetails *userDetail){
        
//        if (rememberMe) {  //Save Login Detail In user default
//            [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:YES]];
//        }
//        else{//Remove Login Detail In user default
           // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
       // }
        
        [AppGlobal setValueInDefault:key_loginId value:userName];
        [AppGlobal setValueInDefault:key_loginPassword value:password];
        
        success(userDetail);
        
    }failure:^(NSError *error){
       // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];
}
#pragma mark - logout

//User Logout
-(void)logout:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
    
    LoginHandler *login=[[LoginHandler alloc] init];
    [login logout:^(BOOL logoutValue){
        success(logoutValue);
    }failure:^(NSError *error){
        failure(error);
    }];
}
#pragma mark - Forget Password


//User Forget password 
-(void)ForgetPasswordWithUserName:(NSString*)userName success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
    
    
    LoginHandler *login=[[LoginHandler alloc] init];
    
    [login ForgetPasswordWithUserName:userName  success:^(BOOL logoutValue){
        
        success(logoutValue);
        
    }failure:^(NSError *error){
        
        failure(error);
    }];
}
#pragma mark - User register


//User Register
-(void)registerWithUserDetail:(UserDetails*)user success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    
    LoginHandler *login=[[LoginHandler alloc] init];
 //   user.userPassword=  [user.userPassword AES256EncryptWithKey:@"m@zd@10017017Int33r@IT"];
    [login registerWithUserDetail:user  success:^(UserDetails *userDetail){
        
       
        
        success(userDetail);
        
    }failure:^(NSError *error){
       // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];
}
//FB Varification by Server
-(void)FBloginWithUserID:(NSString*)userid success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    
    LoginHandler *login=[[LoginHandler alloc] init];
    [login FBloginWithUserID:userid  success:^(UserDetails *userDetail){
        
        
        
        success(userDetail);
        
    }failure:^(NSError *error){
        //[AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];
}
//User Set FB  with user id
-(void)SetFBloginWithUserID:(NSString*)username FBID:(NSString*)fbid success:(void (^)(bool status))success  failure:(void (^)(NSError *error))failure{
    LoginHandler *login=[[LoginHandler alloc] init];
    [login SetFBloginWithUserID:username FBID:fbid  success:^(bool status){
        
        
        
        success(status);
        
    }failure:^(NSError *error){
       // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];

}
//get Master Data
-(void)getMasterData:(void (^)(BOOL success))success  failure:(void (^)(NSError *error))failure{
    LoginHandler *login=[[LoginHandler alloc] init];
    [login getMasterData:^(BOOL successValue){
        success(successValue);
    }failure:^(NSError *error){
        failure(error);
    }];
}

#pragma Courses Functions
//get my Course Data
-(void)getMyCourse:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *courses))success  failure:(void (^)(NSError *error))failure
{
    CourseHandler *course=[[ CourseHandler alloc] init];
    [course getMyCourse:userid  AndTextSearch:txtSearch success:^(NSMutableArray *courseList){
        success(courseList);
    }failure:^(NSError *error){
        failure(error);
    }];
}

#pragma Module Detail Functions
//get my module detail Data
-(void)getModuleDetail:(NSString*)userid  AndTextSearch:(NSString*)txtSearch AndSelectModule:(Module*)module AndSelectCourse:(Courses*)selectedcourse success:(void (^)(NSDictionary *moduleDetail))success  failure:(void (^)(NSError *error))failure
{
    CourseHandler *course=[[ CourseHandler alloc] init];
    [course getModuleDetail:userid  AndTextSearch:txtSearch AndSelectModule:module AndSelectCourse:selectedcourse success:^(NSDictionary *moduleDetail){
        success(moduleDetail);
    }failure:^(NSError *error){
        failure(error);
    }];
}

@end
