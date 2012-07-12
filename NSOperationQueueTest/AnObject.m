//
//  AnObject.m
//  NSOperationQueueTest
//
//  Created by Jonathan Wei on 7/10/12.
//  Copyright (c) 2012 aWhiteRaven. All rights reserved.
//

#import "AnObject.h"

@implementation AnObject

@synthesize checked;
@synthesize name;

- (id)init {
    return [self initWithName:@"EMPTY"];
}

- (id)initWithName:(NSString *)username {
    if (self = [super init]) {
        name = username;
    }
    return self;
}

- (NSString *)name {
    return name;
}


@end
