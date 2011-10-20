//
//  Hackerspace_Status_NotifierAppDelegate.m
//  Hackerspace Status Notifier
//
//  Created by Vasileios Georgitzikis on 11/10/11.
//  Copyright 2011 Tzikis. All rights reserved.
//

#import "Status_NotifierAppDelegate.h"

@implementation Status_NotifierAppDelegate

@synthesize window;
@synthesize status;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	[self checkDefaults];

	[self initMenu];
	
	[GrowlApplicationBridge setGrowlDelegate:self];
	
	//send the apropriate growl notification
	[GrowlApplicationBridge notifyWithTitle: Title
								description: @"Started"
						   notificationName: @"starting"
								   iconData: nil
								   priority: 0
								   isSticky: NO
							   clickContext:nil
								 identifier:@"status changed"];

	//run the listener to the new thread
	[NSThread detachNewThreadSelector:@selector(checkStatus)
							 toTarget:self
						   withObject:nil];

}

//starts the listener and blocks the current thread, waiting for events
-(void) checkStatus
{
	//the new thread needs to have its own autorelease pool
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	status=-1;
	NSInteger oldStatus = -1;
	NSLog(@"%ld", status);
	
	NSString* ok_path = [[NSBundle mainBundle] pathForResource:@"status_ok" ofType:@"png"];
	NSImage *ok = [[NSImage alloc] initWithContentsOfFile:ok_path];
	
	NSString* not_ok_path = [[NSBundle mainBundle] pathForResource:@"status_not_ok" ofType:@"png"];
	NSImage *not_ok = [[NSImage alloc] initWithContentsOfFile:not_ok_path];

	while(true)
	{
		NSMutableString *urlString = [NSMutableString stringWithString:URL];
							   
	   // append a "?2345" where 2345 is actually a random number; forces
	   // proxy servers to fetch a fresh version of the file.
	   [urlString appendString:@"?"];
	   [urlString appendString:[[NSNumber numberWithLong:random()] stringValue]];

		NSError* error = nil;
		NSString* contents = [NSString stringWithContentsOfURL: [NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
		
//		NSLog(@"Contents:\n%@", contents);
		self.status = [contents integerValue];
		
		if(error != nil)
		{
			NSLog(@"Could not connect to URL");
			sleep(10);
			continue;
		}
		else if(status != 1 && status != 0)
		{
			NSLog(@"Status is invalid: %ld", status);
			sleep(10);
			continue;
			
		}
		
		if(oldStatus != status)
		{
			NSLog(@"New status: %ld", status);
			if(statusItem != nil)
			{
				[[statusItem image] release];
				status == 1 ? [statusItem setImage:ok] : [statusItem setImage:not_ok];
			}
			
			if(!disableNotifications)
			{
				[GrowlApplicationBridge notifyWithTitle: Title
											description: status == 1? OnTitle : OffTitle
									   notificationName: status == 1? @"status on" : @"status off"
											   iconData: nil
											   priority: 0
											   isSticky: NO
										   clickContext:nil
											 identifier:@"status changed"];
			}
			
		}
		oldStatus = status;

		sleep(10);
	}
	[pool release];

}

-(void) checkDefaults
{
	
	URL = [[NSUserDefaults standardUserDefaults] stringForKey:@"URL"];
	if(URL == nil)
		URL = @"http://p-space.gr/status/";
	
	Title = [[NSUserDefaults standardUserDefaults] stringForKey:@"Title"];
	if(Title == nil)
		Title = @"Hackerspace Status Notifier";
	
	OnTitle = [[NSUserDefaults standardUserDefaults] stringForKey:@"OnTitle"];
	if(OnTitle == nil)
		OnTitle = @"Hackerspace Open";

		OffTitle = [[NSUserDefaults standardUserDefaults] stringForKey:@"OffTitle"];
	if(OffTitle == nil)
		OffTitle = @"Hackerspace Closed";
	
	disableMenu = [[NSUserDefaults standardUserDefaults] boolForKey:@"DisableMenu"];
	disableNotifications = [[NSUserDefaults standardUserDefaults] boolForKey:@"DisableNotifications"];
	
}

-(void) initMenu
{
	if(!disableMenu)
	{
		statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
		[statusItem setMenu:menu];
		
		NSString* icon_path = [[NSBundle mainBundle] pathForResource:@"status_unknown" ofType:@"png"];
		NSImage *icon = [[NSImage alloc] initWithContentsOfFile:icon_path];
		
		[statusItem setImage:icon];
		[icon release];
		
		[statusItem setHighlightMode:YES];
	}
	else
		statusItem = nil;
}
@end
