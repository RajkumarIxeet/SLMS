//
//  ModuleDetailViewController.m
//  sLMS
//
//  Created by Mayank on 20/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ModuleDetailViewController.h"
#import "CustomContentView.h"
@interface ModuleDetailViewController ()
{
    NSMutableArray *contentList;
    NSMutableArray *assignmentList;
   
}

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSArray *pageImages;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation ModuleDetailViewController
@synthesize btnAssignment,btnCourses,btnMore,btnNotification,btnUpdates,txtSearchBar;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageViews = _pageViews;
@synthesize pageImages = _pageImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set up the image we want to scroll & zoom and add it to the scroll view
    
    
    // Set up the array to hold the views for each page
    Courses *course=[[Courses alloc]init];
    course.courseId=@"1";
    self.selectedCourse=course;

    Module *module=[[Module alloc]init];
    module.moduleId=@"1";
    self.selectedModule=module;
    [self getModuleDetail:@""];

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
   // [self getModuleDetail:searchBar.text];
    // [self searchTableList];
}
#pragma mark Course Private functions
-(void) getModuleDetail:(NSString *) txtSearch
{
    NSString *userid=[NSString  stringWithFormat:@"%@",[AppGlobal getValueInDefault:key_UserId]];
    userid=@"1";
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getModuleDetail:userid AndTextSearch:txtSearch AndSelectModule:self.selectedModule AndSelectCourse:self.selectedCourse success:^(NSDictionary *moduleDetail) {
     
        contentList=[moduleDetail objectForKey:@"resourceList"];
        assignmentList=[moduleDetail objectForKey:@"assignmentList"];
        NSInteger pageCount = [contentList count];
        
        // Set up the page control
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = pageCount;
        // Set up the content size of the scroll view
        // Set up the array to hold the views for each page
        self.pageViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < pageCount; ++i) {
            [self.pageViews addObject:[NSNull null]];
        }
        CGSize pagesScrollViewSize = self.scrollView.frame.size;
        self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * [contentList count], pagesScrollViewSize.height);
        
        // Load the initial set of pages that are on screen
        [self loadVisiblePages];
      //  [tblViewContent reloadData];
      
        
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

#pragma mark -

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i< [contentList count]; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= [contentList count]) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    // set here custom view
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 10.0f, 0.0f);
        Resourse *resource=[contentList objectAtIndex:page];
        CustomContentView *customView= [[CustomContentView alloc]init];
        customView.lblAutherName.text=resource.authorName;
        customView.lblStartedon.text=resource.startedOn;
        customView.lblCompletedon.text=resource.completedOn;
        [customView.btnLike setTitle:resource.likeCounts forState:UIControlStateNormal];
        [customView.btnShare    setTitle:resource.shareCounts forState:UIControlStateNormal];
        [customView.btnComment setTitle:resource.commentCounts forState:UIControlStateNormal];
        [customView.imgContent setImage:[AppGlobal generateThumbnail:resource.resourceUrl]];

        
        
        
        customView.contentMode = UIViewContentModeScaleAspectFit;
        customView.frame = frame;
        [self.scrollView addSubview:customView];
        [self.pageViews replaceObjectAtIndex:page withObject:customView];
    }
    
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= [contentList count]) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

@end
