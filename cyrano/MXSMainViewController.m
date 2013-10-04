//
//  MXSMainViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMainViewController.h"
#import "MXSMessage.h"
#import "MXSMessageCell.h"
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "UIActionSheet+MessageCategory.h"
#import "Flurry.h"

enum
{
    MessagesSection,
    NumberOfSections
} SectionEnumerator;

@interface MXSMainViewController () <MFMessageComposeViewControllerDelegate>

@end


@implementation MXSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:230/255.0f green:128/255.0f blue:0/255.0f alpha:1];
    self.tableView.separatorColor = [UIColor colorWithRed:230/255.0f green:128/255.0f blue:0/255.0f alpha:1];
    
    // Add icon to navbar
    CGRect frame = _logo.frame;
    frame.origin.y = 0.;
    frame.origin.x = self.view.frame.size.width/2. - frame.size.width/2.;
    _logo.frame = frame;
    [self.navigationController.navigationBar addSubview:_logo];
    
    if( self.view.frame.size.height == 480. ) {
        frame = _tableView.frame;
        frame.size.height = self.view.frame.size.height - frame.origin.y - _banner.frame.size.height;
        _tableView.frame = frame;
        
        frame = _banner.frame;
        frame.origin.y = _tableView.frame.origin.y + _tableView.frame.size.height;
        _banner.frame = frame;
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    [self loadMessages];
    standard = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([standard objectForKey:@"Person"]) {
        NSString *person = [standard stringForKey:@"Person"];
        NSLog(@"Person is %@", person);
    }
    
    if ([standard objectForKey:@"mobilePhoneNumber"]) {
        NSString *mobilePhoneNumber = [standard stringForKey:@"mobilePhoneNumber"];
        NSLog(@"mobile phone number is %@", mobilePhoneNumber);
    }

    NSLog(@"%f %f", self.view.frame.size.height, self.tableView.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoUserPreferences:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //The name "Main" is the filename of your storyboard (without the extension).
    //NSLog(
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MXSPreferencesViewController"];
    // push to current navigation controller, from any view controller
    
    [self.navigationController pushViewController:vc animated:YES];
    //The view controller's identifier has to be set as the "Storyboard ID" in the Identity Inspector.
    
}
- (IBAction)chooseMessageCategory:(id)sender {
    
    // Use the Objective-c category for choosing a message cateogry
    UIActionSheet *displayImageOption = [UIActionSheet showMessageCategoriesWithNavController:self.navigationController];
    
    [displayImageOption showInView:self.view];
}


#pragma mark - UITableView data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return NumberOfSections;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.rowHeight = 60.f;
    
    return [messages count];
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageViewCell" forIndexPath:indexPath];
    [cell populateWithMessage:messages[indexPath.row]];
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXSMessage *selectedMessage = [messages objectAtIndex:indexPath.row];
    NSString *selectedContent = selectedMessage.content;

    // Send chosen message to flurry
    NSDictionary *messageParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     selectedContent, @"Message content", // Capture message
     nil];
    
    [Flurry logEvent:@"Message chosen by user" withParameters:messageParams];
    NSLog(@"Message chosen by user");
    
    //NSArray *selectedAttachments = [NSString stringWithFormat:@"icon%d.png", indexPath.row];
    [self showSMS:selectedContent];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            [Flurry logEvent:@"Message cancellled by user"];
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            [Flurry logEvent:@"Message send failed"];
            break;
        }
            
        case MessageComposeResultSent:
            [Flurry logEvent:@"Message send success"];
            break;
        
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - showSMS

- (void)showSMS:(NSString*)message {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSString *SMSmessage = [NSString stringWithFormat:@"%@", message];
    //NSArray *attachments = attachments;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    
    NSLog(@"Mobile Number %@",[standard stringForKey:@"mobilePhoneNumber"]);
    
    // Only populate the recipient, if a default recipient has been set.
    if ([standard stringForKey:@"mobilePhoneNumber"] != NULL) {
        [messageController setRecipients:@[[standard stringForKey:@"mobilePhoneNumber"]]];//Each string in the array should contain the phone number of the intended recipient.
    }
    
    [messageController setBody:SMSmessage];
    // [messageController addAttachmentURL:attachments];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

# pragma mark - Ad Error Handling

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Error Loading Ad: ");
    [self layoutAnimated:YES];
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"did load ad");
    [self layoutAnimated:YES];
}

- (void)layoutAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        CGRect frame = _tableView.frame;
        if( _banner.bannerLoaded) {
            frame.size.height = self.view.bounds.size.height - frame.origin.y - _banner.frame.size.height;
            NSLog( @"animating ad in");
        }
        else {
            NSLog(@"animating ad out");
            frame.size.height = self.view.bounds.size.height - frame.origin.y;
        }
        _tableView.frame = frame;
    }];
}

#pragma mark - Messages

- (void) loadMessages
{
    messages = [NSMutableArray new];
    NSLog(@"messages being loaded");
    
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
    
}
    
//TO DO
/*
 A woman's version would let women text guys about sports - with prepopulation of games on that weekend, important players - or video games.
 Tutorial on client driven reminder notifications.  http://www.appcoda.com/ios-programming-local-notification-tutorial/
 Repeating timers https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSTimer_Class/Reference/NSTimer.html
 
*/

@end
