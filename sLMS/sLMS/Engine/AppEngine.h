//
//  AppEngine.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginHandler.h"
#import "UserDetail.h"
#import "Courses.h"
#import "Module.h"
#import "Resourse.h"
#import "Comments.h"
#import "Assignment.h"
@protocol ApppEngineDelegate <NSObject>

@optional

@end
@interface AppEngine : NSObject
//User Login with credentials (user id and password)
-(void)loginWithUserName:(NSString*)userName password:(NSString*)password rememberMe:(BOOL)rememberMe success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure;
#pragma mark - logout

//User Logout
-(void)logout:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;
//User Register
-(void)registerWithUserDetail:(UserDetails*)user success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure;
-(void)ForgetPasswordWithUserName:(NSString*)userName success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;

//FB Varification by Server
-(void)FBloginWithUserID:(NSString*)userid success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure;
//User Set FB  with user id
-(void)SetFBloginWithUserID:(NSString*)username FBID:(NSString*)fbid success:(void (^)(bool status))success  failure:(void (^)(NSError *error))failure;
//get Master Data
-(void)getMasterData:(void (^)(BOOL success))success  failure:(void (^)(NSError *error))failure;

#pragma Courses Functions
//get my Course Data
-(void)getMyCourse:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *courses))success  failure:(void (^)(NSError *error))failure;

#pragma Module Detail Functions
//get my module detail Data
-(void)getModuleDetail:(NSString*)userid  AndTextSearch:(NSString*)txtSearch AndSelectModule:(Module*)module AndSelectCourse:(Courses*)course success:(void (^)(NSDictionary *moduleDetail))success  failure:(void (^)(NSError *error))failure;

@end
