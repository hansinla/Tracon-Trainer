//
//  TTNavVOR.h
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/27/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

/*
    0: Row code for a VOR
    1: Latitude of VOR in decimal degrees
    2: Longitude of VOR in decimal degrees
    3: Elevation in feet above MSL
    4: Frequency in MHZ (multiplied by 100)
    5: Maximum reception range in nautical miles
    6: Slaved variation for VOR
    7: VOR identifier
    8: VOR name
 */

#import <Foundation/Foundation.h>

@interface TTNavVOR : NSObject

@property NSNumber *navType;
@property NSNumber *latitude;
@property NSNumber *longitude;
@property NSNumber *elevation;
@property NSNumber *frequency;
@property NSNumber *range;
@property NSNumber *variation;
@property NSString *identifier;
@property NSString *name;

@end
