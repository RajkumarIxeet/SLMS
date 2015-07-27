//
//  FeedViewController.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblWelcome;
- (IBAction)btnLogout:(id)sender;
//@property (strong, nonatomic) IBOutlet UITabBarItem *tbAssignment;
//@property (strong, nonatomic) IBOutlet UITabBarItem *tbUpdate;
//@property (strong, nonatomic) IBOutlet UITabBarItem *tbCourses;
//@property (strong, nonatomic) IBOutlet UITabBarItem *tbNotification;
//@property (strong, nonatomic) IBOutlet UITabBarItem *tbMore;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdates;
@property (strong, nonatomic) IBOutlet UIButton *btnAssignment;
@property (strong, nonatomic) IBOutlet UIButton *btnCourses;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIButton *btnNotification;

@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;

- (IBAction)btnAssignmentClick:(id)sender;
- (IBAction)btnCourseClick:(id)sender;
- (IBAction)btnNotificationClick:(id)sender;
- (IBAction)btnUpdateClick:(id)sender;
- (IBAction)btnMoreClick:(id)sender;

@end
