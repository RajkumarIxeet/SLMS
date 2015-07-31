//
//  FeedViewController.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "FeedViewController.h"
#import "CourseViewController.h"
#import "CourseViewController.h"
#import "FeedViewController.h"
#import "AssignmentViewController.h"
#import "ModuleDetailViewController.h"
@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize txtSearchBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIViewController *feedview = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
//    UIViewController *courseView = [[CourseViewController alloc] initWithNibName:@"CourseViewController" bundle:nil];
//    
//    self.tabBarController = [[UITabBarController alloc] init];
//    self.tabBarController.viewControllers = [NSArray arrayWithObjects:feedview,courseView, nil];
    [txtSearchBar setBackgroundColor:[UIColor clearColor]];
    [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn.png"]];
    UITextField *txfSearchField = [txtSearchBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor clearColor]];
    //[txfSearchField setLeftView:UITextFieldViewModeNever];
    [txfSearchField setBorderStyle:UITextBorderStyleNone];
    [txfSearchField setTextColor:[UIColor whiteColor]];
    //  [txfSearchField setFont:(UIFont fontWithName:@"Heal" size:<#(CGFloat)#>)]

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLogout:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    UIViewController *vc = tabBarController.selectedViewController;
//    
//    if (tabBarController.selectedIndex == 0) {
//       
//    }
//    return YES;
//}

- (IBAction)btnAssignmentClick:(id)sender {
}

- (IBAction)btnCourseClick:(id)sender {
//    CourseViewController *courseView= [[CourseViewController alloc]init];
//    [self.navigationController pushViewController:courseView animated:YES];
//    //    [self.navigationController pushViewController:module animated:YES];
    ModuleDetailViewController *module= [[ModuleDetailViewController alloc]init];
    [self.navigationController pushViewController:module animated:YES];
  
}

- (IBAction)btnNotificationClick:(id)sender {
}

- (IBAction)btnUpdateClick:(id)sender {
}
- (IBAction)btnMoreClick:(id)sender {
}
@end
