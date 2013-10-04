//
//  MXSPreferencesViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/25/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSPreferencesViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <uservoice-iphone-sdk/UserVoice.h>
#import "Flurry.h"


@interface MXSPreferencesViewController () <ABPeoplePickerNavigationControllerDelegate>
{
    NSUserDefaults *standard; //supported abbreviated code in NSUserDefaults code references
}

@property (strong, nonatomic) EKEventStore *calendarEventStore;
@property (strong, nonatomic) EKEventStore *reminderEventStore;


@end

@implementation MXSPreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    standard = [NSUserDefaults standardUserDefaults];
    
    CALayer * layer = [_setDefaultRecipientButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:16.0]; //when radius is 0, the border is a rectangle
    [layer setBorderWidth:1.35];
    [layer setBorderColor:[[UIColor colorWithRed:255/255.0f green:128/255.0f blue:0/255.0f alpha:1] CGColor]];

    CALayer * layer2 = [_contactUsButton layer];
    [layer2 setMasksToBounds:YES];
    [layer2 setCornerRadius:16.0]; //when radius is 0, the border is a rectangle
    [layer2 setBorderWidth:1.35];
    [layer2 setBorderColor:[[UIColor colorWithRed:255/255.0f green:128/255.0f blue:0/255.0f alpha:1] CGColor]];

    CALayer * layer3 = [_shareWithUsButton layer];
    [layer3 setMasksToBounds:YES];
    [layer3 setCornerRadius:16.0]; //when radius is 0, the border is a rectangle
    [layer3 setBorderWidth:1.35];
    [layer3 setBorderColor:[[UIColor colorWithRed:255/255.0f green:128/255.0f blue:0/255.0f alpha:1] CGColor]];

    
    
//    [standard setBool:NO forKey:@"recurringCalendarEventSet"]; // Yes = 1 in Objective-C
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkWeeklyCalendarEvent];
    [self checkWeeklyReminder];
    
    [self checkDefaultRecipient];
    if ([standard objectForKey:@"mobilePhoneNumber"]) {
        NSLog(@"Mobile number is %@", [standard stringForKey:@"mobilePhoneNumber"]);
    }
    else
    {
    NSLog(@"Default recipient has NOT been set");
    }
    [Flurry logEvent:@"User went to extras"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contactUs:(id)sender {
    UVConfig *config = [UVConfig configWithSite:@"smoov.uservoice.com"
                                         andKey:@"jXrGUkCby9YjzgTsoKIA"
                                      andSecret:@"xSDPS0gEKKTf8R142QuJlrR3VjPpqlAtAcWMw6R0Y"];
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self andConfig:config];
    [Flurry logEvent:@"Uservoice engaged"];
}

#pragma mark populateLabelsFromUserDefaults

- (void)checkDefaultRecipient
{
    // Check to see if the user has already set a default recipient.
    if ([standard objectForKey:@"Person"]) {
        NSString *person = [standard stringForKey:@"Person"];
        [_setDefaultRecipientButton setTitle:@"Clear" forState:UIControlStateNormal];
        [_personLabel setText:person];
        NSLog(@"Person is %@", [standard stringForKey:@"Person"]);
    }
    else {
    [_setDefaultRecipientButton setTitle:@"Set" forState:UIControlStateNormal];
    [_personLabel setText:@"No default recipient set."];
    }
    
    // Composite name is not currently being saved or used.
    if ([standard objectForKey:@"CompositeName"]) {
        NSLog(@"Composite name is %@", [standard stringForKey:@"CompositeName"]);
    }
}

- (void)checkWeeklyCalendarEvent
{
    // Check to see if the user has already set a recurring calendar event.
    BOOL recurringCalendarEventSet = [standard boolForKey:@"recurringCalendarEventSet"];
    [_weeklyCalendarEventSwitch setOn:recurringCalendarEventSet];

    if ( recurringCalendarEventSet == YES ) {
        [_weeklyCalendarEventStatusLabel setText:@"A smoov calendar event has been set."];
        NSLog(@"Recurring calendar event bool is set to %d", [standard boolForKey:@"recurringCalendarEventSet"]);
    }
    else {
    [_weeklyCalendarEventStatusLabel setText:@"Use your calendar to remember to be smoov."];
    NSLog(@"Recurring calendar event bool is set to %d", [standard boolForKey:@"recurringCalendarEventSet"]);
    }

}

- (void)checkWeeklyReminder
{
    // Check to see if the user has already set a reminder.
    BOOL reminderOn = [standard boolForKey:@"reminderOn"];
    [_weeklyReminderSwitch setOn:reminderOn];
    if ( reminderOn == YES ) {
        [_weeklyReminderStatusLabel setText:@"A smoov reminder has been set."];
        NSLog(@"Reminder bool is set to %d", [standard boolForKey:@"reminderOn"]);
    }
    else {
    [_weeklyReminderStatusLabel setText:@"User a reminder to remember to be smoov."];
    NSLog(@"Reminder bool is set to %d", [standard boolForKey:@"reminderOn"]);
    }
}


