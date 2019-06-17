//
//  TTAppDelegate.m
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/8/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import "TTAppDelegate.h"
#import "TTFlight.h"
#import "TTFileHandler.h"

@implementation TTAppDelegate

#define TIME_INTERVAL  1.0

NSDateFormatter *formatter;


#pragma mark - Application Lifecycle
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

-(void)awakeFromNib {
    
    TTFileHandler *aHandler = [[TTFileHandler alloc]init];
    [aHandler openDataFiles];
    
    NSTimer *updateTimer __attribute__((unused)) = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL
                                                                                    target:self
                                                                                  selector:@selector(showTime)
                                                                                  userInfo:nil
                                                                                   repeats:YES];
}

-(void)showTime {
    
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    

    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    [_timeLabel setStringValue:dateString];
}





@end
