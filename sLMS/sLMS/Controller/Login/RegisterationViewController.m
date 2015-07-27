//
//  RegisterationViewController.m
//  sLMS
//
//  Created by Mayank on 09/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "RegisterationViewController.h"
#import "CustomKeyboard.h"
#import "UserDetail.h"
#import "FeedViewController.h"

@interface RegisterationViewController () <CustomKeyboardDelegate>
{
    //keyboard
    CustomKeyboard *customKeyboard;
    UITextField *activeTextField;
    int             mIntRow;
    NSMutableArray *arrayAllData;
    NSMutableArray *arraySchools;
    NSMutableArray *arrayClass;
    NSMutableArray *arrayHome;
    AppDropdownType selectedPicker;
    NSString *selectedSchoolId,*selectedClassId,*selectedRoomId;
    NSString *selectedSchoolName,*selectedClassName,*selectedRoomName;
    NSString *selectedTitle;
    
}

@end

@implementation RegisterationViewController
@synthesize txtPassword,txtAdminEmail,txtCnfPwd,txtEmail,txtFirstName,txtLastName,mDataPickerView,mViewAccountTypePicker,btnClass,btnFacebook,btnHome,btnSchool,btnTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //init the keyboard
    if([AppGlobal getValueInDefault:key_UserId ]!=nil)
    {
        FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    customKeyboard = [[CustomKeyboard alloc] init];
    customKeyboard.delegate = self;
    [self toggleHiddenState:YES];
    // self.lblLoginStatus.text = @"";
    
    self.btnFacebook.delegate = self;
    self.btnFacebook.readPermissions = @[@"public_profile", @"email"];
    [self changeFrameAndBackgroundImg];
    selectedTitle=@"Mr.";
    [self fetchedMasterData];
    // set default  title
//    NSDictionary
//   [ btnTitle  setTitle: forState:UIControlStateNormal];
   
    // set
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
#pragma mark - Login Action
- (IBAction)btnBcakClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnSubmitClick:(id)sender {
    UserDetail *usrDetail= [[UserDetail alloc]init];
    
   usrDetail.userEmail=[[txtEmail text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
   usrDetail.userPassword=[[txtPassword text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *cnfpassword=[[txtCnfPwd text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    usrDetail.userFirstName=txtFirstName.text;
    usrDetail.userLastName=txtLastName.text;
    usrDetail.title=selectedTitle;
    usrDetail.schoolName=selectedSchoolName;
    usrDetail.schoolId=selectedSchoolId;
    usrDetail.classId   =selectedClassId;
    usrDetail.className=selectedClassName;
    usrDetail.homeRoomName=selectedRoomName;
    usrDetail.homeRoomId=selectedRoomId;
    usrDetail.adminEmailId=txtAdminEmail.text;
    
   
    if ([usrDetail.userFirstName length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_FIRST_NAME title:@""];
    }
    else if ([usrDetail.userLastName length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_LAST_NAME title:@""];
    }else if ([usrDetail.userEmail length] <= 0) {
        [AppGlobal showAlertWithMessage:MISSING_EMAIL_ID title:@""];
    }else if ([usrDetail.userPassword length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_PASSWORD title:@""];
    }
    else if(![self isPasswordValid:usrDetail.userPassword])
    {
        
    }
    else if ([cnfpassword length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_CNF_PASSWORD title:@""];
    }
    else if (![cnfpassword isEqualToString:usrDetail.userPassword]){
        [AppGlobal showAlertWithMessage:MISSING_CNF_PASSWORD_NOT_MATCH title:@""];
    }
        else if ([usrDetail.schoolName length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_SCHOOL title:@""];
    }
    else if ([usrDetail.adminEmailId length] <= 0){
            [AppGlobal showAlertWithMessage:MISSING_ADMIN_EMAIL title:@""];
    }
    else if ([usrDetail.className length] <= 0){
            [AppGlobal showAlertWithMessage:MISSING_CLASS title:@""];
    
    }
    else if ([usrDetail.homeRoomName length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_HOME title:@""];
    }
   
    
    else{
        [activeTextField resignFirstResponder];
        //Show Indicator
        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
        
        [[appDelegate _engine] registerWithUserDetail:usrDetail  success:^(UserDetail *userDetail) {
                                             
            [AppGlobal setValueInDefault:key_UserId value:userDetail.userId];
            [AppGlobal setValueInDefault:key_UserName value:userDetail.userFirstName];
            [AppGlobal setValueInDefault:key_UserEmail value:userDetail.userEmail];
                                             //Hide Indicator
                                             [appDelegate hideSpinner];
            //navigate to feed view Controller
            
            FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
                                         }
                                         failure:^(NSError *error) {
                                             //Hide Indicator
                                             [appDelegate hideSpinner];
                                             NSLog(@"failure Json Data %@",[error description]);
                                             [self registerationError:error];
                                             
                                         }];
    }

}
-(void)fetchedMasterData{
    
    
    
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getMasterData:^(BOOL success) {
        //Hide Indicator
        [appDelegate hideSpinner];
        arraySchools=[AppGlobal getDropdownList:SCHOOL_DATA];
    } failure:^(NSError *error) {
        //Hide Indicator
        [appDelegate hideSpinner];
        NSLog(@"failure JsonData %@",[error description]);
    }];
    // if user valid then navigate to main screen.
    
    //    self.profilePicture.profileID = user.id;
    //    self.lblUsername.text = user.name;
    //    self.lblEmail.text = [user objectForKey:@"email"];
}
-(void)registerationError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}
- (IBAction)btnTitleClick:(id)sender {
    selectedPicker=TITLE_DATA;
    arrayAllData=[AppGlobal getDropdownList:TITLE_DATA];
    [mDataPickerView reloadAllComponents];
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
    [self allTxtFieldsResignFirstResponder];
}

- (IBAction)btnSignInClick:(id)sender {
    LoginViewController *loginViewController= [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
 
}

- (IBAction)btnSchoolClick:(id)sender {
    selectedPicker=SCHOOL_DATA;
    
    
    [mDataPickerView reloadAllComponents];
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
     [self allTxtFieldsResignFirstResponder];
    [btnClass setTitle:@"" forState:UIControlStateNormal];
    [btnHome   setTitle:@"" forState:UIControlStateNormal];
    selectedClassId=nil;
    selectedClassName=nil;
    selectedRoomId=nil;
    selectedRoomName=nil;
}

- (IBAction)btnClassClick:(id)sender {
    selectedPicker=CLASS_DATA;
   // arrayAllData=[AppGlobal getDropdownList:CLASS_DATA];
     [mDataPickerView reloadAllComponents];
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
     [self allTxtFieldsResignFirstResponder];
    [btnHome   setTitle:@"" forState:UIControlStateNormal];
  
    selectedRoomId=nil;
    selectedRoomName=nil;
}

- (IBAction)btnHomeClick:(id)sender {
    selectedPicker=ROOM_DATA;
  //  arrayAllData=[AppGlobal getDropdownList:ROOM_DATA];
     [mDataPickerView reloadAllComponents];
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
     [self allTxtFieldsResignFirstResponder];
}

#pragma mark - Private method implementation
-(void)changeFrameAndBackgroundImg
{
    
    //  _btnFacebook.frame = CGRectMake(0, _btnFacebook.frame.origin.y+14, _btnFacebook.frame.size.width, 120);
    //  _btnFacebook.frame = CGRectMake(320/2 - 93/2, self.view.frame.size.height -200, 93, 40);
    for (id loginObject in btnFacebook.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  loginObject;
            UIImage *loginImage = [UIImage imageNamed:@"fb_login_blue.png"];
            // loginButton.alpha = 0.7;
            [loginButton setBackgroundColor:[UIColor colorWithRed:186.0 green:0.0 blue:50.0 alpha:0.0]];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            //CGSize constraint = CGSizeMake(400, 220);
            // [loginButton sizeThatFits:constraint];
            //[loginButton sizeToFit];
        }
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  loginObject;
            loginLabel.text = @"";
            loginLabel.frame = CGRectMake(0, 0, 0, 0);
        }
    }
}
-(void)toggleHiddenState:(BOOL)shouldHide{
    //    self.lblUsername.hidden = shouldHide;
    //    self.lblEmail.hidden = shouldHide;
    //    self.profilePicture.hidden = shouldHide;
}


#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged in.";
    
    [self toggleHiddenState:NO];
    [self changeFrameAndBackgroundImg];
}


-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    NSLog(@"%@", user);
    //if user is already sign in Then validate with server.
    
    // get user id
    NSString *userid=[NSString  stringWithFormat:@"%@",[user objectForKey:@"id"]];
    
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] FBloginWithUserID:userid success:^(UserDetail *userDetail) {
        [AppGlobal setValueInDefault:key_UserId value:userDetail.userId];
        [AppGlobal setValueInDefault:key_UserName value:userDetail.userFirstName];
        [AppGlobal setValueInDefault:key_UserEmail value:userDetail.userEmail];
        [self loginSucessFullWithFB];
        
        //Hide Indicator
        [appDelegate hideSpinner];
    }
                                     failure:^(NSError *error) {
                                         //Hide Indicator
                                         [appDelegate hideSpinner];
                                         NSLog(@"failure JsonData %@",[error description]);
                                         [self loginViewShowingLoggedOutUser:loginView];

                                         [self loginError:error];
                                         
                                     }];
    
    
    // if user valid then navigate to main screen.
    
    //    self.profilePicture.profileID = user.id;
    //    self.lblUsername.text = user.name;
    //    self.lblEmail.text = [user objectForKey:@"email"];
}

