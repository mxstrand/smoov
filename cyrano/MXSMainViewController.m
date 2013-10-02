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

enum
{
    MessagesSection,
    NumberOfSections
} SectionEnumerator;

@interface MXSMainViewController () <MFMessageComposeViewControllerDelegate>
{
    NSMutableArray *messages;
    NSUserDefaults *standard; //supports abbreviated code in NSUserDefaults code references.
}

@end

@implementation MXSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:230/255.0f green:128/255.0f blue:0/255.0f alpha:1];
    self.tableView.separatorColor = [UIColor colorWithRed:230/255.0f green:128/255.0f blue:0/255.0f alpha:1];
    
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
    //NSArray *selectedAttachments = [NSString stringWithFormat:@"icon%d.png", indexPath.row];
    [self showSMS:selectedContent];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
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



#pragma mark - Messages

- (void) loadMessages
{
    messages = [NSMutableArray new];
    NSLog(@"messages being loaded");

    MXSMessage *message = [MXSMessage new];
    message.content = @"I thought you looked really pretty this morning.";
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I'm really excited to spend some time together after work.";
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Let's light some candles tonight during dinner.";
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Thanks for everything you do around the house.";
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Greatest hits 5";
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Greatest hits 6";
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Greatest hits 7";
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Greatest hits 8";
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Greatest hits 9";
    [messages addObject:message];

}

// A woman's version would let women text guys about sports - with prepopulation of games on that weekend, important players - or video games.
// Tutorial on client driven reminder notifications.  http://www.appcoda.com/ios-programming-local-notification-tutorial/
// Repeating timers https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSTimer_Class/Reference/NSTimer.html


@end
