//
//  MXSMessage.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMessage.h"

@interface MXSMessage () <NSCoding>

@end

@implementation MXSMessage

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _content = [aDecoder decodeObjectForKey:@"content"];
        _author = [aDecoder decodeObjectForKey:@"author"];
        _popularityImage = [[aDecoder decodeObjectForKey:@"popularityImage"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:@(self.popularityImage) forKey:@"popularityImage"];
}

@end
