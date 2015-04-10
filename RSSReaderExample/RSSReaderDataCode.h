//
//  RSSReaderDataCode.h
//  RSSReaderExample
//
//  Created by Alexander Vlasov on 10.04.15.
//  Copyright (c) 2015 Alexander Vlasov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RSSReaderDataCode : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (instancetype)sharedInstance;

-(NSArray*)entitiesForName:(NSString *)name;
-(BOOL)createFeedWithName:(NSString *)name URL:(NSString *)url;
-(BOOL)updateFeedWithObjectID:(NSManagedObjectID*)objectID ToName:(NSString *)name URL:(NSString *)url;
-(BOOL)removeFeedWithObjectID:(NSManagedObjectID*)objectID;

-(NSArray*)postForFeedWithObjectID:(NSManagedObjectID *)objectID;
-(BOOL)createPostWithTitle:(NSString *)title Summary:(NSString *)summary Content:(NSString *)content Link:(NSString *)link ForFeedObjectID:(NSManagedObjectID *)objectID;
-(BOOL)updatePostWithObjectID:(NSManagedObjectID*)objectID ToTitle:(NSString *)title Summary:(NSString *)summary Content:(NSString *)content Link:(NSString *)link;
-(BOOL)removePostWithObjectID:(NSManagedObjectID*)objectID;


@end
