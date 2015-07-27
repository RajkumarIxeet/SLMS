//
//  CourseHandler.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "CourseHandler.h"
#import "AFHTTPRequestOperationManager.h"

@implementation CourseHandler
//get my Course Data
//get my Course Data
-(void)getMyCourse:(NSString*)userid AndTextSearch:(NSString*)txtSearch  success:(void (^)(NSMutableArray *courses))success   failure:(void (^)(NSError *error))failure{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userId":userid,
                                 @"searchText":txtSearch,
                                 };
    [manager POST:USER_COURSE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            

            //call Block function
            NSMutableArray *courseList= [[NSMutableArray alloc]init];
            
            for (NSDictionary *dicCourese in [responseDic objectForKey:@"courseList"]) {
                Courses *course= [[Courses alloc]init];
                course.startedOn=[dicCourese objectForKey:@"startedOn"];
                course.completedPercentStatus=[dicCourese objectForKey:@"completedPercentStatus"];
                course.courseId=[dicCourese objectForKey:@"courseId"];
                course.courseName=[dicCourese objectForKey:@"courseName"];
              
                NSMutableArray * arrayModule= [[NSMutableArray alloc]init];
                for (NSDictionary *dicModule in [dicCourese objectForKey:@"moduleList"]) {
                    Module *module= [[Module alloc]init];
                    module.startedOn=[dicModule objectForKey:@"startedOn"];
                    module.completedPercentStatus=[dicModule objectForKey:@"completedPercentStatus"];
                    module.moduleId=[dicModule objectForKey:@"moduleId"];
                    module.moduleName=[dicModule objectForKey:@"moduleName"];
                    [arrayModule addObject:module];
                }
                course.moduleList=arrayModule;
                [courseList addObject:course];
            }
            success(courseList);
            
            
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}
#pragma Module Detail Functions
//get my module detail Data
-(void)getModuleDetail:(NSString*)userid  AndTextSearch:(NSString*)txtSearch AndSelectModule:(Module*)module AndSelectCourse:(Courses*)course success:(void (^)(NSDictionary *moduleDetail))success  failure:(void (^)(NSError *error))failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userId":userid,@"courseId":course.courseId,@"moduleId":module.moduleId,
                                 @"searchText":txtSearch,
                                 };
//    parameters = @{@"userId":userid,@"courseId":@"1",@"moduleId":@"1",
//                    @"searchText":@"xxx",
//                    };
//  {"userId":"1","courseId":"1","moduleId":"1","searchText":"xxx"}
    [manager POST:USER_MODULE_DETAIL_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
//        //Success Full Logout
//        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
//            
        
            //call Block function
            NSMutableArray *resourceList= [[NSMutableArray alloc]init];
            NSMutableArray *assignmentList= [[NSMutableArray alloc]init];

            for (NSDictionary *dicContent in [responseDic objectForKey:@"resourceList"]) {
                Resourse *resource= [[Resourse alloc]init];
                resource.likeCounts=[NSString stringWithFormat:@"%@",  [dicContent objectForKey:@"likeCounts"] ];
                resource.shareCounts=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"shareCounts"]];
                resource.commentCounts=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"commentCounts"]];
                resource.resourceId=[dicContent objectForKey:@"resourceId"];
                
                resource.resourceImageUrl=[dicContent objectForKey:@"resourceImageUrl"];
                resource.resourceDesc=[dicContent objectForKey:@"resourceDesc"];
                resource.resourceUrl=[dicContent objectForKey:@"resourceUrl"];
                
                resource.startedOn=[dicContent objectForKey:@"startedOn"];
                resource.completedOn=[dicContent objectForKey:@"completedOn"];
                resource.authorName=[dicContent objectForKey:@"authorName"];
                
                
                NSMutableArray * arrayComments= [[NSMutableArray alloc]init];
                for (NSDictionary *dicComment in [dicContent objectForKey:@"commentList"]) {
                    Comments *comment= [[Comments alloc]init];
                    comment.likeCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"likeCounts"]];
                    comment.shareCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"shareCounts"]];
                    comment.commentCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"commentCounts"]];
                    comment.commentId=[dicComment objectForKey:@"commentId"];
                    
                    comment.parentCommentId=[dicComment objectForKey:@"parentCommentId"];
                    comment.commentBy=[dicComment objectForKey:@"commentBy"];
                    comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
                    comment.commentTxt=[dicComment objectForKey:@"commentTxt"];
                    comment.commentDate=[dicComment objectForKey:@"commentDate"];
                    [arrayComments addObject:comment];
                }
               
              
                resource.comments=arrayComments;
               
                NSMutableArray * arrayRelatedResource= [[NSMutableArray alloc]init];
                for (NSDictionary *dicRelatedResource in [dicContent objectForKey:@"relatedVideoList"]) {
                    Resourse *resource= [[Resourse alloc]init];
                    resource.resourceId=[dicRelatedResource objectForKey:@"resourceId"];
                    resource.resourceDesc=[dicRelatedResource objectForKey:@"resourceDesc"];
                    resource.resourceUrl=[dicRelatedResource objectForKey:@"resourceUrl"];
                    resource.startedOn=[dicRelatedResource objectForKey:@"uploadedDate"];
                    [arrayRelatedResource addObject:resource];
                }
                
                resource.relatedResources=arrayRelatedResource;
                [resourceList addObject:resource];
            }
            //call Block function
           
            for (NSDictionary *dicAssign in [responseDic objectForKey:@"resourceList"]) {
                Assignment  *assignment= [[Assignment   alloc]init];
                assignment.assignmentId=[dicAssign objectForKey:@"assignmentId"];
                assignment.assignmentName=[dicAssign objectForKey:@"assignmentName"];
                assignment.assignmentStatus=[dicAssign objectForKey:@"assignmentStatus"];
                assignment.assignmentSubmittedDate=[dicAssign objectForKey:@"assignmentSubmittedDate"];
                
                assignment.assignmentSubmittedBy=[dicAssign objectForKey:@"assignmentSubmittedBy"];
                
                NSMutableArray * arrayRelatedResource= [[NSMutableArray alloc]init];
                for (NSDictionary *dicRelatedResource in [dicAssign objectForKey:@"attachedResource"]) {
                    Resourse *resource= [[Resourse alloc]init];
                    resource.resourceId=[dicRelatedResource objectForKey:@"resourceId"];
                    resource.resourceDesc=[dicRelatedResource objectForKey:@"resourceDesc"];
                    resource.resourceUrl=[dicRelatedResource objectForKey:@"resourceUrl"];
                    resource.startedOn=[dicRelatedResource objectForKey:@"uploadedDate"];
                    [arrayRelatedResource addObject:resource];
                }
                
                assignment.attachedResource=arrayRelatedResource;
                [assignmentList addObject:assignment];
            }
            NSMutableDictionary *moduleDetail=[[NSMutableDictionary alloc]init ];
            [moduleDetail setObject:resourceList forKey:@"resourceList"];
            [moduleDetail setObject:assignmentList forKey:@"assignmentList"];
            success(moduleDetail);
            
            
//        }
//        else {
//            //call Block function
//            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}
@end
