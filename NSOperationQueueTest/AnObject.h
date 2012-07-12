//
//  AnObject.h
//  NSOperationQueueTest
//
//  Created by Jonathan Wei on 7/10/12.
//  Copyright (c) 2012 aWhiteRaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnObject : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) BOOL checked;

- (id)initWithName:(NSString *)username;
- (NSString *)name;

@end
