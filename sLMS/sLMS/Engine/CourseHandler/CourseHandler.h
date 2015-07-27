//
//  CourseHandler.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Courses.h"
#import "Module.h"
#import "Resourse.h"
#import "Comments.h"
#import "Assignment.h"

@interface CourseHandler : NSObject
//get my Course Data
-(void)getMyCourse:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *courses))success   failure:(void (^)(NSError *error))failure;

#pragma Module Detail Functions
//get my module detail Data
-(void)getModuleDetail:(NSString*)userid  AndTextSearch:(NSString*)txtSearch AndSelectModule:(Module*)module AndSelectCourse:(Courses*)course success:(void (^)(NSDictionary *moduleDetail))success  failure:(void (^)(NSError *error))failure;

@end
