//
//  MXSPeferencesViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/25/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSPeferencesViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <uservoice-iphone-sdk/UserVoice.h>

@interface MXSPeferencesViewController () <ABPeoplePickerNavigationControllerDelegate>
{
    NSUserDefaults *standard; //supported abbreviated code in NSUserDefaults code references
}

@property (strong, nonatomic) EKEventStore *calendarEventStore;
@property (strong, nonatomic) EKEventStore *reminderEventStore;


@end

@implementation MXSPeferencesViewController

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
    
    if ([standard objectForKey:@"Person"]) {
        NSString *person = [standard stringForKey:@"Person"];
        [_personLabel setText:person];
        NSLog(@"Person is %@", [standard stringForKey:@"Person"]);
    }
    
    if ([standard objectForKey:@"CompositeName"]) {
        NSLog(@"Composite name is %@", [standard stringForKey:@"CompositeName"]);
    }
    
    if ([standard objectForKey:@"mobilePhoneNumber"]) {
        NSLog(@"Mobile number is %@", [standard stringForKey:@"mobilePhoneNumber"]);
    }
    
    // Check to see if the user has already set a recurring calendar event.
    BOOL recurringCalendarEventSet = [standard boolForKey:@"recurringCalendarEventSet"];
    if ( recurringCalendarEventSet == YES ) {
        [_weeklyCalendarEventStatusLabel setText:@"Calendar event already set."];
        NSLog(@"Recurring calendar event bool is set to %d", [standard boolForKey:@"recurringCalendarEventSet"]);
        }
    [_weeklyCalendarEventStatusLabel setText:@"No event set."];
    NSLog(@"Recurring calendar event bool is set to %d", [standard boolForKey:@"recurringCalendarEventSet"]);
    
    // Check to see if the user has already set a reminder.
    BOOL reminderOn = [standard boolForKey:@"reminderOn"];
    if ( reminderOn == YES ) {
        [_weeklyCalendarEventStatusLabel setText:@"Reminder already set."];
        NSLog(@"Reminder bool is set to %d", [standard boolForKey:@"reminderOn"]);
    }
    [_weeklyCalendarEventStatusLabel setText:@"No event set."];
    NSLog(@"Reminder bool is set to %d", [standard boolForKey:@"reminderOn"]);
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
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)submitText:(id)sender
{
    UVConfig *config = [UVConfig configWithSite:@"strandcode.uservoice.com"
                                         andKey:@"67q2CaIMgvUYVY19JhCow"
                                      andSecret:@"Zne5bmfI498LLwrvWGa2fThMTv2K8VbWP2kvcjHqvY"];
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self andConfig:config];
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
    NSString* fullName = @"No Default Recipient";
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
    }
    else
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

    }
    NSLog(@"Don't let the user set the recurring calendar twice");
}


- (NSDate *)dateByAddingXDaysFromToday:(int)days
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:[NSDate date] options:0];
}

//Reminders tutorial
//http://www.techotopia.com/index.php/Using_iOS_6_Event_Kit_to_Create_Date_and_Location_Based_Reminders

@end
