//
//  FeedViewController.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "UpdateViewController.h"
#import "CourseViewController.h"
#import "CourseViewController.h"
#import "UpdateViewController.h"
#import "AssignmentViewController.h"
#import "UpdateTableViewCell.h"
#import "Update.h"
#import "HomeViewController.h"
@interface UpdateViewController ()
{
    NSMutableArray *arrayUpdates;
}
@end

@implementation UpdateViewController
@synthesize txtSearchBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(  [AppSingleton sharedInstance].isUserLoggedIn!=YES)
    {
        [self.tabBarController.tabBar setHidden:YES];
        HomeViewController *viewController= [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        //        FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
        [self.tabBarController.tabBar setHidden:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
  
        // Custom initialization
        [self setSearchUI];
  
}
-(void)setSearchUI
{
if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( screenHeight < screenWidth ){
        screenHeight = screenWidth;
    }
    
    if( screenHeight > 480 && screenHeight < 667 ){
        NSLog(@"iPhone 5/5s");
    } else if ( screenHeight > 480 && screenHeight < 736 ){
        NSLog(@"iPhone 6");
        [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn_6.png"]];
        
    } else if ( screenHeight > 480 ){
       // [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn.png"]];
        
        NSLog(@"iPhone 6 Plus");
    } else {
        NSLog(@"iPhone 4/4s");
        
    }
    [txtSearchBar setBackgroundColor:[UIColor clearColor]];
  UITextField *txfSearchField = [txtSearchBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor clearColor]];
    //[txfSearchField setLeftView:UITextFieldViewModeNever];
    [txfSearchField setBorderStyle:UITextBorderStyleNone];
  //  [txfSearchField setTextColor:[UIColor whiteColor]];
}
}
-(void)viewWillAppear:(BOOL)animated
{
        NSLog(@"%d", [AppSingleton sharedInstance].isUserLoggedIn);
    
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

//- (IBAction)btnAssignmentClick:(id)sender {
//}
//
//- (IBAction)btnCourseClick:(id)sender {
//    CourseViewController *courseView= [[CourseViewController alloc]init];
//    [self.navigationController pushViewController:courseView animated:YES];
//
//  
//}
//
//- (IBAction)btnNotificationClick:(id)sender {
//}
//
//- (IBAction)btnUpdateClick:(id)sender {
//}
//- (IBAction)btnMoreClick:(id)sender {
//}
#pragma mark - Table view data source

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    [self.tableView setEditing:editing animated:animated];
//    [self.tableView reloadData];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"You are in: %s", __FUNCTION__);
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayUpdates count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //#import "ContentCellTableViewCell.h"
    //#import "AssignmentTableViewCell.h"
    //#import "CommentTableViewCell.h"
    
    static NSString *identifier = @"UpdateTableViewCell";
        UpdateTableViewCell *cell = (UpdateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Update *update=[arrayUpdates objectAtIndex:indexPath.row];
        if(update.updateDesc!=nil)
        {
            cell.txtviewDetail.text=update.updateDesc;
            
        }else{
          cell.txtviewDetail.text=update.updateDesc;
        }
        if (update.resource!=nil) {
            
            if(update.resource.resourceImageUrl!=nil){
                
                if (update.resource.resourceImageData==nil) {
                    NSURL *imageURL = [NSURL URLWithString:update.resource.resourceImageUrl];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        update.resource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            UIImage *img=[UIImage imageWithData:update.resource.resourceImageData];
                            if(img!=nil)
                            {
                                [cell.btnContent setImage:img forState:UIControlStateNormal];
                                
                                [cell.btnContent setBackgroundColor:[UIColor clearColor]];
                            }
                        });
                    });
                }else{
                    UIImage *img=[UIImage imageWithData:update.resource.resourceImageData];
                    [cell.btnContent setImage:img forState:UIControlStateNormal];
                    
                    [cell.btnContent setBackgroundColor:[UIColor clearColor]];
                }
            }
        }else{
        
        }
       
        if(update.updateCreatedByImage!=nil){
            
            if (update.updateCreatedByImageData==nil) {
                NSURL *imageURL = [NSURL URLWithString:update.updateCreatedByImage];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    update.updateCreatedByImageData  = [NSData dataWithContentsOfURL:imageURL];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        UIImage *img=[UIImage imageWithData:update.updateCreatedByImageData ];
                        if(img!=nil)
                        {
                            [cell.btnUpdatedBy setImage:img forState:UIControlStateNormal];                   [cell.btnUpdatedBy setBackgroundColor:[UIColor clearColor]];
                        }
                    });
                });
            }else{
                UIImage *img=[UIImage imageWithData:update.updateCreatedByImageData ];
                               [cell.btnUpdatedBy setImage:img forState:UIControlStateNormal];
                [cell.btnUpdatedBy setBackgroundColor:[UIColor clearColor]];
            }
        }
        [cell.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(update.isLike)
        {
            cell.btnLike.selected=YES;
            [cell.btnLike setTitle:update.likeCount forState:UIControlStateSelected];
        }else
            
        {
            cell.btnLike.selected=NO;
            [cell.btnLike setTitle:update.likeCount forState:UIControlStateNormal];
        }
        [cell.btnComment setTitle:update.commentCount forState:UIControlStateNormal];
        
        cell.btnComment.tag=[update.updateId integerValue];
        cell.btnLike.tag=[update.updateId  integerValue];
        cell.btnShare.tag=[update.updateId  integerValue];
        //set action for comment and like on resource
        [cell.btnComment addTarget:self action:@selector(btnCommentOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLike addTarget:self action:@selector(btnLikeOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShare addTarget:self action:@selector(btnShareOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
       if(update.likeCount==nil)
       {
            [cell.btnLike setHidden:YES];
            [cell.btnComment setHidden:YES];
            [cell.btnShare setHidden:YES];
       }
        
        return cell;
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//    BOOL isChild =
    //    currentExpandedIndex > -1
    //    && indexPath.row > currentExpandedIndex
    //    && indexPath.row <= currentExpandedIndex + [[moduleArray objectAtIndex:currentExpandedIndex] count];
    //
    //    if (isChild) {
    //        NSLog(@"A child was tapped, do what you will with it");
    //        return;
    //    }
    //
    //    [tableViewCourse beginUpdates];
    //
    //    if (currentExpandedIndex == indexPath.row) {
    //        [self collapseSubItemsAtIndex:currentExpandedIndex];
    //        currentExpandedIndex = -1;
    //    }
    //    else {
    //
    //        BOOL shouldCollapse = currentExpandedIndex > -1;
    //
    //        if (shouldCollapse) {
    //            [self collapseSubItemsAtIndex:currentExpandedIndex];
    //        }
    //
    //        currentExpandedIndex = (shouldCollapse && indexPath.row > currentExpandedIndex) ? indexPath.row - [[moduleArray objectAtIndex:currentExpandedIndex] count] : indexPath.row;
    //
    //        [self expandItemAtIndex:currentExpandedIndex];
    //    }
    
    
    
    //    [tableViewCourse endUpdates];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

@end
