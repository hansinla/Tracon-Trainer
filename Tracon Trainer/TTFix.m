//
//  TTFix.m
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/29/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import "TTFix.h"

@implementation TTFix

@synthesize navType     = _navType;
@synthesize latitude    = _latitude;
@synthesize longitude   = _longitude;
@synthesize name        = _name;


-(NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@ Type: %@ Lat: %@ Long: %@", _name, _navType, _latitude, _longitude];
}

@end
