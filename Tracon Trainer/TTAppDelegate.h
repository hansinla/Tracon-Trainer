//
//  TTAppDelegate.h
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/8/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TTAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property IBOutlet NSTextField *timeLabel;


-(void)showTime;

@end





