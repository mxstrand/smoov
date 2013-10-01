//
//  MXSFlirtViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSFlirtViewController.h"
#import "MXSMainViewController.h"

#import "MXSMessage.h"
#import "MXSMessageCell.h"

#import <MessageUI/MessageUI.h>
#import "UIActionSheet+MessageCategory.h"

enum
{
    MessagesSection,
    NumberOfSections
} SectionEnumerator;


@interface MXSFlirtViewController ()
{
    NSMutableArray *messages;
}

@end

@implementation MXSFlirtViewController

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
    message.content = @"I'm a FLIRT text 1.";
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Flirt text 2.";
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Flirt text 3.";
    [messages addObject:message];
    
}

@end