-(void)loginSucessFullWithFB{
    // if FB Varification is done then navigate the main screen
    
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged out";
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [self toggleHiddenState:YES];
}

-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}

#pragma --
#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([txtAdminEmail isEqual:textField]){
        [self setPositionOfLoginBaseViewWhenStartEditing:-150];
        
    }
    
    activeTextField = textField;
    
    UIToolbar* toolbar;
    if (textField.tag == 10) {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:FALSE :TRUE];
        
    }
    else if (textField.tag == 15)
    {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:TRUE :FALSE];
        
    }else {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:TRUE :TRUE];
    }
    [textField setInputAccessoryView:toolbar];
    
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setPositionOfLoginBaseViewWhenEndEditing];
    [textField resignFirstResponder];
   
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}
#pragma --
#pragma mark -- Manage View Position

-(void)setPositionOfLoginBaseViewWhenStartEditing:(CGFloat)yAxis{
    
    if (self.view.frame.origin.y != yAxis) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        [AppGlobal setViewPositionWithView:self.view axisX:self.view.frame.origin.x axisY:yAxis withAnimation:YES];
    }
}

-(void)setPositionOfLoginBaseViewWhenEndEditing{
    [AppGlobal setViewPositionWithView:self.view axisX:self.view.frame.origin.x axisY:0.0 withAnimation:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)onKeyboardHide:(NSNotification *)notification{
    //Get size keyboard for manage self your views.
    [self setPositionOfLoginBaseViewWhenEndEditing];
    [self allTxtFieldsResignFirstResponder];
}

-(void)allTxtFieldsResignFirstResponder{
    
    [txtAdminEmail resignFirstResponder];
    [txtCnfPwd resignFirstResponder];
    [txtEmail   resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtLastName  resignFirstResponder];
    [txtPassword resignFirstResponder];
    
}

#pragma mark Custom Keyboard Delegate

- (void)nextClicked:(NSUInteger)selectedId
{
    NSInteger nextTag = activeTextField.tag + 1;
    
    UITextField *nextResponder = (UITextField*)[self.view viewWithTag:nextTag];
    
    if (!nextResponder.enabled) {
        nextResponder = (UITextField*)[self.view  viewWithTag:nextTag+1];
    }
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        //Not found, so remove keyboard.
        [nextResponder resignFirstResponder];
    }
}
- (void)previousClicked:(NSUInteger)selectedId
{
    NSInteger nextTag = activeTextField.tag -1;
    
    UITextField *nextResponder = (UITextField*) [self.view  viewWithTag:nextTag];
    
    while(!nextResponder.enabled)
    {
        nextResponder = (UITextField*)[self.view  viewWithTag:nextTag-1];
    }
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [nextResponder resignFirstResponder];
        
    }
    
}
- (void)doneClicked:(NSUInteger)selectedId
{
    
    
    [activeTextField resignFirstResponder];
    
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)componen
{    switch(selectedPicker) {
    case SCHOOL_DATA:
    {
     return  [arraySchools count];
    }break;
    case CLASS_DATA:
    {
      return [arrayClass count];
       
    }break;
    case ROOM_DATA:
    {
       return [arrayHome count];
       
    }break;
    case TITLE_DATA:
    {
       return [arrayAllData count];
        
    }break;
    case COURSE_DATA:
    {
        return [arrayAllData count];
        
    }break;
        
    default:
        [NSException raise:NSGenericException format:@"Unexpected FormatType."];
        
}
    
    
   
}

