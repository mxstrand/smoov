//
//  MXSMessages.m
//  cyrano
//
//  Created by Michael Strand on 10/18/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMessages.h"
#import "MXSMessage.h"
#import "MXSMessageCategory.h"
#import <Parse/Parse.h>
#import "Flurry.h"

static NSString * const kMXSMessagesCacheFileName = @"MXSMessagesCacheFile";

@interface MXSMessages ()

@property (nonatomic, strong) NSMutableDictionary *messages;
@property (nonatomic, strong) dispatch_queue_t messagesAccessQueue;

@end

@implementation MXSMessages

- (void)messagesInCategory:(MXSMessageCategory *)category completion:(void (^)(NSArray *))completion
{
    dispatch_async(self.messagesAccessQueue, ^{
        if (!self.messages[category.key]) {
            NSArray *messagesInCategory = [self loadMessagesFromCacheInCategory:category];
            if (messagesInCategory) {
                self.messages[category.key] = messagesInCategory;
            }
        }
        
        if (!self.messages[category.key]) {
            NSArray *messagesInCategory = [self loadMessagesInCategory:category];
            if (messagesInCategory) {
                self.messages[category.key] = messagesInCategory;
                [self saveMessagesInCache:messagesInCategory inCategory:category];
            }
        }
        
        completion([self.messages[category.key] copy]);
    });
}

- (dispatch_queue_t)messagesAccessQueue
{
    if (!_messagesAccessQueue) {
        _messagesAccessQueue = dispatch_queue_create("com.smoov.messagesAccessQueue", DISPATCH_QUEUE_SERIAL);
        // using a serial dispatch queue to ensure messagesInCategory method runs one request at a time.
    }
    return _messagesAccessQueue;
}

- (void)saveMessagesInCache:(NSArray *)messagesInCategory inCategory:(MXSMessageCategory *)category
{
    NSString *archiveFilePath = [self archiveFilePathForCategory:category];
    [NSKeyedArchiver archiveRootObject:messagesInCategory toFile:archiveFilePath];
}

- (NSArray *)loadMessagesFromCacheInCategory:(MXSMessageCategory *)category;
{
    NSString *archiveFilePath = [self archiveFilePathForCategory:category];
    NSArray *messagesInCategory = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveFilePath];
    return messagesInCategory;
}

- (NSString *)archiveFilePathForCategory:(MXSMessageCategory *)category
{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *archiveDirectory = [libraryPath stringByAppendingPathComponent:@"UserData"];
    BOOL isDirectory = NO;
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:archiveDirectory isDirectory:&isDirectory];
    if (!isDirectory || !directoryExists) {
        NSError *createError;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:archiveDirectory withIntermediateDirectories:YES attributes:nil error:&createError];
        if (!success) {
            NSLog(@"create directory failed: %@", createError);
        }
    }
    NSString *archiveFilePath = [archiveDirectory stringByAppendingPathComponent:category.key];
    return archiveFilePath;
}

- (NSArray *)loadMessagesInCategory:(MXSMessageCategory *)category;
{
    NSMutableArray *messages = [NSMutableArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"category" equalTo:category.key];

    NSError *error;
    NSArray *objects = [query findObjects:&error];

    if (!error) {
        // The find succeeded.
        NSLog(@"Successfully retrieved %d messages.", objects.count);
        // Do something with the found objects
        for (PFObject *object in objects) {
            NSLog(@"%@", object.objectId);
            MXSMessage *message = [MXSMessage new];
            message.content = [object objectForKey:@"content"];
            message.author = [object objectForKey:@"author"];
            message.popularityImage = [[object objectForKey:@"popularity_rating"] integerValue];
            [messages addObject:message];
        }
    } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    NSLog(@"messages being loaded");
    
    return [messages copy];
}

- (NSArray *)categories;
{
    NSMutableArray *categories = [NSMutableArray new];
    [categories addObject:[[MXSMessageCategory alloc] initWithTitle:@"Flirt + Funny"
                                                               key:@"FlirtFunny"]];
    [categories addObject:[[MXSMessageCategory alloc] initWithTitle:@"Get a Date"
                                                                key:@"Date"]];
    [categories addObject:[[MXSMessageCategory alloc] initWithTitle:@"Romantic"
                                                                key:@"Romantic"]];
    [categories addObject:[[MXSMessageCategory alloc] initWithTitle:@"Get Lucky"
                                                                key:@"GetLucky"]];
    [categories addObject:[[MXSMessageCategory alloc] initWithTitle:@"I'm Sorry"
                                                                key:@"Sorry"]];
    [categories addObject:[[MXSMessageCategory alloc] initWithTitle:@"Most Popular"
                                                                key:@"MostPop"]];
    
    return [categories copy];
}

- (NSMutableDictionary *)messages
{
    if (!_messages) {
        _messages = [NSMutableDictionary new];
    }
    return _messages;
}

@end
