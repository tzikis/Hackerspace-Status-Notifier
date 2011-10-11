//
//  Hackerspace_Status_NotifierAppDelegate.m
//  Hackerspace Status Notifier
//
//  Created by Vasileios Georgitzikis on 11/10/11.
//  Copyright 2011 Tzikis. All rights reserved.
//

#import "Hackerspace_Status_NotifierAppDelegate.h"

@implementation Hackerspace_Status_NotifierAppDelegate

@synthesize window;
@synthesize status;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setMenu:menu];
	
	NSString* icon_path = [[NSBundle mainBundle] pathForResource:@"status_unknown" ofType:@"png"];
	NSImage *icon = [[NSImage alloc] initWithContentsOfFile:icon_path];
	
	[statusItem setImage:icon];
	[icon release];
	
	[statusItem setHighlightMode:YES];

	//run the listener to the new thread
	[NSThread detachNewThreadSelector:@selector(check)
							 toTarget:self
						   withObject:nil];
}

//starts the listener and blocks the current thread, waiting for events
-(void) check
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
		NSMutableString *urlString = [NSMutableString stringWithString:@"http://p-space.gr/status/"];
							   
	   // append a "?2345" where 2345 is actually a random number; forces
	   // proxy servers to fetch a fresh version of the file.
	   [urlString appendString:@"?"];
	   [urlString appendString:[[NSNumber numberWithLong:random()] stringValue]];

		NSString* contents = [NSString stringWithContentsOfURL: [NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
//		NSLog(@"Contents:\n%@", contents);
		self.status = [contents integerValue];
		
		if(oldStatus != status)
		{
			NSLog(@"New status: %ld", status);
			[[statusItem image] release];
			if(status == 1)
				[statusItem setImage:ok];
			else
				[statusItem setImage:not_ok];
			
		}
		oldStatus = status;

		sleep(10);
	}
	[pool release];

}

@end
