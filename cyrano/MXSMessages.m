//
//  MXSMessages.m
//  cyrano
//
//  Created by Michael Strand on 10/18/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMessages.h"
#import "MXSMessage.h"
#import <Parse/Parse.h>

static NSString * const kMXSMessagesCacheFileName = @"MXSMessagesCacheFile";

@interface MXSMessages ()

@property (nonatomic, strong) NSMutableDictionary *messages;

@end

@implementation MXSMessages

- (void)messagesInCategory:(NSString *)category completion:(void (^)(NSArray *))completion
{
    if (!self.messages[category]) {
        self.messages[category] = [self loadMessagesInCategory:category];
    }
    
    completion([self.messages[category] copy]);
}

- (NSArray *)loadMessagesInCategory:(NSString *)category;
{
    NSMutableArray *messages = [NSMutableArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"category" equalTo:category];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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
    }];
    NSLog(@"messages being loaded");
    
    return [messages copy];
}


@end
