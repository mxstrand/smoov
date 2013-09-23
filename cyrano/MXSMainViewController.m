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

enum
{
    MessagesSection,
    NumberOfSections
} SectionEnumerator;

@interface MXSMainViewController () <UIActionSheetDelegate>
{
    NSMutableArray *messages;
}

@end

@implementation MXSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadMessages];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)chooseCategory:(id)sender
{
    
    UIActionSheet *displayImageOption = [[UIActionSheet alloc] initWithTitle:@""
                                                                    delegate:self
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"Flirt",
                                                                             @"Birthday",
                                                                             @"Anniversary",
                                                                             @"Get Lucky",
                                                                             @"I'm Sorry", nil];
    
    [displayImageOption showInView:self.view];
    
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        [self gotoFlirt];
    }
    if(buttonIndex == 1){
        [self gotoBirthday];
    }
    if(buttonIndex == 2){
        [self gotoBirthday];
    }
    if(buttonIndex == 3){
        [self gotoAnniversary];
    }
    if(buttonIndex == 4){
        [self gotoGetLucky];
    }
    if(buttonIndex == 5){
        [self gotoImSorry];
    }

}

- (void)gotoFlirt
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //The name "Main_iPhone" is the filename of your storyboard (without the extension).
    //NSLog(
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MXSFlirtViewController"];
    // push to current navigation controller, from any view controller
    
    [self.navigationController pushViewController:vc animated:YES];
    //The view controller's identifier has to be set as the "Storyboard ID" in the Identity Inspector.

}
- (void)gotoBirthday
{

}

- (void)gotoAnniversary
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
    self.tableView.rowHeight = 80.f;
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
    message.content = @"Let's light some candles tonight during dinner. #romantic";
    [messages addObject:message];

}

// A woman's version would let women text guys about sports - with prepopulation of games on that weekend, important players - or video games.
// Tutorial on client driven reminder notifications.  http://www.appcoda.com/ios-programming-local-notification-tutorial/
// Repeating timers https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSTimer_Class/Reference/NSTimer.html


@end
