//
//  ModuleDetailViewController.m
//  sLMS
//
//  Created by Mayank on 20/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ModuleDetailViewController.h"
#import "CustomContentView.h"
#import "ContentCellTableViewCell.h"
#import "AssignmentTableViewCell.h"
#import "CommentTableViewCell.h"
#import "AppEngine.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VedioPlayViewController.h"
@interface ModuleDetailViewController ()
{
    NSMutableArray *contentList;
    NSMutableArray *assignmentList;
    Resourse *selectedResource;
    BOOL IsCommentExpended;
    BOOL IsAsignmentExpended;
    BOOL IsRelatedConentExpended;
    CGRect frame;
    ActionOn    actionOn;
    NSString    *selectedResourceId,*selectedCommentId;
    NSString    *searchText;
   
}


@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSArray *pageImages;
//somewhere in the header
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGFloat lastContentOffsetOfTable;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation ModuleDetailViewController
@synthesize btnAssignment,btnCourses,btnMore,btnNotification,btnUpdates,txtSearchBar,scollViewContainer;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageViews = _pageViews;
@synthesize pageImages = _pageImages;
@synthesize step,title,txtViewCMT;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set up the image we want to scroll & zoom and add it to the scroll view
    
    
    // Set up the array to hold the views for each page
   
  self.scrollView.clipsToBounds=NO;
      [self getModuleDetail:@""];
    
    CGRect frame1 = self.cmtview.frame;
    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
     frame=frame1;
    self.cmtview.frame=frame1;
    [self.view addSubview:self.cmtview];
    btnCourses.selected=YES;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    step=0;
    self.lastContentOffsetOfTable=tblViewContent.contentOffset.y;;
    searchText=@"";
}


