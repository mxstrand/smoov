//
//  MXSMessageViewController.m
//  cyrano
//
//  Created by Michael Strand on 10/18/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMessageViewController.h"
#import "MXSMessage.h"
#import "MXSMessages.h"
#import "MXSMessageCell.h"
#import "MXSMessageCategory.h"
#import "MXSMessageReversalViewController.h"

#import <iAd/iAd.h>
#import "Flurry.h"
#import <uservoice-iphone-sdk/UserVoice.h>
#import "Reachability.h"

#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface MXSMessageViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    UIView *myAdView;
    NSUserDefaults *standard; //supports abbreviated code in NSUserDefaults code references.
}

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) MXSMessages *messageStore;

@property (nonatomic, strong) MXSMessageCategory *messageCategory;

@property (nonatomic, strong) IBOutlet ADBannerView *banner;
@property (nonatomic, strong) IBOutlet UIImageView *logo;

@end

@implementation MXSMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadViewData];
    [self selectCategory:self.messageCategory];
    [self checkUserDefaults];
    [self setupView];
}

- (void)loadViewData
{
    self.messageStore = [MXSMessages new];
    self.categories = [self.messageStore categories];
}

- (MXSMessageCategory *)messageCategory
{
    if (!_messageCategory) {
        _messageCategory = [[MXSMessageCategory alloc] initWithTitle:@"Most Popular" key:@"MostPop"];
    }
    return _messageCategory;
}

- (void)selectCategory:(MXSMessageCategory *)category
{
    self.categoryLabel.text = category.title;
    
    [self.messageStore messagesInCategory:category completion:^(NSArray *messages) {
        self.messages = messages;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageTableView reloadData];
        });
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageViewCell" forIndexPath:indexPath];
    MXSMessage *message = self.messages[indexPath.row];
    cell.messageLabel.text = message.content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXSMessage *selectedMessage = [self.messages objectAtIndex:indexPath.row];
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


- (void)showSMS:(NSString*)message
{
    if (![MFMessageComposeViewController canSendText]) {
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.messages = nil;
}

- (IBAction)categoriesBarButtonPressed:(id)sender
{
    [self showCategoriesActionSheet];
}

- (void)showCategoriesActionSheet
{
    UIActionSheet *categoryActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:nil];
    for (MXSMessageCategory *category in self.categories) {
        [categoryActionSheet addButtonWithTitle:category.title];
    }
    [categoryActionSheet addButtonWithTitle:@"Cancel"];
    [categoryActionSheet setOpaque:YES];
    [categoryActionSheet setCancelButtonIndex:[self.categories count]];
    [categoryActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        self.messageCategory = self.categories[buttonIndex];
        [self selectCategory:self.messageCategory];
    }
}

- (IBAction)extrasBarButtonPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //The name "Main" is the filename of your storyboard (without the extension).
    //NSLog(
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MXSPreferencesViewController"];
    // push to current navigation controller, from any view controller
    
    [self.navigationController pushViewController:vc animated:YES];
    //The view controller's identifier has to be set as the "Storyboard ID" in the Identity Inspector.
}

- (void)setupView
{
    // table styling
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:128/255.0f blue:0/255.0f alpha:1];
    self.messageTableView.separatorColor = [UIColor colorWithRed:255/255.0f green:128/255.0f blue:0/255.0f alpha:1];
    
    // Add icon to navbar
    CGRect frame = _logo.frame;
    frame.origin.y = 0.;
    frame.origin.x = self.view.frame.size.width/2. - frame.size.width/2.;
    _logo.frame = frame;
    [self.navigationController.navigationBar addSubview:_logo];
    
    [self createMyAd];
    
    if( self.view.frame.size.height == 480. ) {
        frame = self.messageTableView.frame;
        frame.size.height = self.view.frame.size.height - frame.origin.y - _banner.frame.size.height;
        self.messageTableView.frame = frame;
        
        frame = _banner.frame;
        frame.origin.y = self.messageTableView.frame.origin.y + self.messageTableView.frame.size.height;
        _banner.frame = frame;
        
        frame = myAdView.frame;
        frame.origin.y = self.messageTableView.frame.origin.y + self.messageTableView.frame.size.height;
        myAdView.frame = frame;
    }
    
	// Add long press gesture recognizer
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1; //seconds
    [self.messageTableView addGestureRecognizer:lpgr];
    
    // Do any additional setup after loading the view, typically from a nib.
    standard = [NSUserDefaults standardUserDefaults];
}

