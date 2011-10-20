//
//  Hackerspace_Status_NotifierAppDelegate.h
//  Hackerspace Status Notifier
//
//  Created by Vasileios Georgitzikis on 11/10/11.
//  Copyright 2011 Tzikis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>


@interface Status_NotifierAppDelegate : NSObject <NSApplicationDelegate, GrowlApplicationBridgeDelegate> {
	NSWindow *window;
	NSStatusItem* statusItem;
	IBOutlet NSMenu *menu;
	NSInteger status;
	NSString* URL;
	NSString* Title;
	NSString* OnTitle;
	NSString* OffTitle;
	BOOL disableMenu;
	BOOL disableNotifications;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, assign) NSInteger status;

-(void) checkStatus;
-(void) checkDefaults;
-(void) initMenu;
@end
