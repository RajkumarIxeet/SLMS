//
//  CourseViewController.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseTableViewCell.h"
#import "ModuleTableViewCell.h"
#import "Courses.h"
#import "Module.h"
#import "ModuleDetailViewController.h"
@interface CourseViewController ()
{
    NSMutableArray *coursesList;
   
    NSMutableArray *moduleArray; // array of arrays
    
    int currentExpandedIndex;
}
@end

@implementation CourseViewController
@synthesize btnAssignment,btnCourses,btnMore,btnNotification,btnUpdates,txtSearchBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // [self  getCourses:@""];
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    ModuleDetailViewController *module= [[ModuleDetailViewController alloc]init];
//    [self.navigationController pushViewController:module animated:YES];
    ModuleDetailViewController *module= [[ModuleDetailViewController alloc]init];
    [self.navigationController pushViewController:module animated:YES];
//    [txtSearchBar setBackgroundColor:[UIColor clearColor]];
//    [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn.png"]];
//    UITextField *txfSearchField = [txtSearchBar valueForKey:@"_searchField"];
//    [txfSearchField setBackgroundColor:[UIColor clearColor]];
//    //[txfSearchField setLeftView:UITextFieldViewModeNever];
//    [txfSearchField setBorderStyle:UITextBorderStyleNone];
//    [txfSearchField setTextColor:[UIColor whiteColor]];
    //  [txfSearchField setFont:(UIFont fontWithName:@"Heal" size:<#(CGFloat)#>)]
    //topItems = [[NSArray alloc] initWithArray:[self topLevelItems]];
   
    
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
#pragma mark - Data generators

//- (NSArray *)topLevelItems {
//    NSMutableArray *items = [NSMutableArray array];
//    
//    for (int i = 0; i < 10; i++) {
//        [items addObject:[NSString stringWithFormat:@"Item %d", i + 1]];
//    }
//    
//    return items;
//}
//
//- (NSArray *)subItems:(Courses *)course {
//    NSMutableArray *moduleList = [NSMutableArray array];
//    
//    for (Module *module in course.moduleList) {
//        [items addObject:[NSString stringWithFormat:@"SubItem %d", i + 1]];
//    }
//    
//    return items;
//}
#pragma mark - tab bar Action
- (IBAction)btnAssignmentClick:(id)sender {
}

- (IBAction)btnCourseClick:(id)sender {
}

- (IBAction)btnNotificationClick:(id)sender {
}

- (IBAction)btnUpdateClick:(id)sender {
}
- (IBAction)btnMoreClick:(id)sender {
}
#pragma mark - UISearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   // isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d");
    
    //Remove all objects first.
//    [filteredContentList removeAllObjects];
//    
//    if([searchText length] != 0) {
//        isSearching = YES;
//        [self searchTableList];
//    }
//    else {
//        isSearching = NO;
//    }
    // [self.tblContentList reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self getCourses:searchBar.text];
   // [self searchTableList];
}

