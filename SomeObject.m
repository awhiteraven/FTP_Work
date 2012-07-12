//
//  SomeObject.m
//  NSOperationQueueTest
//
//  Created by Jonathan Wei on 7/10/12.
//  Copyright (c) 2012 aWhiteRaven. All rights reserved.
//

#import "SomeObject.h"
#import "AnObject.h"


@implementation SomeObject

/*
 This is the init method.
 - It sets up the array that will hold the name objects (which is retrieved from the plist file)
 */
- (id)init {
    if (self = [super init]) {
        NSLog(@"SomeObject Init");
        // Gets the path of the document directory which contains the Plist
        NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path objectAtIndex:0]; 
        filesArray = [[NSMutableArray alloc]init];
        
        // Sets up the dictionary with the plist file (This is used only once, then the array is used)
        filesList = [[NSDictionary alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/Files.plist",documentsDirectory]];
        
        // Fills the array with objects from the dictionary
        for (int i = 0; i < [filesList count]; i++) {
            AnObject *file = [[AnObject alloc]initWithName:[filesList objectForKey:[NSString stringWithFormat:@"File%d",i+1]]];
            [filesArray addObject:file];
        }
        
    }
    return self;
}

/*
 This method sets the directory and enables the Get button if a directory is chosen
 */
- (IBAction)setDirectory:(id)sender {
    openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    
    int retVal = [openPanel runModal];
    
    if (retVal == NSOKButton) {
        NSLog(@"Saved");
        [getButton setEnabled:YES];
        [pathField setStringValue:[NSString stringWithFormat:@"%@",[[openPanel URL]path]]];
    }
    

}

/*
 This method will go through the array and get the files with a True 'checked' (BOOL) value
 It also starts the progress animation, and performs EVERYTHING in a background thread.
 */
- (IBAction)getCheckedList:(id)sender {
    [progressSpinner startAnimation:self];
    for (int i = 0; i < [filesList count]; i++) {
        AnObject *curItem = [filesArray objectAtIndex:i];
        if ([curItem checked]) {
            // This SHOULD start everything in a background thread
            [self performSelectorInBackground:@selector(getData:) withObject:curItem];
        }
    }
    
}

/*
 The method run in a separate thread that gets the files
 */
- (void)getData:(AnObject *)cur {
    NSString *filename = [NSString stringWithFormat:@"%@/%@",[openPanel URL],[cur name]];
    NSLog(@"%@",filename);
    NSString *fileLocation = [NSString stringWithFormat:@"http://dl.dropbox.com/u/8327799/%@",[cur name]];
    NSLog(@"%@",fileLocation);
    NSData *download = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileLocation]];
    [download writeToURL:[NSURL URLWithString:filename] atomically:YES];
    NSLog(@"%@",[cur name]);
    
    // Bounces Icon
    [NSApp requestUserAttention:NSCriticalRequest];

    // Alerts the user that the request is complete.
    NSAlert *alert = [[NSAlert alloc]init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Your request is complete."];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert runModal];
    
    // Stops spinner
    [progressSpinner stopAnimation:self];
}

/*
 Table View Data
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [filesList count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    AnObject *curItem = [filesArray objectAtIndex:row];
    
    if (tableColumn == objectColumn) {
        return [curItem name];
    } else if (tableColumn == checkColumn) {
        return [NSNumber numberWithBool:[curItem checked]];
    } else {
        return nil;
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    AnObject *curItem = [filesArray objectAtIndex:row];
    
    if (tableColumn == checkColumn) {
        // Allows the ability to check the box.
        // It also sets the bool request value of the item.
        [curItem setChecked:[object boolValue]];
        
        NSIndexSet *rowIndexSet = [NSIndexSet indexSetWithIndex:row];
        NSArray *columnsArray = [objectTable tableColumns];
        NSInteger columnIndex = [columnsArray indexOfObject:objectColumn];
        
        NSIndexSet *columnIndexSet = [NSIndexSet indexSetWithIndex:columnIndex];
        
        [objectTable reloadDataForRowIndexes:rowIndexSet columnIndexes:columnIndexSet];
    }
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    // This is debug code, nothing vital
    if (tableColumn != objectColumn) 
        return;
    
    AnObject *curItem = [filesArray objectAtIndex:row];
    
    if ([curItem checked]) {
        // Debug code
    }
}
@end
