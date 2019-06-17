//
//  TTNavItem.h
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/27/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

/*
 0: Row code for an NDB
 1: Latitude of NDB in decimal degrees
 2: Longitude of NDB in decimal degrees
 3: Elevation in feet above MSL
 4: Frequency in KHz
 5: Maximum reception range in nautical miles
 6: Not used for NDBs
 7: NDB identifier
 8: NDB name
 */

#import <Foundation/Foundation.h>

@interface TTNavNDB : NSObject

@property NSNumber *navType;
@property NSNumber *latitude;
@property NSNumber *longitude;
@property NSNumber *elevation;
@property NSNumber *frequency;
@property NSNumber *range;
@property NSString *identifier;
@property NSString *name;

@end
