//
//  TTNavVOR.m
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/27/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import "TTNavVOR.h"


@implementation TTNavVOR

@synthesize navType         = _navType;
@synthesize latitude        = _latitude;
@synthesize longitude       = _longitude;
@synthesize elevation       = _elevation;
@synthesize frequency       = _frequency;
@synthesize range           = _range;
@synthesize variation       = _variation;
@synthesize identifier      = _identifier;
@synthesize name            = _name;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@ Ident: %@ Type: %@ Lat: %@ Long: %@ Elev: %@",
            _name, _identifier, _navType, _latitude, _longitude, _elevation];
}


@end
