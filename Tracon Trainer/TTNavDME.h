//
//  TTNavDME.h
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/27/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

/*
    0: Row code for a DME
    1: Latitude of DME in decimal degrees
    2: Longitude of DME in decimal degrees
    3: Elevation in feet above MSL
    4: Frequency in MHZ (multiplied by 100)
    5: Minimum reception range in nautical miles
    6: DME bias in nautical miles.
    7: Identifier
    8: Airport ICAO code (for DMEs associated with an ILS)
    9: Associated runway number (for DMEs associated with an ILS)
    10: DME name (all DMEs)
 */

#import <Foundation/Foundation.h>

@interface TTNavDME : NSObject

@property NSNumber *navType;
@property NSNumber *latitude;
@property NSNumber *longitude;
@property NSNumber *elevation;
@property NSNumber *frequency;
@property NSNumber *range;
@property NSNumber *bias;
@property NSString *identifier;
@property NSString *airportCode;
@property NSString *runway;
@property NSString *name;


@end