#pragma mark ABPeoplePickerNavigationControllerDelegate methods

// Captures the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    ABMultiValueRef phones = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString* mobile=@"";
    NSString* mobileLabel;
    
    for (int i=0; i < ABMultiValueGetCount(phones); i++) {
        mobileLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
        if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
            NSLog(@"mobile:");
        } else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel]) {
            NSLog(@"iphone:");
        } else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhonePagerLabel]) {
            NSLog(@"pager:");
        }
        mobile = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
        NSLog(@"%@", mobile);
    }
    
    //NSLog(@"The mobile label is %@", mobileLabel);
    NSLog(@"The mobile number is %@", mobile);

    NSString* firstName = (__bridge NSString *)(ABRecordCopyValue (person, kABPersonFirstNameProperty));
    NSString* lastName = (__bridge NSString *)(ABRecordCopyValue (person, kABPersonLastNameProperty));
    NSString* fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    [standard setValue:fullName forKey:@"Person"];
    [standard setValue:mobile forKey:@"mobilePhoneNumber"];
    [standard synchronize];

    [_personLabel setText:fullName];

    [self dismissViewControllerAnimated:YES completion:^{ }];
    
    return NO; // do not show contact's details when clicked.
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];

    return NO;
}

// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)chooseDefaultRecipient:(id)sender
{
    // Check to see if the user has already set a default recipient.
    if ([standard objectForKey:@"Person"]) {

        [standard setValue:nil forKey:@"Person"];
        [standard setValue:nil forKey:@"mobilePhoneNumber"];
        [standard synchronize];
        
        [_personLabel setText:@"No default recipient"];        
        [_setDefaultRecipientButton setTitle:@"Set" forState:UIControlStateNormal];
        [Flurry logEvent:@"Default recipient cleared"];
    }
    else {
        ABPeoplePickerNavigationController *picker =
        [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        [Flurry logEvent:@"Contact picker opened"];
    }
}

- (IBAction)weeklyCalendarEventSwitch:(id)sender
{
    if(_weeklyCalendarEventSwitch.isOn) {
        NSLog(@"User turned ON calendar event.");
        if (_calendarEventStore == nil) {
            _calendarEventStore = [[EKEventStore alloc]init];
            [_calendarEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (!granted) {
                    NSLog(@"Access to store not granted");
                   [Flurry logEvent:@"Calendar access denied by user"];
                }
                else {
                    [self performSelectorOnMainThread:@selector(createAndSaveCalendarEvent) withObject:nil waitUntilDone:YES];
                }
            }];
        }
    }
    else {
        [self showCalendarOffAlert];
        [standard setBool:NO forKey:@"recurringCalendarEventSet"]; // Yes = 1 in Objective-C
        [standard synchronize];
        [_weeklyCalendarEventStatusLabel setText:@"Use your calendar to remember to be smoov."];
        _calendarEventStore = nil;
        NSLog(@"User turned OFF calendar event.");
        [Flurry logEvent:@"Calendar event toggled off"];
    }
}

// This was the original button-based weekly calendar event method
/*
- (IBAction)setWeeklyCalendarEvent:(id)sender
{
    BOOL recurringCalendarEventSet = [standard boolForKey:@"recurringCalendarEventSet"];
    if ( recurringCalendarEventSet == NO ) {
        if (_calendarEventStore == nil) {
            _calendarEventStore = [[EKEventStore alloc]init];
            [_calendarEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (!granted)
                NSLog(@"Access to store not granted");
                else {
                    [self performSelectorOnMainThread:@selector(createAndSaveCalendarEvent) withObject:nil waitUntilDone:YES];
                }
            }];
        }
    }
    else {
    [self showCalendarDupeAlert];
    NSLog(@"Don't let the user set the recurring calendar twice");
    }
}
*/

- (void)createAndSaveCalendarEvent
{
    NSDate *endReminderDate = [self dateByAddingXDaysFromToday:365];
    EKRecurrenceRule *rule = [[EKRecurrenceRule alloc]
                              initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly
                              interval:1
                              end:[EKRecurrenceEnd recurrenceEndWithEndDate:endReminderDate]];
    EKEvent *myEvent = [EKEvent
                        eventWithEventStore:self.calendarEventStore];
    myEvent.calendar = _calendarEventStore.defaultCalendarForNewEvents;
    myEvent.title = @"Be smoov: message your lady bird some nice words.";
    myEvent.location = @"Be smoov on your phone";
    NSDate *eventDate = [NSDate date];
    myEvent.startDate = eventDate;
    myEvent.endDate = eventDate;
    myEvent.allDay = TRUE;
    myEvent.availability = EKEventAvailabilityFree;
    [myEvent addRecurrenceRule:rule];
    NSError *error = nil;
    BOOL success = [_calendarEventStore saveEvent:myEvent span:EKSpanFutureEvents error:&error];
    if(success){
        NSLog(@"EVENT SAVED, %@",myEvent.eventIdentifier);
        [standard setBool:YES forKey:@"recurringCalendarEventSet"]; // Yes = 1 in Objective-C
        [self showCalendarSuccessAlert];
        [_weeklyCalendarEventStatusLabel setText:@"A smoov calendar event has been set."];
        [Flurry logEvent:@"Calendar event added"];
    }
    else{
        NSLog(@"error = %@", error);
        [Flurry logEvent:@"Calendar event failed to save"];
    }
    [standard synchronize];
}

