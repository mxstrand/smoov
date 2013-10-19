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

@interface MXSMessageViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) MXSMessages *messageStore;

@end

@implementation MXSMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadViewData];
}

- (void)loadViewData
{
    self.messageStore = [MXSMessages new];
    [self.messageStore messagesInCategory:self.messageCategory completion:^(NSArray *messages) {
        self.messages = messages;
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
    [cell populateWithMessage:self.messages[indexPath.row]];
    return cell;
}

- (void)populateWithMessage:(MXSMessage*)messagex
{
    
    self->message.text = messagex.content;
    
    visualPopularityImage.image = [self imageForPopularity:messagex.popularityImage];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.messages = nil;
}

@end
