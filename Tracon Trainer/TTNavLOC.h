//
//  TTNavLoc.h
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/27/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//


/*
 0: Row code for a localizer associated with an ILS
 1: Latitude of localiser in decimal degrees
 2: Longitude of localiser in decimal degrees
 3: Elevation in feet above MSL
 4: Frequency in MHZ (multiplied by 100)
 5: Maximum reception range in nautical miles
 6: Localiser bearing in true degrees
 7: Localiser identifier
 8: Airport ICAO code
 9: Associated runway number
 10: Localiser name
 */

#import <Foundation/Foundation.h>

@interface TTNavLOC : NSObject

@property NSNumber *navType;
@property NSNumber *latitude;
@property NSNumber *longitude;
@property NSNumber *elevation;
@property NSNumber *frequency;
@property NSNumber *range;
@property NSNumber *bearing;
@property NSString *identifier;
@property NSString *airportCode;
@property NSString *runway;
@property NSString *name;

@end
