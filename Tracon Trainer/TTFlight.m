//
//  TTFlight.m
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/8/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import "TTFlight.h"

@implementation TTFlight

@synthesize airline         = _airline;
@synthesize flightNumber    = _flightNumber;
@synthesize airportCode     = _airportCode;
@synthesize airportName     = _airportName;
@synthesize timeString      = _timeString;
@synthesize hour            = _hour;
@synthesize minute          = _minute;

-(id)initWithAirline:(NSString *)line
        flightNumber:(NSString *)flNumber
         airportCode:(NSString *)apCode
         airportName:(NSString *)apName
          timeString:(NSString *)tmString
                hour:(NSNumber *)hr
              minute:(NSNumber *)min
{
    self = [super init];
    if (self)
    {
        [self setAirline:line];
        [self setFlightNumber:flNumber];
        [self setAirportCode:apCode];
        [self setAirportName:apName];
        [self setHour:hr];
        [self setMinute:min];
    }
    return self;
}



-(NSString *)description
{
    return [NSString stringWithFormat:@"Airline: %@ FlightNumber: %@ AirportCode: %@ AirportName: %@ Time: %@",
            _airline, _flightNumber, _airportCode, _airportName, _timeString];
}

@end
