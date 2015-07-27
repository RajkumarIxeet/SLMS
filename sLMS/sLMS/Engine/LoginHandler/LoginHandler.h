//
//  LoginHandler.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetail.h"
@interface LoginHandler : NSObject
//User Login
-(void)loginWithUserName:(NSString*)userName password:(NSString*)password  success:(void (^)(UserDetail *userDetail))success  failure:(void (^)(NSError *error))failure;

//User Logout
-(void)logout:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;\
//User Forget password
-(void)ForgetPasswordWithUserName:(NSString*)userName success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;

//User Register
-(void)registerWithUserDetail:(UserDetail*)user success:(void (^)(UserDetail *userDetail))success  failure:(void (^)(NSError *error))failure;

//User Validation From FB
-(void)FBloginWithUserID:(NSString*)userid   success:(void (^)(UserDetail *userDetail))success  failure:(void (^)(NSError *error))failure;

//User Set FB  with user id
-(void)SetFBloginWithUserID:(NSString*)username FBID:(NSString*)fbid success:(void (^)(bool status))success  failure:(void (^)(NSError *error))failure;
//get all master data
-(void)getMasterData:(void (^)(BOOL success))success  failure:(void (^)(NSError *error))failure;


@end
