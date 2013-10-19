//
//  MXSFlirtViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSDateViewController.h"
#import "MXSMessage.h"

@implementation MXSDateViewController

- (void) loadLocalMessages
{
    messages = [NSMutableArray new];
    NSLog(@"messages being loaded");
    
    MXSMessage *message = [MXSMessage new];
    message.content = @"Let's go camping, have a fire, and I'll tell you ghost stories.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"When's the last time you went to the zoo?. Let's go look at baby tigers together.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I just had a great idea. Let's go drink a bottle of wine at the beach.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I'm a kid at heart. Want to go to the aquarium with me?";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"When's our next rendezvous?";
    message.popularityImage = 5;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Do you know any good happy hours?";
    message.popularityImage = 2;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"What sounds more fun...ice skating or ice hockey?";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Are you a sushi or fish-n-chips person?";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I'm thinking of getting tickets to a game. Interested?";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I need some new clothes. What stores do you like for guys?";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I need to pick out a halloween costume. Will you help?";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I've been wanting to learn to cook. Can you teach me?";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I'm nice so I just ordered you a 1/2 pizza to be delivered to your house. I'm gonna need to swing by and pick up my 1/2.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"New Restaurant. You. Me. ???";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"What are you doing right now? Let's go have an amazing conversation somewhere.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"What's your favorite Lean Pocket? because I'm flush with coupons right now.";
    message.popularityImage = 3;
    [messages addObject:message];
}

- (void) loadParseMessages
{
    messages = nil; // set MutableArray back to nil, so messages don't duplicate
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"category" equalTo:@"Date"];
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