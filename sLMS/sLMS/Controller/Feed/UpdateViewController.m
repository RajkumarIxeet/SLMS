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
#import "CommentTableViewCell.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "ModuleDetailViewController.h"
#import "CourseViewController.h"
@interface UpdateViewController ()
{
    NSMutableArray *arrayUpdates;
    BOOL isSearching;
    CGRect txtframe;
    NSString    *searchText;
    NSString *selectedCommentId,*selectedUpdateId;
    ActionOn  actionOn;
}

@end

@implementation UpdateViewController
@synthesize txtSearchBar,tblViewContent;
@synthesize step,txtViewCMT,objCustom;

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

        // Custom initialization
        [self setSearchUI];
    objCustom = [[CustomProfileView alloc] init];
    NSLog(@"%f,%f",self.view.frame.size.height,self.view.frame.size.width);
    objCustom.center = CGPointMake(200, 400);
    CGRect frame1=objCustom.view.frame ;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    frame1.size.height=screenHeight-50;
    frame1.size.width=screenWidth;//200;
    objCustom.view.frame=frame1;
   
    [objCustom.btnLogout  addTarget:self action:@selector(btnLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
    CGRect cmtFrame = self.cmtview.frame;
    cmtFrame=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    txtframe=cmtFrame;
    self.cmtview.frame=cmtFrame;
    [self.view addSubview:self.cmtview];
}
-(void)dismissKeyboard {
    [txtSearchBar resignFirstResponder];
    [txtViewCMT resignFirstResponder];
    isSearching=NO;
    txtViewCMT.text=@"";
    step=0;
    
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

- (void)viewWillAppear:(BOOL)animated{
    // [super viewWillAppear:animated];
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [objCustom.view addGestureRecognizer:recognizer];
    NSLog(@"%d", [AppSingleton sharedInstance].isUserLoggedIn);
    
    
    //set Profile
    [objCustom setUserProfile];
    
 [self  getUpdate:@""];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    /* remove for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillHideNotification object:nil];
    
}
//-(void)setUserProfile {
//    // UserDetails *user=[AppGlobal readUserDetail];
//    UserDetails *user=[AppSingleton sharedInstance].userDetail;
//    
//    
//    objCustom.lblName.text=user.userFirstName;
//    objCustom.lblSchoolName.text=user.schoolName;
//    
//    objCustom.lblClass.text=user.className;
//    objCustom.lblHome.text=user.homeRoomName;
//    if(user.userFBID==nil)
//    {
//        //need to validate
//        objCustom.btnFacebook.hidden=NO;
//    }else{
//        //FB allready validated
//        objCustom.btnFacebook.hidden=YES;
//    }
//}
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

#pragma mark Update Private functions
-(void) getUpdate:(NSString *) txtSearch
{
    
    NSString *userid=[NSString  stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId];
   if([userid isEqualToString:@"(null)"])
       return ;
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getUpdates:userid  AndTextSearch:txtSearch success:^(NSMutableArray *updates) {
        arrayUpdates=updates;
      
        
        [tblViewContent reloadData];
        // [self loginSucessFullWithFB];
        
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
    return [arrayUpdates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount=0;
    Update *update=arrayUpdates[section];
    
    if(update.isExpend)
    {
        rowCount=[update.comments count]+1;
    }else{
        if([update.comments count]<3)
        {
            rowCount=[update.comments count]+1;
        }
        else{
            rowCount=3;
        }
        

    }
    return rowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"section= %ld row of section=%ld",indexPath.section,indexPath.row);
    if(indexPath.row==0)
    {
    static NSString *identifier = @"UpdateTableViewCell";
        UpdateTableViewCell *cell = (UpdateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Update *update=[arrayUpdates objectAtIndex:indexPath.section];
        
        // create custom view for title
        NSString *titleString =update.updateTitle;
        NSArray *titleWords = [titleString componentsSeparatedByString:@"$"];
        float x,y;
        x=0.0f;
        y=0.0f;
        int textIndex=0;
        for (NSString *strtemp in titleWords) {
            UILabel *lbltitle=[[UILabel alloc]init];
            [lbltitle setTextColor:[UIColor darkGrayColor]];
            NSString *strtrim = [strtemp stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
             lbltitle.text=strtrim;
            [lbltitle setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
            CGSize textSize = [[lbltitle text] sizeWithAttributes:@{NSFontAttributeName:[lbltitle font]}];
            
            CGFloat strikeWidth = textSize.width;
            lbltitle.frame=CGRectMake(x, y, strikeWidth, 30);
            if (x>150&& y==0) {
                y=y+25;
                x=0;
            }
           
            [cell.viewDetail addSubview:lbltitle];
            if([titleWords count]-1!=textIndex)
            {
                 x=x+strikeWidth;
                UIButton *btnAction=[[UIButton alloc]init];
                
                NSDictionary *dictext= update.updateTitleArray[textIndex];
                btnAction.tag =(int) update.updateId;
                NSString *strtrim = [[dictext objectForKey:@"value"] stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceCharacterSet]];
              
                [btnAction setTitle:strtrim forState:UIControlStateNormal];
                [btnAction setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                [btnAction.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
                textSize = [[lbltitle text] sizeWithAttributes:@{NSFontAttributeName:[lbltitle font]}];
                strikeWidth = textSize.width;
                
                if([[dictext objectForKey:@"type"] isEqualToString:@"user"])
                {
                    btnAction.tag =(int) [dictext objectForKey:@"key"];
                    [btnAction addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else  if([[dictext objectForKey:@"type"] isEqualToString:@"course"])
                {
                   [btnAction addTarget:self action:@selector(btnCourseDetailClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else  if([[dictext objectForKey:@"type"] isEqualToString:@"module"])
                {
                     [btnAction addTarget:self action:@selector(btnModuleDetailClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                else  if([[dictext objectForKey:@"type"] isEqualToString:@"resource"])
                {
                    [btnAction addTarget:self action:@selector(btnResourceDetailClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                btnAction.frame=CGRectMake(x, y, strikeWidth, 30);
                textIndex=textIndex+1;
                [cell.viewDetail addSubview:btnAction];
                 x=x+strikeWidth;
            }
            if (x>150 && y==0) {
                y=y+25;
                x=0;
            }
        }
      //  cell.viewDetail.frame=CGRectMake(0, 0, x, 60);
        if(update.updateDesc!=nil)
        {
            cell.txtviewDetail.text=update.updateDesc;
            
        }else{
            [cell.txtviewDetail  setHidden:YES];

        }
         [cell.btnPlay setHidden:YES];
        if (update.resource!=nil) {
            
            if(update.resource.resourceImageUrl!=nil){
                [cell.btnPlay setHidden:NO];
                [cell.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];
                if (update.resource.resourceImageData==nil) {
                    NSURL *imageURL = [NSURL URLWithString:update.resource.resourceImageUrl];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        update.resource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            UIImage *img=[UIImage imageWithData:update.resource.resourceImageData];
                            if(img!=nil)
                            {
                                [cell.imgResorces setImage:img];
                                
                                [cell.imgResorces setBackgroundColor:[UIColor clearColor]];
                            }
                        });
                    });
                }else{
                    UIImage *img=[UIImage imageWithData:update.resource.resourceImageData];
                    [cell.imgResorces setImage:img];
                    
                    [cell.imgResorces setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
       
        if(update.updateCreatedByImage!=nil){
            [cell.btnUpdatedBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];

            
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
    
        
        if([update.isLike  isEqualToString:@"1"])
        {
            cell.btnLike.selected=YES;
            [cell.btnLike setTitle:update.likeCount forState:UIControlStateSelected];
        }else
            
        {
            cell.btnLike.selected=NO;
            [cell.btnLike setTitle:update.likeCount forState:UIControlStateNormal];
        }
        [cell.btnComment setTitle:update.commentCount forState:UIControlStateNormal];
       
        cell.lblUpdateBy.text=update.updateCreatedBy;
        cell.btnComment.tag=[update.updateId integerValue];
        cell.btnLike.tag=[update.updateId  integerValue];
        cell.btnShare.tag=[update.updateId  integerValue];
        //set action for comment and like on resource
        [cell.btnComment addTarget:self action:@selector(btnCommentOnUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLike addTarget:self action:@selector(btnLikeOnUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShare addTarget:self action:@selector(btnShareOnUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
       if(update.likeCount==nil)
       {
            [cell.btnLike setHidden:YES];
            [cell.btnComment setHidden:YES];
            [cell.btnShare setHidden:YES];
       }
        
        return cell;
    }
   else{
        static NSString *identifier = @"CommentTableViewCell";
        CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Update *update=[arrayUpdates objectAtIndex:indexPath.section];
        Comments *comment= [update.comments objectAtIndex:indexPath.row-1];
        
        //[cell.imgCMT setImage:[AppGlobal generateThumbnail:comment.commentByImage]];
        cell.lblCmtBy.text= comment.commentBy;
        cell.lblCmtDate.text=comment.commentDate;
        cell.lblCmtText.text=comment.commentTxt;
      
       cell.lblRelatedVideo.hidden=YES;
        if(comment.commentByImage!=nil){
            if(comment.commentByImageData==nil)
            {
                
                NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    comment.commentByImageData=imageData;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        UIImage *img=[UIImage imageWithData:imageData];
                        if(img!=nil)
                            [cell.btnCommentedBy setImage:img forState:UIControlStateNormal];
                        
                    });
                });
            }else{
                [cell.btnCommentedBy setImage:[UIImage imageWithData:comment.commentByImageData] forState:UIControlStateNormal];
            }
        }
         if([comment.isLike  isEqualToString:@"1"])
        {
            cell.btnLike.selected=YES;
            [cell.btnLike setTitle:comment.likeCounts forState:UIControlStateSelected];
        }else
            
        {
            cell.btnLike.selected=NO;
            [cell.btnLike setTitle:comment.likeCounts forState:UIControlStateNormal];
        }
        
        [cell.btnCMT setTitle:comment.commentCounts forState:UIControlStateNormal];
        
        cell.btnCMT.tag=[comment.commentId integerValue];
        cell.btnLike.tag=[comment.commentId integerValue];
        
        //set action for reply and like on comment
        [cell.btnCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLike addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnMore.hidden=YES;
        cell.imgDevider.hidden=YES;
       
        if(([update.comments count]<3) && (indexPath.row==[update.comments count]))
        {
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=NO;
           
            
        }
        else if([update.comments count]>=3)
        {
            if(update.isExpend && (indexPath.row==[update.comments count]))
            {
                [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[update.comments count ]-3]  forState:UIControlStateNormal];
                cell.btnMore.hidden=YES;
                cell.imgDevider.hidden=NO;
               
            }else if(indexPath.row==3 && !update.isExpend){
                [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[update.comments count ]-3]  forState:UIControlStateNormal];
                cell.btnMore.hidden=NO;
                cell.imgDevider.hidden=NO;
               
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([arrayUpdates count]==0)
    return 0;
    Update *update=arrayUpdates[indexPath.section];
    if(indexPath.row==0)
    {
        float height=0.0f;
        if(update.resource!=nil)
        {
        
            height=163.0f;
        }
        return height=height+140;
    }
    else if(update.comments>0)
    {
        Comments *cmt=update.comments[indexPath.row-1];
        CGSize labelSize=[AppGlobal getTheExpectedSizeOfLabel:cmt.commentTxt];
        float height=0.0f;
        NSLog(@"%ld",(long)indexPath.row);
        if(([update.comments count]<3) && (indexPath.row==[update.comments count]))
        {
            height=40.0f;
        }
        else if([update.comments count]>=3)
        {
            if(update.isExpend && (indexPath.row==[update.comments count]))
            {
                height=40.0f;
            }else if(indexPath.row==2 && !update.isExpend){
                height=40.0f;
            }
            
        }
    if(labelSize.height>39)
            return   height=height+80+labelSize.height;
        else
            return  height=height+80;
    }
    
    
    return 0.0;
    

}
#pragma mark - table cell Action

- (IBAction)btnResourceDetailClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    // call the Resource detail service
    
//    ProfileViewController *profileView=[[ProfileViewController alloc]init];
//    profileView.userid=[NSString stringWithFormat:@"%ld", btn.tag];
//    [self.navigationController pushViewController:profileView animated:YES];
}
- (IBAction)btnCourseDetailClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    // call the Course Detail Service
    
//    CourseViewController *courseView=[[CourseViewController alloc]init];
//    [self.navigationController pushViewController:courseView animated:YES];
}

- (IBAction)btnModuleDetailClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
      // call the Module Detail Service
    
//    ModuleDetailViewController *moduleView=[[ModuleDetailViewController alloc]init];
//  //  profileView.userid=[NSString stringWithFormat:@"%ld", btn.tag];
//    [self.navigationController pushViewController:moduleView animated:YES];
}
- (IBAction)btnUserProfileClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    // call the user profile service user profile
    
    ProfileViewController *profileView=[[ProfileViewController alloc]init];
    profileView.userid=[NSString stringWithFormat:@"%ld", btn.tag];
    [self.navigationController pushViewController:profileView animated:YES];
}
- (IBAction)btnMoreCommentClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    Update *update=[arrayUpdates objectAtIndex:btn.tag];
    update.isExpend=YES;
    [tblViewContent reloadData];
    
}
#pragma mark - Comment and like on Update

- (IBAction)btnPlayResourceClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    Update *update=[arrayUpdates objectAtIndex:btn.tag];
    Resourse *resourse =update.resource;
    [self PlayTheVideo:resourse.resourceUrl];
    
}

-(void)PlayTheVideo:(NSString *)stringUrl
{
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    self.moviePlayer =  [[MPMoviePlayerController alloc]initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object: self.moviePlayer];
    
    self.moviePlayer.controlStyle = MPMovieControlStyleDefault;
    self.moviePlayer.shouldAutoplay = YES;
    [ self.moviePlayer prepareToPlay];
    [self.view addSubview: self.moviePlayer.view];
    [ self.moviePlayer setFullscreen:YES animated:YES];
    [ self.moviePlayer stop];
    [ self.moviePlayer play];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    
    
}
- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    
    [moviePlayerController.view removeFromSuperview];
    
}
- (void) moviePlayerWillEnterFullscreenNotification:(NSNotification*)notification {
    [appDelegate self].allowRotation = YES;
}
- (void) moviePlayerWillExitFullscreenNotification:(NSNotification*)notification {
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [appDelegate self].allowRotation = NO;
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:moviePlayerController];
    [self.moviePlayer stop];
    //[self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer=nil;
    
}
- (IBAction)btnCommentOnUpdateClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
  //  NSInteger currentpage=  self.pageControl.currentPage;
    // get the current Content
    Update *update=[arrayUpdates objectAtIndex:btn.tag];
    selectedUpdateId=update.updateId;
 
    actionOn=UpdateOn;
    [txtViewCMT becomeFirstResponder];
    
    
}
- (IBAction)btnLikeOnUpdateClick:(id)sender {
    // call the service
    UIButton *btn=(UIButton *)sender;
    // get the current Content
   Update *update=[arrayUpdates objectAtIndex:btn.tag];
   
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] setLikeOnResource:update.updateId  success:^(BOOL success) {
        
        
        
        
        //Hide Indicator
        [appDelegate hideSpinner];
        //[self getUpdate:searchText];
    }
                                     failure:^(NSError *error) {
                                         //Hide Indicator
                                         [appDelegate hideSpinner];
                                         NSLog(@"failure JsonData %@",[error description]);
                                         [self loginError:error];
                                         
                                         
                                     }];
}
- (IBAction)btnShareOnUpdateClick:(id)sender {
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
       [self  getUpdate:txtSearchBar.text];
    }
                                    failure:^(NSError *error) {
                                        //Hide Indicator
                                        [appDelegate hideSpinner];
                                        NSLog(@"failure JsonData %@",[error description]);
                                        
                                        [self loginError:error];
                                    }];
    
}

- (IBAction)btnCommentDone:(id)sender {
    [txtViewCMT resignFirstResponder];
    step=0;
    // call the service
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    if (actionOn==UpdateOn) {
        [[appDelegate _engine] setCommentOnResource:selectedUpdateId AndCommentText:txtViewCMT.text success:^(BOOL success) {
            
            
            // [self loginSucessFullWithFB];
            
            //Hide Indicator
            [appDelegate hideSpinner];
            
           [self  getUpdate:txtSearchBar.text];
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
             [self  getUpdate:txtSearchBar.text];
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
    txtframe=frame1;
    
}

- (IBAction)btnCommentCancle:(id)sender {
    [txtViewCMT resignFirstResponder];
    txtViewCMT.text=@"";
    CGRect frame1 = self.cmtview.frame;
    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    txtframe=frame1;
    
    step=0;
}

- (IBAction)btnProfileClick:(id)sender {
    [self fadeInAnimation:self.view];
}


#pragma mark -  UITextView deligate and datasource

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
    if((range1.length+range1.location==length)&&[text isEqualToString:@""]&& step>0)
    {
        txtframe=CGRectMake(txtframe.origin.x, txtframe.origin.y+30, txtframe.size.width, txtframe.size.height-30);
        
        step=step-1;
    }
    
    if([text isEqualToString:@"\n"]&& step<2)
    {
        txtframe=CGRectMake(txtframe.origin.x, txtframe.origin.y-30, txtframe.size.width, txtframe.size.height+30);
        
        step=step+1;
        
    }
    //    CGRect frame1 = frame;
    //    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    
    self.cmtview.frame=txtframe;
    
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
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
    if(!isSearching)
    {
        CGRect frame1 = self.cmtview.frame;
        frame1.size.width=keyboardFrameBeginRect.size.width;
        frame1.origin.y = self.view.frame.size.height- (keyboardFrameBeginRect.size.height+39);
        //     frame1.origin.y = self.view.frame.size.height -310;
        //  frame1.origin.y = self.view.frame.size.height -258;
        self.cmtview.frame = frame1;
        txtframe=frame1;
        [self.view bringSubviewToFront: self.cmtview];
        //271-
    }
    //  [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // [keyboardToolbar setItems:cmtview animated:YES];
    /* Move the toolbar back to bottom of the screen */
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.3];
    if(!isSearching)
    {
        CGRect frame1 = self.cmtview.frame;
        frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
        self.cmtview.frame = frame1;
        txtframe=frame1;
    }
    //
    //    [UIView commitAnimations];
}
#pragma mark - UISearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [txtViewCMT resignFirstResponder];
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //  NSLog(@"Text change - %d");
    
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
    isSearching=NO;
    [self  getUpdate:txtSearchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    searchText=searchBar.text;
    [self  getUpdate:txtSearchBar.text];
    [searchBar resignFirstResponder];
    isSearching=NO;
}
-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}


