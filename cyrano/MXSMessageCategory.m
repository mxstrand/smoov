//
//  MXSMessageCategory.m
//  cyrano
//
//  Created by Michael Strand on 10/18/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMessageCategory.h"

@implementation MXSMessageCategory

- (id)initWithTitle:(NSString *)title key:(NSString *)key;
{
    self = [self init];
    if (self) {
        _title = [title copy];
        _key = [key copy];
    }
    return self;
}

@end
