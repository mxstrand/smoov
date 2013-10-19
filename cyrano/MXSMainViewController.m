//
//  MXSMainViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMainViewController.h"
#import "MXSMessage.h"
#import "MXSMessages.h"
#import "MXSMessageCategory.h"
#import "MXSMessageCell.h"
#import "MXSMessageReversalViewController.h"
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "UIActionSheet+MessageCategory.h"
#import "Flurry.h"
#import <uservoice-iphone-sdk/UserVoice.h>
#import "MXSMessageViewController.h"

enum
{
    MessagesSection,
    NumberOfSections
} SectionEnumerator;

@interface MXSMainViewController () <MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>
{
    UIView *myAdView;
}

@end


@implementation MXSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadLocalMessages];
    
    if ([standard objectForKey:@"Person"]) {
        NSString *person = [standard stringForKey:@"Person"];
        NSLog(@"Person is %@", person);
    }
    
    if ([standard objectForKey:@"mobilePhoneNumber"]) {
        NSString *mobilePhoneNumber = [standard stringForKey:@"mobilePhoneNumber"];
        NSLog(@"mobile phone number is %@", mobilePhoneNumber);
    }
}


- (IBAction)gotoUserPreferences:(id)sender
{    
}
- (IBAction)chooseMessageCategory:(id)sender
{
}

#pragma mark - Table view delegate



#pragma mark - showSMS




#pragma mark - Messages

- (void)loadLocalMessages
{
    messages = [NSMutableArray new];
    
    MXSMessage *message = [MXSMessage new];
    message.content = @"I thought you looked really pretty this morning.";
    message.popularityImage = 5;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I'm really excited to spend some time together after work.";
    message.popularityImage = 2;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Let's light some candles tonight during dinner.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Thanks for everything you do around the house.";
    message.popularityImage = 4;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I bet you are going to do awesome at work today.";
    message.popularityImage = 1;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Hey, what's your favorite flower? I just want to know.";
    message.popularityImage = 4;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I liked your outfit today. You looked really good.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I'm thinking about your perfume right now.";
    message.popularityImage = 2;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I've been thinking about our discussion and you were totally right.";
    message.popularityImage = 5;
    [messages addObject:message];

    NSLog(@"LOCAL messages being loaded");
}



- (void) loadParseMessages
{
    messages = nil; // set MutableArray back to nil, so messages don't duplicate

    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"category" equalTo:@"MostPop"];
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


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
    HUD = nil;
}


//TO DO
/*
 A woman's version would let women text guys about sports - with prepopulation of games on that weekend, important players - or video games.
 Tutorial on client driven reminder notifications.  http://www.appcoda.com/ios-programming-local-notification-tutorial/
 Repeating timers https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSTimer_Class/Reference/NSTimer.html
 
 Email: smoovtext@live.com
 Password: R2D2forPrez
 Twitter: smooveText
 Password: R2D2forPrez
 
*/

@end