- (void)checkUserDefaults
{
    if ([standard objectForKey:@"Person"]) {
        NSString *person = [standard stringForKey:@"Person"];
        NSLog(@"Person is %@", person);
    }
    
    if ([standard objectForKey:@"mobilePhoneNumber"]) {
        NSString *mobilePhoneNumber = [standard stringForKey:@"mobilePhoneNumber"];
        NSLog(@"mobile phone number is %@", mobilePhoneNumber);
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if( gestureRecognizer.state != UIGestureRecognizerStateBegan ) return;
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    if (reachability.reachabilityFlags & ReachableViaWiFi || reachability.reachabilityFlags & ReachableViaWWAN) {
        
        CGPoint p = [gestureRecognizer locationInView:self.messageTableView];
        
        NSIndexPath *indexPath = [self.messageTableView indexPathForRowAtPoint:p];
        
        if (indexPath == nil)
            NSLog(@"long press on table view but not on a row");
        else {
            NSLog(@"long press on table view at row %d", indexPath.row);
            
            MXSMessage *selectedMessage = [self.messages objectAtIndex:indexPath.row];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //The name "Main" is the filename of your storyboard (without the extension).
            
            MXSMessageReversalViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MXSMessageReversalViewController"];
            // push to current navigation controller, from any view controller
            vc.message = selectedMessage;
            
            [self.navigationController pushViewController:vc animated:NO];
            [UIView transitionWithView:self.navigationController.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Internet connection required to see message detail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
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

# pragma mark - Ad Error Handling

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Error Loading Ad in %@", [self class]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:myAdView];
    });
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"did load ad %@", [self class]);
    
    [myAdView removeFromSuperview];
}

- (void)createMyAd
{
    myAdView = [[UIView alloc] initWithFrame:_banner.frame];
    myAdView.backgroundColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.view addSubview:myAdView];
    //myAdView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *touchOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactUs)];
    // Set required taps and number of touches
    [touchOnView setNumberOfTapsRequired:1];
    [touchOnView setNumberOfTouchesRequired:1];
    [myAdView addGestureRecognizer:touchOnView];
    
    UILabel *adLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 300, 25)];
    
    [adLabel1 setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]];
    [adLabel1 setBackgroundColor:[UIColor clearColor]];
    [adLabel1 setFont:[UIFont fontWithName: @"Helvetica-Bold" size: 15.0f]];
    [adLabel1 setNumberOfLines:2];
    [adLabel1 setText:@"Got ideas for new smoov texts?"];
    [myAdView addSubview:adLabel1];
    
    UILabel *adLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(93, 25, 300, 20)];
    
    [adLabel2 setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    [adLabel2 setBackgroundColor:[UIColor clearColor]];
    [adLabel2 setFont:[UIFont fontWithName: @"Helvetica-Bold" size: 15.0f]];
    [adLabel2 setNumberOfLines:2];
    [adLabel2 setText:@"Click here to 'POST AN IDEA'"];
    [myAdView addSubview:adLabel2];
    
}

- (void)contactUs
{
    UVConfig *config = [UVConfig configWithSite:@"smoov.uservoice.com"
                                         andKey:@"jXrGUkCby9YjzgTsoKIA"
                                      andSecret:@"xSDPS0gEKKTf8R142QuJlrR3VjPpqlAtAcWMw6R0Y"];
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self andConfig:config];
    [Flurry logEvent:@"Uservoice engaged from ad"];
}


@end
