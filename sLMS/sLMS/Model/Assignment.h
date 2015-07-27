//
//  Assignment.h
//  sLMS
//
//  Created by Mayank on 21/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Assignment : NSObject

@property (nonatomic,strong) NSString* assignmentId;
@property (nonatomic,strong) NSString* assignmentName;
@property (nonatomic,strong) NSString* assignmentStatus;
@property (nonatomic,strong) NSString* assignmentSubmittedDate;
@property (nonatomic,strong) NSString* assignmentSubmittedBy;
@property (nonatomic,strong) NSMutableArray* attachedResource;

@end
