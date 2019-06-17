//
//  TTFlight.h
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/8/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTFlight : NSObject

@property NSString *airline;
@property NSString *flightNumber;
@property NSString *airportCode;
@property NSString *airportName;
@property NSString *timeString;
@property NSNumber *hour;
@property NSNumber *minute;

-(id)initWithAirline:(NSString *)line
        flightNumber:(NSString *)flNumber
         airportCode:(NSString *)apCode
         airportName:(NSString *)apName
          timeString:(NSString *)tmString
                hour:(NSNumber *)hour
              minute:(NSNumber *)min;

-(NSString *)description;


@end



