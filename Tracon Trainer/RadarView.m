//
//  RadarView.m
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/20/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import <math.h>
#import "RadarView.h"
#import "GlobalVariables.h"
#import "TTNavDME.h"
#import "TTNavBeacon.h"
#import "TTNavGS.h"
#import "TTNavLOC.h"
#import "TTNavVOR.h"
#import "TTNavNDB.h"

#define TARGET_SIZE  8.0
#define TARGET_SIZE_2 4.0
#define MAGNETIC_VARIATION -14 // 14 degrees East
#define WIND_DIRECTION 200


@implementation RadarView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
	
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:rect];
    
    // Draw a range circle
    CGFloat circleSize = MIN(rect.size.height, rect.size.width)-4;
    NSRect  circleBox = NSMakeRect(MAX(rect.size.width - circleSize, 0)/2, 2, circleSize, circleSize);
    [[NSColor greenColor] set];
    
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    [thePath appendBezierPathWithOvalInRect:circleBox];
    [thePath stroke];
    
    // Get the graphics context
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    if (areaNavData != nil){
        double xAxisFactor = 900 / (lonMax - lonMin);
        double yAxisFactor = 720 / (latMax - latMin);

        for (id object in areaNavData)
        {
            //NSLog(@"iterating over areaNavData. ObjectType: %@", [object navType]);
            double xCoord = ([[object longitude] doubleValue] - lonMin) * xAxisFactor;
            double yCoord = ([[object latitude] doubleValue] - latMin) * yAxisFactor;
            NSPoint   pos = NSMakePoint(xCoord, yCoord);
            if ([[object navType] intValue] == 2)  // Nav item is a NDB -> draw NDB
            {
                [self drawNDB:context atPosition:pos withLabel:[object identifier]];
                pos.x = pos.x - 10;
                pos.y = pos.y + 10;
                [self drawLabel:context atPosition:pos withString:[object identifier]];
            }
            else if ([[object navType] intValue] == 3) // Nav item is a VOR -> draw VOR
            {
                [self drawVOR:context atPosition:pos];
                pos.x = pos.x - 10;
                pos.y = pos.y + 10;
                [self drawLabel:context atPosition:pos withString:[object identifier]];

            }
            else if (([[object navType] intValue] == 4) || ([[object navType] intValue] == 5)) // LOC
            {
                if ([[object bearing] doubleValue] > WIND_DIRECTION - 90 &&
                    [[object bearing] doubleValue] < WIND_DIRECTION + 90)
                {
                    [self drawLOC:context
                       atPosition:pos
                      withBearing:[[object bearing] doubleValue]];
                    if ([[object runway] rangeOfString:@"L"].location != NSNotFound)
                    {
                        pos.x = pos.x - 10;
                        pos.y = pos.y - 15;
                    }
                    if ([[object runway] rangeOfString:@"R"].location != NSNotFound)
                    {
                        //pos.x = pos.x + 5;
                        pos.y = pos.y + 15;
                    }
                    [self drawLabel:context atPosition:pos withString:[object runway]];
                }
            }
            else if (([[object navType] intValue] == 12) || ([[object navType] intValue] == 13)) // DME
            {
                //[self drawDME:context atPosition:pos];
            }
            else if ([[object navType] intValue] == 0)
            {
                [self drawFIX:context atPosition:pos];
            }
        }
    }
}

-(void)drawNDB:(CGContextRef)context atPosition:(NSPoint)pos withLabel:(NSString *)identifier
{
    // Draw a range circle
    NSRect  circleBox = NSMakeRect(pos.x, pos.y, TARGET_SIZE, TARGET_SIZE );
    [[NSColor yellowColor] set];        // YELLOW
    
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    [thePath appendBezierPathWithOvalInRect:circleBox];
    [thePath stroke];
}

