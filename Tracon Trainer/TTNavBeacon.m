//
//  TTNavBeacon.m
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/27/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import "TTNavBeacon.h"

@implementation TTNavBeacon

@synthesize navType     = _navType;
@synthesize latitude    = _latitude;
@synthesize longitude   = _longitude;
@synthesize elevation   = _elevation;
@synthesize bearing     = _bearing;
@synthesize airportCode = _airportCode;
@synthesize runway      = _runway;
@synthesize name        = _name;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@ Type: %@ Lat: %@ Long: %@ Runway: %@",
            _name, _navType, _latitude, _longitude, _runway];
}


@end