-(BOOL) isPasswordValid:(NSString *)pwd {
    if ( [pwd length]<8 || [pwd length]>15 ){
          [AppGlobal showAlertWithMessage:MISSING_PASSWORD_LENGTH title:@""];
        return NO;
        
    
    }  // too long or too short
    NSRange rang;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length ) {
        [AppGlobal showAlertWithMessage:MISSING_PASSWORD_CHAR title:@""];
        return NO;
        
        
    }  //   no letter

    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length ) {
        [AppGlobal showAlertWithMessage:MISSING_PASSWORD_NUMBER title:@""];
        return NO;
        
        
    }  // no number;
    return YES;
}
#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    mIntRow=row;
    [pickerView selectRow:row inComponent:component animated:NO];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
        switch(selectedPicker) {
        case SCHOOL_DATA:
            {
                NSDictionary *responseDic = [ arraySchools objectAtIndex:row];
                
                return [responseDic objectForKey:@"schoolName"];
                

                break;
            }
        case CLASS_DATA:
            {
                NSDictionary *responseDic = [ arrayClass objectAtIndex:row];
               return [responseDic objectForKey:@"className"];
                
                break;
            }
        case ROOM_DATA:
            {
                NSDictionary *responseDic = [ arrayHome objectAtIndex:row];
                return [responseDic objectForKey:@"homeRoomName"];
                
                break;
            }
            case TITLE_DATA:
            {
                NSDictionary *responseDic = [ arrayAllData objectAtIndex:row];
                return [responseDic objectForKey:@"Title"];
                break;
            }
            case COURSE_DATA:
            {
                NSDictionary *responseDic = [ arrayAllData objectAtIndex:row];
                return [responseDic objectForKey:@"Title"];
                break;
            }

        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
}
- (IBAction)mBtnCancelPicker:(id)sender {
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:NO];
    
}

