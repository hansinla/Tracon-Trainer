//
//  TTNavBeacon.h
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/27/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

/*
    0: Row code for a middle marker
    1: Latitude of marker in decimal degrees
    2: Longitude of marker in decimal degrees
    3: Elevation in feet above MSL
    4: Not used
    5: Not used
    6: Associated localiser bearing in true degrees
    7: Not used
    8: Airport ICAO code
    9: Associated runway number
    10: Name
 */

#import <Foundation/Foundation.h>

@interface TTNavBeacon : NSObject

@property NSNumber *navType;
@property NSNumber *latitude;
@property NSNumber *longitude;
@property NSNumber *elevation;
@property NSNumber *bearing;
@property NSString *airportCode;
@property NSString *runway;
@property NSString *name;

@end