-(void)fadeInAnimation:(UIView *)aView {
    
    
    [CATransaction begin];
    CATransition *animation = [CATransition animation];
    // [self.view addSubview:objCustom.view];
    [animation setDuration:0.5];
    
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[self.view layer] addAnimation:animation forKey:nil];
    
    [self.view addSubview:objCustom.view];
    [CATransaction commit];
}


//code for gesture


-(void)fadeInAnimation1:(UIView *)aView {
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [CATransaction setCompletionBlock:^{
    }];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[self.view layer] addAnimation:animation forKey:nil];
    
    
}
- (void)swipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    [self fadeInAnimation1:self.view];
    [objCustom.view removeFromSuperview];
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        // [self.view removeFromSuperview];
        // self.objCustom.view.hidden = NO;
        
        
    }
}
- (IBAction)btnLogoutClick:(id)sender {
    if(  [AppSingleton sharedInstance].isUserFBLoggedIn==YES)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
 
    }
    [AppSingleton sharedInstance].isUserFBLoggedIn=NO;
    [AppSingleton sharedInstance].isUserLoggedIn=NO;
    [self.tabBarController.tabBar setHidden:YES];
    LoginViewController *viewCont= [[LoginViewController alloc]init];
    [self.navigationController pushViewController:viewCont animated:YES];
    
}



@end
