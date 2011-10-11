//
//  Hackerspace_Status_NotifierAppDelegate.h
//  Hackerspace Status Notifier
//
//  Created by Vasileios Georgitzikis on 11/10/11.
//  Copyright 2011 Tzikis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Hackerspace_Status_NotifierAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	NSStatusItem* statusItem;
	IBOutlet NSMenu *menu;
	NSInteger status;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, assign) NSInteger status;

-(void) check;
@end
