//
//  RadarView.h
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/20/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RadarView : NSView

-(void)drawNDB:(CGContextRef)context atPosition:(NSPoint)pos withLabel:(NSString *)identifier;
-(void)drawVOR:(CGContextRef)context atPosition:(NSPoint)pos;
-(void)drawLOC:(CGContextRef)context atPosition:(NSPoint)pos withBearing:(double)bearing;
-(void)drawDME:(CGContextRef)context atPosition:(NSPoint)pos;
-(void)drawLabel:(CGContextRef)context atPosition:(NSPoint)pos withString:(NSString *)string;
-(void)drawFIX:(CGContextRef)context atPosition:(NSPoint)pos;

@end
