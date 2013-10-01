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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseDefaultRecipient:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)submitText:(id)sender
{
    UVConfig *config = [UVConfig configWithSite:@"smoov.uservoice.com"
                                         andKey:@"jXrGUkCby9YjzgTsoKIA"
                                      andSecret:@"xSDPS0gEKKTf8R142QuJlrR3VjPpqlAtAcWMw6R0Y"];
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self andConfig:config];
}

#pragma mark populateLabelsFromUserDefaults

- (void)checkDefaultRecipient
{
    // Check to see if the user has already set a default recipient.
    if ([standard objectForKey:@"Person"]) {
        NSString *person = [standard stringForKey:@"Person"];
        [_personLabel setText:person];
        NSLog(@"Person is %@", [standard stringForKey:@"Person"]);
    }
    else {
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
    if ( recurringCalendarEventSet == YES ) {
        [_weeklyCalendarEventStatusLabel setText:@"Calendar event already set."];
        NSLog(@"Recurring calendar event bool is set to %d", [standard boolForKey:@"recurringCalendarEventSet"]);
    }
    else {
    [_weeklyCalendarEventStatusLabel setText:@"No calendar event set."];
    NSLog(@"Recurring calendar event bool is set to %d", [standard boolForKey:@"recurringCalendarEventSet"]);
    }

}

- (void)checkWeeklyReminder
{
    // Check to see if the user has already set a reminder.
    BOOL reminderOn = [standard boolForKey:@"reminderOn"];
    if ( reminderOn == YES ) {
        [_weeklyReminderStatusLabel setText:@"Reminder already set."];
        NSLog(@"Reminder bool is set to %d", [standard boolForKey:@"reminderOn"]);
    }
    else {
    [_weeklyReminderStatusLabel setText:@"No reminder set."];
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

- (IBAction)clearPrimaryContact:(id)sender
{
    NSString* fullName = @"No default recipient";
    NSString* mobile=NULL;
    
    [standard setValue:fullName forKey:@"Person"];
    [standard setValue:mobile forKey:@"mobilePhoneNumber"];
    [standard synchronize];
    
    [_personLabel setText:fullName];
}

- (IBAction)setWeeklyCalendarEvent:(id)sender
{
    BOOL recurringCalendarEventSet = [standard boolForKey:@"recurringCalendarEventSet"];
    if ( recurringCalendarEventSet == NO ) {
        
        if (_calendarEventStore == nil) {
            _calendarEventStore = [[EKEventStore alloc]init];
                
            [_calendarEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (!granted)
                NSLog(@"Access to store not granted");
            }];
        }
            
        NSDate *endReminderDate = [self dateByAddingXDaysFromToday:365];
        
        EKRecurrenceRule *rule = [[EKRecurrenceRule alloc]
                                  initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly
                                  interval:1
                                  end:[EKRecurrenceEnd recurrenceEndWithEndDate:endReminderDate]];
        
        EKEvent *myEvent = [EKEvent
                            eventWithEventStore:self.calendarEventStore];
        
        myEvent.calendar = _calendarEventStore.defaultCalendarForNewEvents;
        myEvent.title = @"Use smoov to message your lady bird something nice.";
        myEvent.location = @"smoov on your phone";
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
            [standard synchronize];
        }
        
        else{
            NSLog(@"error = %@", error);
        }
        
        [_weeklyCalendarEventStatusLabel setText:@"Calendar event set."];
        
        [self showCalendarSuccessAlert];
    }
    else
    [self showCalendarDupeAlert];
    NSLog(@"Don't let the user set the recurring calendar twice");
}

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
            }];
        }
        
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
        }
        [standard setBool:YES forKey:@"reminderOn"]; // Yes = 1 in Objective-C
        [standard synchronize];
        [_weeklyReminderStatusLabel setText:@"Reminder set."];
        [self showReminderSuccessAlert];

    }
    else {
    NSLog(@"Don't let the user set the recurring calendar twice");
    [self showReminderDupeAlert];
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
                                                    message:[NSString stringWithFormat:@"Success! A recurring weekly event to use smoov has been added to your calendar. This event shows as 'free' and will not block your calendar. You can edit this event like any other calendar item."]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) showCalendarDupeAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're already smoov."
                                                    message:[NSString stringWithFormat:@"We agree that you can never be too smoov, but you've already added smoov to your calendar."]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


-(void) showReminderSuccessAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Be smoov."
                                                    message:[NSString stringWithFormat:@"Success! A reminder to use smoov has been added to your reminders list. You can edit it like any other reminder item."]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) showReminderDupeAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're already smoov."
                                                    message:[NSString stringWithFormat:@"We agree that you can never be too smoov, but you've already added smoov to your reminder list."]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



@end
