//
//  SomeObject.h
//  NSOperationQueueTest
//
//  Created by Jonathan Wei on 7/10/12.
//  Copyright (c) 2012 aWhiteRaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SomeObject : NSObject <NSTableViewDataSource, NSTableViewDelegate> {

    NSURL *savepath; // Path to save files to
    NSOpenPanel *openPanel; // The panel that opens up to choose a directory
    
    NSDictionary *filesList; // Off-site plist that has the names
    NSMutableArray *filesArray;
    
    IBOutlet NSButton *directoryButton;
    IBOutlet NSButton *getButton;
    IBOutlet NSProgressIndicator *progressSpinner; // Activity indicator
    IBOutlet NSTableView *objectTable; // The table that will list the files
    IBOutlet NSTableColumn *checkColumn; // The check column for the latter table
    IBOutlet NSTableColumn *objectColumn; // The names column for the latter table
    
    IBOutlet NSTextField *pathField;
}
- (IBAction)setDirectory:(id)sender;
- (IBAction)getCheckedList:(id)sender;

@end
