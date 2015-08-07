//
//  UpdateTableViewCell.h
//  sLMS
//
//  Created by Mayank on 06/08/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnUpdatedBy;
@property (strong, nonatomic) IBOutlet UIView *viewDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnContent;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UILabel *txtviewDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;

@end
