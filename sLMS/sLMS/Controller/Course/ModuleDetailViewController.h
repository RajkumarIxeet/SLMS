//
//  ModuleDetailViewController.h
//  sLMS
//
//  Created by Mayank on 20/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ViewController.h"
#import "Courses.h"
#import "Assignment.h"
#import "Comments.h"
#import "ScrollViewContainer.h"

@interface ModuleDetailViewController : ViewController<UIScrollViewDelegate>{
IBOutlet UITableView *tblViewContent;
IBOutlet UITableView *tblViewAssignment;
}
@property (strong, nonatomic) IBOutlet UIButton *btnUpdates;
@property (strong, nonatomic) IBOutlet UIButton *btnAssignment;
@property (strong, nonatomic) IBOutlet UIButton *btnCourses;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIButton *btnNotification;
@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;
@property (strong, nonatomic)  Courses *selectedCourse;
@property (strong, nonatomic)  Module *selectedModule;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet ScrollViewContainer *scollViewContainer;

- (IBAction)btnAssignmentClick:(id)sender;
- (IBAction)btnCourseClick:(id)sender;
- (IBAction)btnNotificationClick:(id)sender;
- (IBAction)btnUpdateClick:(id)sender;
- (IBAction)btnMoreClick:(id)sender;

@end
