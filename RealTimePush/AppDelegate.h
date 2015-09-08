//
//  AppDelegate.h
//  RealTimePush
//
//  Created by Ashish Agarwal on 2015-09-06.
//  Copyright (c) 2015 AshishAgarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong) NSString *deviceUUID;


@end

