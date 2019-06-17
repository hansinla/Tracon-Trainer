//
//  TTNavDME.m
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/27/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import "TTNavDME.h"

@implementation TTNavDME


@synthesize navType     = _navType;
@synthesize latitude    = _latitude;
@synthesize longitude   = _longitude;
@synthesize elevation   = _elevation;
@synthesize frequency   = _frequency;
@synthesize range       = _range;
@synthesize bias        = _bias;
@synthesize identifier  = _identifier;
@synthesize airportCode = _airportCode;
@synthesize runway      = _runway;
@synthesize name    = _name;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@ Type: %@ Lat: %@ Long: %@ Ident: %@",
            _name, _navType, _latitude, _longitude, _identifier];
}



@end
