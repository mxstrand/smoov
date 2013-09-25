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

enum
{
    MessagesSection,
    NumberOfSections
} SectionEnumerator;

@interface MXSMainViewController () <UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate>
{
    NSMutableArray *messages;
}

@end

@implementation MXSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // navBar.barTintColor = [UIColor colorWithRed:117/255.0f green:4/255.0f blue:32/255.0f alpha:1];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.tableView.separatorColor = [UIColor colorWithRed:230/255.0f green:128/255.0f blue:0/255.0f alpha:1];
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
	// Do any additional setup after loading the view, typically from a nib.
    [self loadMessages];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choosePrimaryContact:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
}



- (IBAction)chooseCategory:(id)sender
{
    
    UIActionSheet *displayImageOption = [[UIActionSheet alloc] initWithTitle:@""
                                                                    delegate:self
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"Flirt / Funny",
                                                                             @"Get a Date",
                                                                             @"Birthday / Anniversary",
                                                                             @"Romantic",
                                                                             @"Get Lucky",
                                                                             @"Most Popular",
                                                                             @"I'm Sorry", nil];
    

    //[displayImageOption setAlpha:0.75];
    [displayImageOption setOpaque:YES];
    
    //displayImageOption.actionSheetStyle=UIActionSheetStyleBlackTranslucent; //why isn't this working?
    //displayImageOption.actionSheetStyle=UIActionSheetStyleBlackOpaque; //why isn't this working?
    [displayImageOption showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        [self gotoFlirtFunny];
    }
    if(buttonIndex == 1){
        [self gotoGetADate];
    }
    if(buttonIndex == 2){
        [self gotoBirthdayAnniversary];
    }
    if(buttonIndex == 3){
        [self gotoRomantic];
    }
    if(buttonIndex == 4){
        [self gotoGetLucky];
    }
    if(buttonIndex == 5){
       [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if(buttonIndex == 6){
        [self gotoImSorry];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)displayImageOption
{
    //displayImageOption.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
}

- (void)gotoFlirtFunny
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //The name "Main_iPhone" is the filename of your storyboard (without the extension).
    //NSLog(
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MXSFlirtViewController"];
    // push to current navigation controller, from any view controller
    
    [self.navigationController pushViewController:vc animated:YES];
    //The view controller's identifier has to be set as the "Storyboard ID" in the Identity Inspector.

}

- (void)gotoBirthdayAnniversary
{

}

- (void)gotoGetADate
{
    
}

- (void)gotoRomantic
{
}

- (void)gotoGetLucky
{

}

- (void)gotoImSorry
{

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

- (void)showSMS:(NSString*)message {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    //NSArray *recipents = @[@""];
    NSString *SMSmessage = [NSString stringWithFormat:@"%@", message];
    //NSArray *attachments = attachments;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    // [messageController setRecipients:recipents];
    [messageController setBody:SMSmessage];
    // [messageController addAttachmentURL:attachments];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
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

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// A woman's version would let women text guys about sports - with prepopulation of games on that weekend, important players - or video games.
// Tutorial on client driven reminder notifications.  http://www.appcoda.com/ios-programming-local-notification-tutorial/
// Repeating timers https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSTimer_Class/Reference/NSTimer.html


@end