#pragma mark Course Private functions
-(void) getCourses:(NSString *) txtSearch
{
   NSString *userid=[NSString  stringWithFormat:@"%@",[AppGlobal getValueInDefault:key_UserId]];
    userid=@"1";
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getMyCourse:userid  AndTextSearch:txtSearch success:^(NSMutableArray *courses) {
        coursesList=courses;
        moduleArray     = [NSMutableArray new];
        currentExpandedIndex = -1;
        for (Courses *course in coursesList) {
            [moduleArray addObject:course.moduleList];
        }

        [tableViewCourse reloadData];
              // [self loginSucessFullWithFB];
        
        //Hide Indicator
        [appDelegate hideSpinner];
    }
                                     failure:^(NSError *error) {
                                         //Hide Indicator
                                         [appDelegate hideSpinner];
                                         NSLog(@"failure JsonData %@",[error description]);
//                                         [self loginError:error];
//                                         [self loginViewShowingLoggedOutUser:loginView];
                                         
                                     }];
    

}

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"You are in: %s", __FUNCTION__);
    //return [coursesList count] ; // sum of title and detail content rows
     int rowsCount=[coursesList count] + ((currentExpandedIndex > -1) ? [[moduleArray objectAtIndex:currentExpandedIndex] count] : 0);
     NSLog(@"You are in: %s row count=%d", __FUNCTION__,rowsCount);
    return  rowsCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[moduleArray objectAtIndex:currentExpandedIndex] count];
    
    if(!isChild)
    {
        static NSString *identifier = @"CourseTableViewCell";
        CourseTableViewCell *cell = (CourseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        
        
        int topIndex = (currentExpandedIndex > -1 && indexPath.row > currentExpandedIndex)
        ? indexPath.row - [[moduleArray objectAtIndex:currentExpandedIndex] count]
        : indexPath.row;
        
        Courses *course=[coursesList objectAtIndex:topIndex];
        CGFloat stepSize = 0.01f;
      
        NSCalendar* calendar = [NSCalendar currentCalendar];
      //  NSDate *dt=[NSDateFormatter date] course.startedOn;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormat setLocale:[NSLocale currentLocale]];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        [dateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        NSDate *date = [dateFormat dateFromString: course.startedOn];
        
       // NSDate *currentDate = [NSDate dt];
//        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dt]; // Get necessary date components

        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  date]; // Get necessary date components
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        [cell.lblDate setText: [NSString stringWithFormat:@"%@ %ld",monthName,(long)components.day]];
      
        [cell.lblCourseName setText: course.courseName];
        [cell.probarCourse setProgress:[course.completedPercentStatus floatValue]*stepSize animated:YES  ];
        [cell.lblPercent  setText: [NSString stringWithFormat:@"%@ %s" ,course.completedPercentStatus,"%"]];
        if ([course.completedPercentStatus floatValue]==100.00) {
            cell.probarCourse.progressTintColor=[UIColor greenColor];
        }
        
        return cell;
    }else{
        static NSString *identifier = @"ModuleTableViewCell";
        ModuleTableViewCell *cell = (ModuleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Module *module= [[moduleArray objectAtIndex:currentExpandedIndex] objectAtIndex:indexPath.row - currentExpandedIndex - 1];
        
        
         CGFloat stepSize = 0.01f;
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormat setLocale:[NSLocale currentLocale]];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        [dateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        NSDate *date = [dateFormat dateFromString: module.startedOn];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  date]; // Get necessary date components
 
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        
       
        [cell.lblDate setText: [NSString stringWithFormat:@"%@ %d",monthName,components.day]];
        
        [cell.lblModuleName setText: module.moduleName];
        [cell.progressBarModule setProgress:[module.completedPercentStatus floatValue]* stepSize animated:YES  ];
        if ([module.completedPercentStatus floatValue]==100.00) {
            cell.progressBarModule.progressTintColor=[UIColor greenColor];
        }
        [cell.lblPercent  setText: [NSString stringWithFormat:@"%@ %s" ,module.completedPercentStatus,"%"]];
        return cell;
        
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {

    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[moduleArray objectAtIndex:currentExpandedIndex] count];

    if (isChild) {
    NSLog(@"A child was tapped, do what you will with it");
    return;
    }

    [tableViewCourse beginUpdates];
    
    if (currentExpandedIndex == indexPath.row) {
        [self collapseSubItemsAtIndex:currentExpandedIndex];
        currentExpandedIndex = -1;
    }
else {
    
    BOOL shouldCollapse = currentExpandedIndex > -1;
    
    if (shouldCollapse) {
        [self collapseSubItemsAtIndex:currentExpandedIndex];
    }
    
    currentExpandedIndex = (shouldCollapse && indexPath.row > currentExpandedIndex) ? indexPath.row - [[moduleArray objectAtIndex:currentExpandedIndex] count] : indexPath.row;
    
    [self expandItemAtIndex:currentExpandedIndex];
}

[tableViewCourse endUpdates];

}

- (void)expandItemAtIndex:(int)index {
    
    NSMutableArray *indexPaths = [NSMutableArray new];
//    [indexPaths addObject:[NSIndexPath indexPathForRow:currentExpandedIndex++ inSection:0]];
//    [tableViewCourse deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    [tableViewCourse insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

    
    NSArray *currentSubItems = [moduleArray objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [currentSubItems count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [tableViewCourse insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableViewCourse scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
   
   }

- (void)collapseSubItemsAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = index + 1; i <= index + [[moduleArray objectAtIndex:index] count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [tableViewCourse deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"You are in: %s", __FUNCTION__);
//    if (indexPath.row % 2 == 0) //if the row is odd number row
//    {
//        cell.backgroundColor = [UIColor blackColor];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    }
//    else
//    {
//        cell.backgroundColor = [UIColor blackColor];
//    }
}

@end
