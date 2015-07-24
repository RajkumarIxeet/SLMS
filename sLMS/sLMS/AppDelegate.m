//
//  AppDelegate.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "AppDelegate.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FeedViewController.h"
#import "CourseViewController.h"

@interface AppDelegate (){
    UIView *spinnerView;
    UIActivityIndicatorView *activityIndicator;
    UILabel *activityLabel;
}

@end

@implementation AppDelegate

@synthesize _engine;
@synthesize _homeViewController,_navHomeViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Allocate Engine
    _engine=[[AppEngine alloc] init];
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds ];
    self._homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    


    
    self._navHomeViewController = [[UINavigationController alloc] initWithRootViewController:self._homeViewController];
    [self._navHomeViewController.navigationBar setHidden:YES];
   
    
    UIViewController *feedview = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    UIViewController *courseView = [[CourseViewController alloc] initWithNibName:@"CourseViewController" bundle:nil];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:feedview,courseView, nil];
   // self.window.rootViewController = self.tabBarController;
   // [self._navHomeViewController.tabBarController setHidesBottomBarWhenPushed:YES    ];
    self.window.rootViewController = self._navHomeViewController;
    [self.window makeKeyAndVisible];
    [FBLoginView class];
    [FBProfilePictureView class];

//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                    didFinishLaunchingWithOptions:launchOptions];
   return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
     //[FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation];
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ixeet.sLMS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sLMS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"sLMS.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark - show & hide busy Indicator

// This method simply shows a loading spinner on a blank canvas,
- (void)showSpinnerWithMessage:(NSString*)msg{
    
    // Add spinner
    if (spinnerView == nil) {
        spinnerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        spinnerView.backgroundColor = [UIColor clearColor];
        
        UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingBG.png"]];
        img.frame=CGRectMake((spinnerView.frame.size.width - 164)/2,(spinnerView.frame.size.height - 114)/2, 164, 114);
        [spinnerView addSubview:img];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((spinnerView.frame.size.width - 30)/2, img.frame.origin.y + 25 , 30, 30)];
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [spinnerView addSubview:activityIndicator];
        
        activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, activityIndicator.frame.origin.y + 40, spinnerView.frame.size.width - 20, 50)];
        activityLabel.textAlignment = NSTextAlignmentCenter;
        activityLabel.textColor = [UIColor whiteColor];
        activityLabel.numberOfLines = 0;
        activityLabel.backgroundColor = [UIColor clearColor];
        [spinnerView addSubview:activityLabel];
    }
    
    activityLabel.text = msg;
    if (![spinnerView superview]) {
        [self.window addSubview:spinnerView];
    }
    
    [activityIndicator startAnimating];
    
}

- (void)hideSpinner {
    
    [spinnerView removeFromSuperview];
    [activityIndicator stopAnimating];
    
}


@end