-(void)drawVOR:(CGContextRef)context atPosition:(NSPoint)pos
{
    CGContextSaveGState(context);
    
    CGContextSetRGBStrokeColor (context, 1.0, 0.51, 0.0, 1.0); //AMBER
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);    // DRAW BOX
    CGContextMoveToPoint(context, pos.x, pos.y);
    CGContextAddLineToPoint(context, pos.x + TARGET_SIZE, pos.y);
    CGContextAddLineToPoint(context, pos.x + TARGET_SIZE, pos.y + TARGET_SIZE);
    CGContextAddLineToPoint(context, pos.x, pos.y + TARGET_SIZE);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}

-(void)drawLOC:(CGContextRef)context atPosition:(NSPoint)pos withBearing:(double) bearing
{
    
    CGContextSaveGState(context);
    
    CGContextSetRGBStrokeColor (context, 0.0, 1.0, 0.0, 1.0); //GREEN
    CGContextSetLineWidth(context, 1.0);

    CGContextTranslateCTM(context, pos.x, pos.y);
    double radians = ((180 - bearing - MAGNETIC_VARIATION) * M_PI) / 180;
    CGContextRotateCTM(context, radians);
    
    CGContextBeginPath(context);    // DRAW LOC
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, - TARGET_SIZE_2,  (6 * TARGET_SIZE_2));
    CGContextAddLineToPoint(context, 0, 5 * TARGET_SIZE_2);
    CGContextAddLineToPoint(context, TARGET_SIZE_2,  6 * TARGET_SIZE_2);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);

    
    CGContextRestoreGState(context);

}

-(void)drawFIX:(CGContextRef)context atPosition:(NSPoint)pos
{
    CGContextSaveGState(context);
    
    CGContextSetRGBStrokeColor (context, 0.0, 0.5, 1.0, .4); // ORANGE
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);    // DRAW FIX
    CGContextMoveToPoint(context, pos.x, pos.y);
    CGContextAddLineToPoint(context, pos.x + TARGET_SIZE,  pos.y);
    CGContextAddLineToPoint(context, pos.x + TARGET_SIZE_2, pos.y + TARGET_SIZE);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}

-(void)drawDME:(CGContextRef)context atPosition:(NSPoint)pos
{
    CGContextSaveGState(context);
    
    CGContextSetRGBStrokeColor (context, 1.0, 0.51, 0.0, 1.0); //AMBER
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);    // DRAW DME
    CGContextMoveToPoint(context, pos.x + (TARGET_SIZE_2 / 2), pos.y);
    CGContextAddLineToPoint(context, pos.x + TARGET_SIZE - (TARGET_SIZE_2 / 2), pos.y);
    CGContextAddLineToPoint(context, pos.x + TARGET_SIZE, pos.y + (TARGET_SIZE_2 / 2));
    CGContextAddLineToPoint(context, pos.x + TARGET_SIZE, pos.y +  TARGET_SIZE - (TARGET_SIZE_2 / 2));
    CGContextAddLineToPoint(context, pos.x + TARGET_SIZE - (TARGET_SIZE_2 / 2), pos.y + TARGET_SIZE);
    CGContextAddLineToPoint(context, pos.x + (TARGET_SIZE_2 / 2), pos.y + TARGET_SIZE);
    CGContextAddLineToPoint(context, pos.x, pos.y + TARGET_SIZE - (TARGET_SIZE_2 / 2));
    CGContextAddLineToPoint(context, pos.x, pos.y + (TARGET_SIZE_2 / 2));
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}


-(void)drawLabel:(CGContextRef)context atPosition:(NSPoint)pos withString:(NSString *)string
{
    NSColor *whiteColor= [NSColor colorWithCalibratedWhite:1.0 alpha:1.0];
    NSMutableDictionary *fontDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:whiteColor, NSForegroundColorAttributeName, nil];
    //NSPoint offsetPoint = NSMakePoint(pos.x, pos.y);
    [string drawAtPoint:pos withAttributes:fontDict];
}


@end
