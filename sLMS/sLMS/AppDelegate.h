//
//  AppDelegate.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class AppEngine;
@class HomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeViewController *_homeViewController;
@property (strong, nonatomic) UINavigationController *_navHomeViewController;

@property (nonatomic, strong) AppEngine *_engine;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UITabBarController *tabBarController;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - show & hide busy Indicator
- (void)showSpinnerWithMessage:(NSString*)msg;
- (void)hideSpinner;

@end