- (IBAction)mBtnDonePicker:(id)sender {
    
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:NO];
     switch(selectedPicker) {
        case SCHOOL_DATA:
        {
            NSDictionary *responseDic = [ arraySchools objectAtIndex:mIntRow];
            arrayClass=  [responseDic objectForKey:@"classList"];
            selectedSchoolId=  [responseDic objectForKey:@"schoolId"];
            selectedSchoolName=  [responseDic objectForKey:@"schoolName"];
            [btnSchool setTitle:selectedSchoolName forState:UIControlStateNormal];
           //[responseDic objectForKey:@"SchoolName"];
            
            break;
        }
        case CLASS_DATA:
        {
            NSDictionary *responseDic = [ arrayClass objectAtIndex:mIntRow];
            arrayHome=  [responseDic objectForKey:@"homeRoomList"];
            selectedClassId=  [responseDic objectForKey:@"classId"];
            selectedClassName=  [responseDic objectForKey:@"className"];
           //[responseDic objectForKey:@"ClassName"];
            [btnClass setTitle:selectedClassName forState:UIControlStateNormal];

            break;
        }
        case ROOM_DATA:
        {
            NSDictionary *responseDic = [ arrayHome objectAtIndex:mIntRow];
            selectedRoomId=  [responseDic objectForKey:@"homeRoomId"];
            selectedRoomName=  [responseDic objectForKey:@"homeRoomName"];
            // [responseDic objectForKey:@"HoomRoom"];
            [btnHome setTitle:selectedRoomName forState:UIControlStateNormal];

            break;
        }
        case TITLE_DATA:
        {
            NSDictionary *responseDic = [ arrayAllData objectAtIndex:mIntRow];
            selectedTitle= [responseDic objectForKey:@"Title"];
             [btnTitle setTitle:selectedTitle forState:UIControlStateNormal];
            break;
        }
            
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
}

@end
