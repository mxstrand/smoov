//
//  MXSFlirtViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSSorryViewController.h"
#import "MXSMessage.h"

@implementation MXSSorryViewController

- (void) loadLocalMessages
{
    messages = [NSMutableArray new];
    NSLog(@"messages being loaded");
    
    MXSMessage *message = [MXSMessage new];
    message.content = @"I've been thinking about our discussion and you were totally right.";
    message.popularityImage = 5;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I was dropped a lot as a baby. That must explain why I did that. Sorry.";
    message.popularityImage = 2;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I'm going to invent a new word....sorryouweright.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"You are always right. I'm sorry I questioned you.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Thanks for not beating me up. I was being a dork.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Basically, I'm not that smart. Sorry.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"If I can give you 7 hugs in under 5 seconds, will you forgive me?";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I've been thinking about what happened, and I'm really sorry.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I called and it IS legally possible to change my name to stoopid-head. Should I make the appointment?";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Can we hold peace talks tonight? I'm sorry.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I'm sorry I said I liked your sister's yoga pants.";
    message.popularityImage = 3;
    [messages addObject:message];

}

- (void) loadParseMessages
{
    messages = nil; // set MutableArray back to nil, so messages don't duplicate
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"category" equalTo:@"Sorry"];
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
        [self.tableView reloadData];
    }];
    NSLog(@"messages being loaded");
}


@end