-(void)viewDidDisappear:(BOOL)animated
{
    /* remove for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillShowNotification object:nil];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillHideNotification object:nil];
 
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - table cell Action

- (IBAction)btnMoreCommentClick:(id)sender {
    IsCommentExpended=YES;
    IsRelatedConentExpended=NO;
    IsAsignmentExpended=NO;
    [tblViewContent reloadData];
    
}
- (IBAction)btnMoreRelatedVideoClick:(id)sender {
    IsRelatedConentExpended=YES;
    IsCommentExpended=NO;
    IsAsignmentExpended=NO;
    [tblViewContent reloadData];
}
- (IBAction)btnMoreAssignmentClick:(id)sender {
    IsAsignmentExpended=YES;
    IsRelatedConentExpended=NO;
    IsCommentExpended=NO;
    [tblViewContent reloadData];
   
}
#pragma mark - Comment and like on Resource
- (IBAction)btnPlayResourceClick:(id)sender {
   
//    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"big-buck-bunny-clip" ofType:@"m4v"];
    
//    NSURL    *fileURL    =   [NSURL  fileURLWithPath:selectedResource.resourceUrl];
//    MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlaybackComplete:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:moviePlayerController];
//    
//    [self.view addSubview:moviePlayerController.view];
//    moviePlayerController.fullscreen = YES;
//    [moviePlayerController play];
    VedioPlayViewController *vedioView= [[VedioPlayViewController alloc]init];
    vedioView.filePath=selectedResource.resourceUrl;
    [self.navigationController pushViewController:vedioView animated:YES];
}
- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    
    [moviePlayerController.view removeFromSuperview];
   
}
- (IBAction)btnCommentOnResourceClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    selectedResourceId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    actionOn=Resource;
    [txtViewCMT becomeFirstResponder];
    

}
- (IBAction)btnLikeOnResourceClick:(id)sender {
    // call the service
    UIButton *btn=(UIButton *)sender;
    selectedResourceId=[NSString stringWithFormat:@"%ld", (long)btn.tag];

        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
        [[appDelegate _engine] setLikeOnResource:selectedResourceId  success:^(BOOL success) {
    
    
           

            //Hide Indicator
            [appDelegate hideSpinner];
            [self getModuleDetail:searchText];
        }
                                            failure:^(NSError *error) {
                                                //Hide Indicator
                                                [appDelegate hideSpinner];
                                                NSLog(@"failure JsonData %@",[error description]);
                                                 [self loginError:error];
                                                
    
                                            }];
}
- (IBAction)btnShareOnResourceClick:(id)sender {
}
#pragma mark - Reply and like on Comment

- (IBAction)btnReplyOnCommentClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    selectedCommentId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    actionOn=Comment;
    [txtViewCMT becomeFirstResponder];

}
- (IBAction)btnLikeOnCommentClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    selectedCommentId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] setLikeOnComment:selectedCommentId success:^(BOOL success) {
       //Hide Indicator
        
        [appDelegate hideSpinner];
           [self getModuleDetail:searchText];
    }
                                     failure:^(NSError *error) {
                                         //Hide Indicator
                                         [appDelegate hideSpinner];
                                         NSLog(@"failure JsonData %@",[error description]);
                                      
                                         [self loginError:error];
                                     }];

}

#pragma mark - tab bar Action
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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

- (IBAction)btnCommentDone:(id)sender {
    [txtViewCMT resignFirstResponder];
    step=0;
    // call the service
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    if (actionOn==Resource) {
        [[appDelegate _engine] setCommentOnResource:selectedResourceId AndCommentText:txtViewCMT.text success:^(BOOL success) {
            
            
            // [self loginSucessFullWithFB];
            
            //Hide Indicator
            [appDelegate hideSpinner];
            
            [self getModuleDetail:searchText];
        }
                                            failure:^(NSError *error) {
                                                //Hide Indicator
                                                [appDelegate hideSpinner];
                                                NSLog(@"failure JsonData %@",[error description]);
                                                [self loginError:error];
                                                
                                            }];

    }else{
        [[appDelegate _engine] setCommentOnComment:selectedCommentId AndCommentText:txtViewCMT.text success:^(BOOL success) {
            
            
            // [self loginSucessFullWithFB];
            
            //Hide Indicator
            [appDelegate hideSpinner];
        }
                                            failure:^(NSError *error) {
                                                //Hide Indicator
                                                [appDelegate hideSpinner];
                                                NSLog(@"failure JsonData %@",[error description]);
                                                [self loginError:error];
                                                
                                            }];

    }
    txtViewCMT.text=@"";
    CGRect frame1 = self.cmtview.frame;
    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    frame=frame1;
   
}

- (IBAction)btnCommentCancle:(id)sender {
     [txtViewCMT resignFirstResponder];
    txtViewCMT.text=@"";
    CGRect frame1 = self.cmtview.frame;
    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    frame=frame1;

    step=0;
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
    searchText=searchBar.text;
  [self getModuleDetail:searchBar.text];
    // [self searchTableList];
}
#pragma mark Course Private functions
-(void) getModuleDetail:(NSString *) txtSearch
{
    NSString *userid=[NSString  stringWithFormat:@"%@",[AppSingleton sharedInstance ].userDetail.userId];
   // userid=@"1";
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
        self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * [contentList count], pagesScrollViewSize.height+10);
        
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
                                   [self loginError:error];
                                   //                                         [self loginViewShowingLoggedOutUser:loginView];
                                   
                               }];
    
    
}
-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
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
    self.lastContentOffset = self.scrollView.contentOffset.y;
    [self.scollViewContainer bringSubviewToFront: self.scrollView];
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
        frame = CGRectInset(frame, 5.0f, 0.0f);
        Resourse *resource=[contentList objectAtIndex:page];
        CustomContentView *customView= [[CustomContentView alloc]init];
        customView.lblAutherName.text=resource.authorName;
        NSDate *dateSatrtedOn = [AppGlobal convertStringDateToNSDate:resource.startedOn];
        NSDate *dateCompletedOn = [AppGlobal convertStringDateToNSDate:resource.completedOn];
        if(dateSatrtedOn!=nil)
        {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  dateSatrtedOn]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        resource.startedOn=[NSString stringWithFormat:@"%@ %d,%d",monthName,components.day,components.year];
        
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  dateCompletedOn]; // Get necessary date components
        monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        resource.completedOn=[NSString stringWithFormat:@"%@ %d,%d",monthName,components.day,components.year];
        }
        customView.lblStartedon.text=resource.startedOn;
        customView.lblCompletedon.text=resource.completedOn;
        [customView.btnLike setTitle:resource.likeCounts forState:UIControlStateNormal];
       // [customView.btnShare    setTitle:resource.shareCounts forState:UIControlStateNormal];
        [customView.btnComment setTitle:resource.commentCounts forState:UIControlStateNormal];
        [customView.imgContent setImage:[AppGlobal generateThumbnail:resource.resourceUrl]];
       
        [customView.btnComment addTarget:self action:@selector(btnCommentOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [customView.btnLike addTarget:self action:@selector(btnLikeOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        customView.btnComment.tag=[resource.resourceId integerValue];
        customView.btnLike.tag=[resource.resourceId integerValue];
        // add vedio play
        selectedResource=resource;
        [customView.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];

        // set comment for the content
        // check if comment is available
        if([resource.comments  count]>0)
        {
            Comments *objComment=[resource.comments objectAtIndex:0];
            [customView.imgViewCmtBy setImage:[AppGlobal generateThumbnail:resource.resourceUrl]];
//            NSURL *imageURL = [NSURL URLWithString:objComment.commentByImage];
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // Update the UI
//                    customView.imgViewCmtBy.image = [UIImage imageWithData:imageData];
//                });
//            });
        
            customView.lblCmtBy.text=  objComment.commentBy;
            customView.lblCmtTime.text= objComment.commentDate;
            [customView.btnLikeCMT setTitle:objComment.likeCounts forState:UIControlStateNormal];
           // [customView.btnShareCMT    setTitle:objComment.shareCounts forState:UIControlStateNormal];
            [customView.btnCommentCMT setTitle:objComment.commentCounts forState:UIControlStateNormal];
            customView.txtCmtView.text= objComment.commentDate;
           
            customView.btnCommentCMT.tag=[objComment.commentId integerValue];
            customView.btnLike.tag=[objComment.commentId integerValue];
            
            //set action for reply and like on comment
       
            [customView.btnCommentCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            [customView.btnLikeCMT addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [customView.imgViewCmtBy setHidden:YES];
            //[customView.imgViewCmtBy setImage:[UIImage imageWithData:[NSData ns] ]];
           [ customView.lblCmtBy setHidden:YES];
            [customView.lblCmtTime setHidden:YES];
            [customView.btnLikeCMT setHidden:YES];
         //   [customView.btnShareCMT   setHidden:YES];
            [customView.btnCommentCMT setHidden:YES];
            [customView.txtCmtView setHidden:YES];
        }
        
        customView.clipsToBounds=YES    ;
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
    
    ScrollDirection scrollDirection;
    if( scrollView.tag==20){
    if (self.lastContentOffset > self.scrollView.contentOffset.y+5)
    {
        scrollDirection = ScrollDirectionDown;

    
    self.lastContentOffset = scrollView.contentOffset.y;
    
    // get current page;
    NSInteger currentpage=  self.pageControl.currentPage;
    // get the current Content
   selectedResource=[contentList objectAtIndex:currentpage];
       // CATransition *animation = [CATransition animation];
//        animation.type = kCATransitionFade;
//        animation.duration = 0.0;
//        [scrollView.layer addAnimation:animation forKey:nil];
//        
//        scrollView.hidden = YES;
        [UIView transitionWithView:scrollView
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        self.scrollView.hidden=YES;
        [tblViewContent reloadData];
        tblViewContent.hidden =NO;
        //button.layer.shouldRasterize = YES;
    }else {
     self.lastContentOffset = scrollView.contentOffset.y;
    
    }
    }else if( scrollView.tag==10){
            if (self.lastContentOffsetOfTable <-50)
            {
                scrollDirection = ScrollDirectionDown;
                
                
                self.lastContentOffsetOfTable = scrollView.contentOffset.y;
                
                [UIView transitionWithView:scrollView
                                  duration:0.4
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:NULL
                                completion:NULL];
                 self.scrollView.hidden=NO;
               // [tblViewContent reloadData];
                
                tblViewContent.hidden =YES;
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
                self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * [contentList count], pagesScrollViewSize.height+10);
                [self loadVisiblePages];
                //button.layer.shouldRasterize = YES;
            }else {
                self.lastContentOffsetOfTable = scrollView.contentOffset.y;
                
            }
        }
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(selectedResource==nil)
        return 0;
    if(section==0)
        return 1;
    else if(section==1 && IsCommentExpended)
    {
        return [selectedResource.comments count];
    }
    else if(section==1 && !IsCommentExpended)
   {
       if ([selectedResource.comments count]>3) {
           return 3;
       }else{
        return [selectedResource.comments count];
       }
   }
   else if(section==2 && IsRelatedConentExpended)
   {
       return [selectedResource.relatedResources count];
   }
   else if(section==2 && !IsRelatedConentExpended)
   {
       if ([selectedResource.relatedResources count]>3) {
           return 3;
       }else{
           return [selectedResource.relatedResources count];
       }
   }
   else if(section==3 && IsAsignmentExpended)
   {
       return [assignmentList count];
   }
   else if(section==3 && !IsAsignmentExpended)
   {
       if ([assignmentList count]>3) {
           return 3;
       }else{
           return [assignmentList count];
       }
   }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//#import "ContentCellTableViewCell.h"
//#import "AssignmentTableViewCell.h"
//#import "CommentTableViewCell.h"
    
    if(indexPath.section==0)
    {
        static NSString *identifier = @"ContentCellTableViewCell";
        ContentCellTableViewCell *cell = (ContentCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }

        cell.lblAutherName.text=selectedResource.authorName;
        
//        NSDate *dateSatrtedOn = [AppGlobal convertStringDateToNSDate:selectedResource.startedOn];
//        NSDate *dateCompletedOn = [AppGlobal convertStringDateToNSDate:selectedResource.completedOn];
//
//        NSCalendar* calendar = [NSCalendar currentCalendar];
//        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  dateSatrtedOn]; // Get necessary date components
//        
//        
//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
//        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
//        selectedResource.startedOn=[NSString stringWithFormat:@"%@ %d,%d",monthName,components.day,components.year];
        cell.lblStartedon.text=selectedResource.startedOn;
       
        
//        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  dateCompletedOn]; // Get necessary date components
//        monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
//        selectedResource.completedOn=[NSString stringWithFormat:@"%@ %d,%d",monthName,components.day,components.year];
       cell.lblCompletedon.text=selectedResource.completedOn;
        
        [cell.btnLike setTitle:selectedResource.likeCounts forState:UIControlStateNormal];
        cell.btnComment.tag=[selectedResource.resourceId integerValue];
        cell.btnLike.tag=[selectedResource.resourceId integerValue];
        cell.btnShare.tag=[selectedResource.resourceId integerValue];
//set action for comment and like on resource
        [cell.btnComment addTarget:self action:@selector(btnCommentOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLike addTarget:self action:@selector(btnLikeOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShare addTarget:self action:@selector(btnShareOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        
       // [cell.btnShare    setTitle:selectedResource.shareCounts forState:UIControlStateNormal];
        [cell.btnComment setTitle:selectedResource.commentCounts forState:UIControlStateNormal];
      //  [cell.imgContent setImage:[AppGlobal generateThumbnail:selectedResource.resourceUrl]];
        
        return cell;
    }else if(indexPath.section==1){
        static NSString *identifier = @"CommentTableViewCell";
        CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Comments *comment= [selectedResource.comments objectAtIndex:indexPath.row];
        
        //[cell.imgCMT setImage:[AppGlobal generateThumbnail:comment.commentByImage]];
        cell.lblCmtBy.text= comment.commentBy;
        cell.lblCmtDate.text=comment.commentDate;
        cell.lblCmtText.text=comment.commentTxt;
//        if(indexPath.row/2==0){
//            cell.lblCmtText.text=@"nxlsjldjfldksjflkdsjfl";
//        }
        [cell.btnLike setTitle:comment.likeCounts forState:UIControlStateNormal];
        [cell.btnCMT setTitle:comment.commentCounts forState:UIControlStateNormal];
      
        cell.btnCMT.tag=[comment.commentId integerValue];
        cell.btnLike.tag=[selectedResource.resourceId integerValue];
       
        //set action for reply and like on comment
        [cell.btnCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLike addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnMore.hidden=YES;
        cell.imgDevider.hidden=YES;
        cell.lblRelatedVideo.hidden =YES;
        
        if(([selectedResource.comments count]<3) && (indexPath.row==[selectedResource.comments count]-1))
        {
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=NO;
            cell.lblRelatedVideo.hidden =NO;
            
        }
        else if([selectedResource.comments count]>=3)
        {
            if(IsCommentExpended && (indexPath.row==[selectedResource.comments count]-1))
            {
                [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%u More",[selectedResource.comments count ]-3]  forState:UIControlStateNormal];
                cell.btnMore.hidden=NO;
                cell.imgDevider.hidden=NO;
                cell.lblRelatedVideo.hidden =NO;
            }else if(indexPath.row==2 && !IsCommentExpended){
                [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%u More",[selectedResource.comments count ]-3]  forState:UIControlStateNormal];
                cell.btnMore.hidden=NO;
                cell.imgDevider.hidden=NO;
                cell.lblRelatedVideo.hidden =NO;
            }
            
        }
        return cell;
        
    }
    else if(indexPath.section==2){
        static NSString *identifier = @"AssignmentTableViewCell";
        AssignmentTableViewCell *cell = (AssignmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Resourse *resource= [selectedResource.relatedResources objectAtIndex:indexPath.row];
        
       // [cell.imgContentURL setImage:[AppGlobal generateThumbnail:resource.resourceUrl]];
        cell.lblContentName.text= resource.resourceDesc;
        cell.lblContentby.text=resource.authorName;
       // cell.lblSubmittedDate.text=resource.uploadedDate;
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:resource.uploadedDate];
        if(submittedDate!=nil){
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        resource.uploadedDate=[NSString stringWithFormat:@"%@ %d",monthName,components.day];
        }
        
        cell.lblSubmittedDate.text=[NSString stringWithFormat:@"Uploaded on %@",resource.uploadedDate ];
        if(indexPath.row!=([selectedResource.relatedResources count]-1))
        {
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=YES;
             cell.lblAssignment.hidden=YES;
        }else{
            if([selectedResource.relatedResources count]>=3)
            {
                [cell.btnMore addTarget:self action:@selector(btnMoreRelatedVideoClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%u More",[selectedResource.relatedResources count ]-3]  forState:UIControlStateNormal];
            }else{
                cell.btnMore.hidden=YES;
            }
        }

        return cell;
        
    }
    else{
        static NSString *identifier = @"AssignmentTableViewCell";
        AssignmentTableViewCell *cell = (AssignmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Assignment *assignment= [assignmentList objectAtIndex:indexPath.row];
        Resourse *resource=assignment.attachedResource;
       // [cell.imgContentURL setImage:[AppGlobal generateThumbnail:resource.resourceUrl]];
        cell.lblContentName.text= assignment.assignmentName;
        cell.lblContentby.text=assignment.assignmentSubmittedBy;
        
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:assignment.assignmentSubmittedDate];
       if(submittedDate!=nil){
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
      assignment.assignmentSubmittedDate=[NSString stringWithFormat:@"%@ %d",monthName,components.day];
       }
        
        cell.lblSubmittedDate.text=[NSString stringWithFormat:@"Submitted on %@",assignment.assignmentSubmittedDate ];
        if(indexPath.row!=([assignmentList count]-1))
        {
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=YES;
            cell.lblAssignment.hidden=YES;
        }else{
            if([assignmentList count]>3)
            {
                [cell.btnMore addTarget:self action:@selector(btnMoreRelatedVideoClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%lu More",[assignmentList count ]-3]  forState:UIControlStateNormal];
            }else{
                cell.btnMore.hidden=YES;
            }
        }
        return cell;
    }

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

//- (void)expandItemAtIndex:(int)index {
//    
//    NSMutableArray *indexPaths = [NSMutableArray new];
//    //    [indexPaths addObject:[NSIndexPath indexPathForRow:currentExpandedIndex++ inSection:0]];
//    //    [tableViewCourse deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    //    [tableViewCourse insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    
//    
//    NSArray *currentSubItems = [moduleArray objectAtIndex:index];
//    int insertPos = index + 1;
//    for (int i = 0; i < [currentSubItems count]; i++) {
//        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
//    }
//    [tableViewCourse insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    [tableViewCourse scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    
//}
//
//- (void)collapseSubItemsAtIndex:(int)index {
//    NSMutableArray *indexPaths = [NSMutableArray new];
//    for (int i = index + 1; i <= index + [[moduleArray objectAtIndex:index] count]; i++) {
//        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//    }
//    [tableViewCourse deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedResource==nil)
        return 0;
    if(indexPath.section==0)
        return 460.0f;
    else if(indexPath.section==1 && selectedResource.comments>0)
    {
        Comments *cmt=selectedResource.comments[indexPath.row];
        CGSize labelSize=[AppGlobal getTheExpectedSizeOfLabel:cmt.commentTxt];
        float height=0.0f;
        NSLog(@"%d",indexPath.row);
        if(([selectedResource.comments count]<3) && (indexPath.row==[selectedResource.comments count]-1))
        {
           height=80.0f;
                
           
            
        }
        else if([selectedResource.comments count]>=3)
        {
            if(IsCommentExpended && (indexPath.row==[selectedResource.comments count]-1))
            {
                 height=80.0f;
            }else if(indexPath.row==2 && !IsCommentExpended){
             height=80.0f;
            }
            
        }
        
        if(labelSize.height>39)
                return   height=height+80+labelSize.height;
            else
                return  height=height+80;
    }
    else if(indexPath.section==2 )
    {
        float height=0.0f;
        if(indexPath.row==([selectedResource.relatedResources count]-1))
        {
            height=75.0f;
        }else if(([selectedResource.relatedResources count]-1==3 )&& indexPath.row==2)
        {
            height=75.0f;
            
        }
       
        return  height=height+96.0f;
    
    }
    
    else if(indexPath.section==3)
    {
//        
        float height=0.0f;
//        if(indexPath.row==([assignmentList count]-1))
//        {
//            height=40.0f;
//        }
        
        return  height=height+96.0f;

    }
    return 44.0f;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    NSLog(@"You are in: %s", __FUNCTION__);
//    //    if (indexPath.row % 2 == 0) //if the row is odd number row
//    //    {
//    //        cell.backgroundColor = [UIColor blackColor];
//    //        cell.textLabel.textColor = [UIColor whiteColor];
//    //    }
//    //    else
//    //    {
//    //        cell.backgroundColor = [UIColor blackColor];
//    //    }
//}
#pragma mark - Keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    //    CGRect frame1 = self.cmtview.frame;
    //    frame1=CGRectMake(0, 400, 320, 40);
    //
    //    self.cmtview.frame=frame1;
    /* Move the toolbar to above the keyboard */
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.0];
    CGRect frame1 = self.cmtview.frame;
    frame1.size.width=keyboardFrameBeginRect.size.width;
    frame1.origin.y = self.view.frame.size.height- (keyboardFrameBeginRect.size.height+39);
    //     frame1.origin.y = self.view.frame.size.height -310;
    //  frame1.origin.y = self.view.frame.size.height -258;
    self.cmtview.frame = frame1;
     frame=frame1;
    [self.view bringSubviewToFront: self.cmtview];
    //271-
    
    //  [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // [keyboardToolbar setItems:cmtview animated:YES];
    /* Move the toolbar back to bottom of the screen */
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.3];
        CGRect frame1 = self.cmtview.frame;
        frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
        self.cmtview.frame = frame1;
     frame=frame1;
    //
    //    [UIView commitAnimations];
}
#pragma uitextview deligate and datasource
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //txtview.inputAccessoryView=commentView;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // CGRect frameRect;
    NSString *str=textView.text;
    
    //    NSUInteger count = 0,
    NSUInteger length = [str length];
    
    NSRange range1= [str rangeOfString:@"\n" options:NSBackwardsSearch];
    if((range1.length+range1.location==length)&&[text isEqualToString:@""])
    {
        frame=CGRectMake(frame.origin.x, frame.origin.y+30, frame.size.width, frame.size.height-30);
        
        step=step-1;
    }
    
    if([text isEqualToString:@"\n"]&& step<2)
    {
        frame=CGRectMake(frame.origin.x, frame.origin.y-30, frame.size.width, frame.size.height+30);
        
        step=step+1;
        
    }
    //    CGRect frame1 = frame;
    //    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    
    self.cmtview.frame=frame;
    
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

@end