// This was the original button-based weekly reminder method
/*
- (IBAction)setWeeklyReminder:(id)sender
{
    
    BOOL reminderOn = [standard boolForKey:@"reminderOn"];
    if ( reminderOn == NO ) {
    
        if (_reminderEventStore == nil)
        {
            _reminderEventStore = [[EKEventStore alloc]init];
            
            [_reminderEventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                
                if (!granted)
                    NSLog(@"Access to store not granted");
                else {
                    [self performSelectorOnMainThread:@selector(createAndSaveReminder) withObject:nil waitUntilDone:YES];
                }
            }];
        }
    }
    else {
    NSLog(@"Don't let the user set the reminder twice");
    [self showReminderDupeAlert];
    }
}
*/

- (IBAction)weeklyReminderSwitch:(id)sender
{
    if(_weeklyReminderSwitch.isOn) {
        NSLog(@"User turned ON reminder.");
        if (_reminderEventStore == nil) {
            _reminderEventStore = [[EKEventStore alloc]init];
            [_reminderEventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                if (!granted) {
                    NSLog(@"Access to store not granted");
                    [Flurry logEvent:@"Reminder access denied by user"];
                }
                else {
                    [self performSelectorOnMainThread:@selector(createAndSaveReminder) withObject:nil waitUntilDone:YES];
                }
            }];
        }
    }
    else {
        [self showReminderOffAlert];
        [standard setBool:NO forKey:@"reminderOn"]; // Yes = 1 in Objective-C
        [standard synchronize];
        [_weeklyReminderStatusLabel setText:@"Use a reminder to remember to be smoov."];
        _reminderEventStore = nil;
        NSLog(@"User turned OFF reminder.");
        [Flurry logEvent:@"Reminder toggled off"];
    }
}

             
-(void)createAndSaveReminder
{
    NSDate *endReminderDate = [self dateByAddingXDaysFromToday:365];
    
    EKRecurrenceRule *rule = [[EKRecurrenceRule alloc]
                              initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly
                              interval:1
                              end:[EKRecurrenceEnd recurrenceEndWithEndDate:endReminderDate]];
    
    EKReminder *myReminder = [EKReminder
                              reminderWithEventStore:self.reminderEventStore];
    
    [myReminder setCalendar:[_reminderEventStore defaultCalendarForNewReminders]];
    myReminder.title = @"Use smoov to message your lady bird something nice.";
    [myReminder addRecurrenceRule:rule];
    
    myReminder.priority = 9; // this will put a single exclamation point priorty on the reminder.
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:endReminderDate];
    
    myReminder.dueDateComponents = components;
    
    NSError *error = nil;
    
    BOOL success = [_reminderEventStore saveReminder:myReminder commit:YES error:&error];
    
    if(!success){
        NSLog(@"error = %@", error);
        [Flurry logEvent:@"Reminder failed to save"];
    }
    else {
    [standard setBool:YES forKey:@"reminderOn"]; // Yes = 1 in Objective-C
    [standard synchronize];
    [self showReminderSuccessAlert];
    [_weeklyReminderStatusLabel setText:@"A smoov reminder has been set."];
    [Flurry logEvent:@"Reminder added"];
    }
}


- (NSDate *)dateByAddingXDaysFromToday:(int)days
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:[NSDate date] options:0];
}

-(void) showCalendarSuccessAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Be smoov."
                                                    message:[NSString stringWithFormat:@"Success! A weekly event to use smoov has been added to your calendar, starting today!"]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) showCalendarDupeAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're already smoov."
                                                    message:[NSString stringWithFormat:@"You can never be too smoov, but you've already added smoov to your calendar."]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) showCalendarOffAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stay smoov."
                                                    message:[NSString stringWithFormat:@"To remove your smoov calendar event, simply delete it from your calendar."]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


-(void) showReminderSuccessAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Be smoov."
                                                    message:[NSString stringWithFormat:@"Success! A reminder to use smoov has been added to your reminders list."]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) showReminderDupeAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're already smoov."
                                                    message:[NSString stringWithFormat:@"You can never be too smoov, but you've already added smoov to your reminder list."]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) showReminderOffAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stay smoov."
                                                    message:[NSString stringWithFormat:@"To remove your smoov reminder, simply delete it from your reminders list."]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


@end
