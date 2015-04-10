//
//  RSSReaderDataCode.m
//  RSSReaderExample
//
//  Created by Alexander Vlasov on 10.04.15.
//  Copyright (c) 2015 Alexander Vlasov. All rights reserved.
//

#import "RSSReaderDataCode.h"
#import "RSSFeed.h"
#import "RSSFeedPost.h"

@implementation RSSReaderDataCode

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.willecome.RSSReaderExample" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RSSReaderExample" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RSSReaderExample.sqlite"];
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

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static RSSReaderDataCode *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(NSArray*)entitiesForName:(NSString *)name{
    if (name.length!=0){
        NSManagedObjectContext *context = [[RSSReaderDataCode sharedInstance] managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:name   inManagedObjectContext:context];
        [request setEntity:entity];
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        if (error){
            NSLog(@"Error fetching entities: %@\n%@", [error localizedDescription], [error userInfo]);
            return nil;
        }
        return results;
    }
    return nil;
}

-(NSArray*)postForFeedWithObjectID:(NSManagedObjectID *)objectID{
    if ((objectID!=nil)){
        NSManagedObjectContext *context = [[RSSReaderDataCode sharedInstance] managedObjectContext];
        RSSFeed *feed = (RSSFeed *)[context objectRegisteredForID:objectID];
            if (feed!=nil){
                NSArray *results = [[feed posts] array];
                return results;
            }
    }
    return nil;
}

-(BOOL)createFeedWithName:(NSString *)name URL:(NSString *)url{
    BOOL success = NO;
    if ((name.length!=0) && (url.length!=0)){
        NSManagedObjectContext *context = [[RSSReaderDataCode sharedInstance] managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RSSFeed" inManagedObjectContext:context];
        RSSFeed *newFeed = [[RSSFeed alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        newFeed.name = name;
        newFeed.link = url;
        newFeed.orderID = [RSSReaderDataCode nextAvailble:@"orderID" forEntityName:@"RSSFeed" inContext:context];
        [[RSSReaderDataCode sharedInstance] saveContext];
        success=YES;
    }
    return success;
}

-(BOOL)updateFeedWithObjectID:(NSManagedObjectID*)objectID ToName:(NSString *)name URL:(NSString *)url{
    BOOL success = NO;
    if ((name.length!=0) && (url.length!=0) && (objectID!=nil)){
        NSManagedObjectContext *context = [[RSSReaderDataCode sharedInstance] managedObjectContext];
        RSSFeed *feed = (RSSFeed *)[context objectRegisteredForID:objectID];
        if (feed!=nil){
            feed.name = name;
            feed.link = url;
//            [context refreshObject:feed mergeChanges:YES];
            [[RSSReaderDataCode sharedInstance] saveContext];
            success=YES;
        }
    }
    return success;
}

-(BOOL)removeFeedWithObjectID:(NSManagedObjectID*)objectID{
    BOOL success = NO;
    if ((objectID!=nil)){
        NSManagedObjectContext *context = [[RSSReaderDataCode sharedInstance] managedObjectContext];
        RSSFeed *feed = (RSSFeed *)[context objectRegisteredForID:objectID];
        if (feed!=nil){
            [context deleteObject:feed];
            [[RSSReaderDataCode sharedInstance] saveContext];
            success=YES;
        }
    }
    return success;
}

-(BOOL)createPostWithTitle:(NSString *)title Summary:(NSString *)summary Content:(NSString *)content Link:(NSString *)link ForFeedObjectID:(NSManagedObjectID *)objectID {
    BOOL success = NO;
    if ((title.length!=0) && (objectID != nil)){
        NSManagedObjectContext *context = [[RSSReaderDataCode sharedInstance] managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RSSFeedPost" inManagedObjectContext:context];
        RSSFeedPost *newPost = [[RSSFeedPost alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        newPost.title = title;
        newPost.link = link;
        newPost.summary = summary;
        newPost.content = content;
        newPost.feed = (RSSFeed *)[context objectWithID:objectID];
        newPost.orderID = [RSSReaderDataCode nextAvailble:@"orderID" forEntityName:@"RSSFeedPost" inContext:context];
        [[RSSReaderDataCode sharedInstance] saveContext];
        success=YES;
    }
    return success;
}

-(BOOL)updatePostWithObjectID:(NSManagedObjectID*)objectID ToTitle:(NSString *)title Summary:(NSString *)summary Content:(NSString *)content Link:(NSString *)link{
    BOOL success = NO;
    if ((title.length!=0) && (objectID != nil)){
        NSManagedObjectContext *context = [[RSSReaderDataCode sharedInstance] managedObjectContext];
        RSSFeedPost *post = (RSSFeedPost *)[context objectRegisteredForID:objectID];
        if (post!=nil){
            post.title = title;
            post.link = link;
            post.summary = summary;
            post.content = content;
//            [context refreshObject:post mergeChanges:YES];
            [[RSSReaderDataCode sharedInstance] saveContext];
            success=YES;
        }
    }
    return success;
}

-(BOOL)removePostWithObjectID:(NSManagedObjectID*)objectID{
    BOOL success = NO;
    if ((objectID!=nil)){
        NSManagedObjectContext *context = [[RSSReaderDataCode sharedInstance] managedObjectContext];
        RSSFeedPost *feed = (RSSFeedPost *)[context objectRegisteredForID:objectID];
        if (feed!=nil){
//            [context refreshObject:feed mergeChanges:YES];
            [context deleteObject:feed];
            [[RSSReaderDataCode sharedInstance] saveContext];
            success=YES;
        }
    }
    return success;
}

+(NSNumber *)nextAvailble:(NSString *)idKey forEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *moc = context;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    [request setEntity:entity];
    // [request setFetchLimit:1];
    
    NSArray *propertiesArray = [[NSArray alloc] initWithObjects:idKey, nil];
    [request setPropertiesToFetch:propertiesArray];
    
    NSSortDescriptor *indexSort = [[NSSortDescriptor alloc] initWithKey:idKey ascending:YES];
    NSArray *array = [[NSArray alloc] initWithObjects:indexSort, nil];
    [request setSortDescriptors:array];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    // NSSLog(@"Autoincrement fetch results: %@", results);
    NSManagedObject *maxIndexedObject = [results lastObject];
    if (error) {
        NSLog(@"Error fetching index: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    //NSAssert3(error == nil, @"Error fetching index: %@\n%@", [error localizedDescription], [error userInfo]);
    
    NSInteger myIndex = 1;
    if (maxIndexedObject) {
        myIndex = [[maxIndexedObject valueForKey:idKey] integerValue] + 1;
    }
    
    return [NSNumber numberWithInteger:myIndex];
}

@end
