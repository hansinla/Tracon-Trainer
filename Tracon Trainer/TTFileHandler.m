//
//  TTFileHandler.m
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/8/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import "GlobalVariables.h"
#import "TTFileHandler.h"
#import "TTFlight.h"
#import "TTNavNDB.h"
#import "TTNavVOR.h"
#import "TTNavLOC.h"
#import "TTNavGS.h"
#import "TTNavBeacon.h"
#import "TTNavDME.h"
#import "TTFix.h"


@implementation TTFileHandler

NSMutableArray *arrivalsSchedule;
NSMutableArray *departuresSchedule;

NSMutableArray *navData;
NSMutableArray *fixData;
NSMutableArray *allNavData;

-(void)openDataFiles
{
    // Load arrivals file
    if (arrivalsSchedule == nil)
    {
        arrivalsSchedule = [[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LAX_ARRIVALS" ofType:@"txt"];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        arrivalsSchedule = [self readScheduleFile:fileURL];
        //NSLog(@"arrivalsSchedule: %@", arrivalsSchedule);
        NSLog(@"arrivalsSchedule loaded");
    }
    
    // Load arrivals file
    if (departuresSchedule == nil)
    {
        departuresSchedule = [[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LAX_DEPARTURES" ofType:@"txt"];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        departuresSchedule = [self readScheduleFile:fileURL];
        NSLog(@"departuresSchedule loaded");
    }
    
    // Load navigation data
    if (navData == nil)
    {
        navData = [[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"earth_nav" ofType:@"dat"];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        navData = [self readNavDataFile:fileURL];
        NSLog(@"navData loaded");
        
        fixData = [[NSMutableArray alloc]init];
        NSString *fixPath = [[NSBundle mainBundle] pathForResource:@"earth_fix" ofType:@"dat"];
        NSURL *fixURL = [NSURL fileURLWithPath:fixPath];
        fixData = [self readFixDataFile:fixURL];
        NSLog(@"fixData loaded");
        
        
        
        areaNavData = [[NSMutableArray alloc]init];
        for (NSMutableArray *array in navData)
        {
            for (id object in array)
            {
                if ([[object latitude] doubleValue]     > latMin &&
                    [[object latitude] doubleValue]     < latMax &&
                    [[object longitude] doubleValue]    > lonMin &&
                    [[object longitude] doubleValue]    < lonMax)
                    {
                        [areaNavData addObject:object];
                    }
            }
        }
        
        for (id object in fixData)
        {
            
                if ([[object latitude] doubleValue]     > latMin &&
                    [[object latitude] doubleValue]     < latMax &&
                    [[object longitude] doubleValue]    > lonMin &&
                    [[object longitude] doubleValue]    < lonMax)
                {
                    [areaNavData addObject:object];
                }

        }
        NSLog(@"Area Nav data loaded: %lu", [areaNavData count]);
    }
}

-(NSMutableArray *)readFixDataFile:(NSURL *)theURL
{
    NSError *error;
    // Read in a file as a string with error checking
    NSString *fixDataFileString = [NSString stringWithContentsOfURL:theURL
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];
    if (!fixDataFileString)
    {
        NSLog(@"Error reading file: %@", error);
        return NULL;
    }
    
    NSMutableArray *fixArray    = [[NSMutableArray alloc]init];

    
    // Break the raw file string (navDataFileString) into lines
    NSArray *rawFixDataArray = [fixDataFileString componentsSeparatedByString:@"\n"];
    
    // Skip the first three lines; these are header lines
    NSRange range = NSMakeRange( 3, [rawFixDataArray count]-3);
    NSArray *fixDataArray = [rawFixDataArray subarrayWithRange:range];
    
    for (NSString *fixData in fixDataArray)
    {
        TTFix *aFIX = [[TTFix alloc]init];
        
        // Break the line into components
        NSMutableString *tempString;
        NSScanner *scanner = [NSScanner scannerWithString:fixData];
        
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
        [aFIX setNavType:(NSNumber *)@"0"];
        [aFIX setLatitude: (NSNumber *)tempString];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
        [aFIX setLongitude:(NSNumber *)tempString];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@""]
                                intoString:&tempString];
        [aFIX setName: tempString];
        
        [fixArray addObject:aFIX];
    }
    NSLog(@"Fix data loaded: %lu items.", [fixArray count]);
    return fixArray;
}

-(NSMutableArray *)readNavDataFile:(NSURL *)theURL
{
    NSError *error;
        // Read in a file as a string with error checking
    NSString *navDataFileString = [NSString stringWithContentsOfURL:theURL
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
    if (!navDataFileString)
    {
        NSLog(@"Error reading file: %@", error);
        return NULL;
    }
    
    NSMutableArray *NDBArray    = [[NSMutableArray alloc]init];
    NSMutableArray *VORArray    = [[NSMutableArray alloc]init];
    NSMutableArray *LOCArray    = [[NSMutableArray alloc]init];
    NSMutableArray *GSArray     = [[NSMutableArray alloc]init];
    NSMutableArray *BeaconArray = [[NSMutableArray alloc]init];
    NSMutableArray *DMEArray    = [[NSMutableArray alloc]init];
   
    // Break the raw file string (navDataFileString) into lines
    NSArray *rawNavDataArray = [navDataFileString componentsSeparatedByString:@"\n"];
    
    // Skip the first three lines; these are header lines
    NSRange range = NSMakeRange( 3, [rawNavDataArray count]-3);
    NSArray *navDataArray = [rawNavDataArray subarrayWithRange:range];
    
    // Iterate over the items in navDataArray
    for (NSString *navData in navDataArray)
    {
        // Break the flight line into components
        NSMutableString *tempString;
        NSScanner *scanner = [NSScanner scannerWithString:navData];
        
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
        
        if ([tempString isEqualToString:@"2"]) // Nav item is a NDB; create NDB object
        {
            TTNavNDB *aNDB = [[TTNavNDB alloc]init];

            // Set the invars for the NDB object
            // 0: Row code for an NDB
            [aNDB setNavType:      (NSNumber *)tempString];
            
            // 1: Latitude of NDB in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aNDB setLatitude: (NSNumber *)tempString];
            
            // 2: Longitude of NDB in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aNDB setLongitude: (NSNumber *)tempString];
            
            // 3: Elevation in feet above MSL
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aNDB setElevation: (NSNumber *)tempString];
            
            // 4: Frequency in KHz
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aNDB setFrequency: (NSNumber *)tempString];
            
            // 5: Maximum reception range in nautical miles
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aNDB setRange:     (NSNumber *)tempString];
            
            // 6: Not used for NDBs
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            
            // 7: NDB identifier
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aNDB setIdentifier: tempString];
            
            // 8: NDB name
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@""]
                                    intoString:&tempString];
            [aNDB setName: tempString];

            [NDBArray addObject:aNDB];

        }
        
        if ([tempString isEqualToString:@"3"]) // Nav item is a VOR; create VOR object
        {
            TTNavVOR *aVOR = [[TTNavVOR alloc]init];
            
            // Set the invars for the VOR object
            // 0: Row code for a VOR
            [aVOR setNavType: (NSNumber *)tempString];
            
            // 1: Latitude of VOR in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aVOR setLatitude: (NSNumber *)tempString];
            
            // 2: Longitude of VOR in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aVOR setLongitude: (NSNumber *)tempString];
            
            // 3: Elevation in feet above MSL
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aVOR setElevation: (NSNumber *)tempString];
            
            // 4: Frequency in MHZ (multiplied by 100)
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aVOR setFrequency: (NSNumber *)tempString];
            
            // 5: Maximum reception range in nautical miles
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aVOR setRange:     (NSNumber *)tempString];
            
            // 6: Slaved variation for VOR
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aVOR setVariation: (NSNumber *)tempString];
            
            // 7: VOR identifier
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aVOR setIdentifier: tempString];
            
            
            // 8: VOR name
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@""]
                                    intoString:&tempString];
            [aVOR setName: tempString];
            
            [VORArray addObject:aVOR];
            
        }
        
        if ([tempString isEqualToString:@"4"]
            || [tempString isEqualToString:@"5"]) // Nav item is a LOC
        {
            TTNavLOC *aLOC = [[TTNavLOC alloc]init];
            
            // Set the invars for the VOR object
            // 0: Row code for a localizer associated with an ILS
            [aLOC setNavType: (NSNumber *)tempString];
            
            // 1: Latitude of localiser in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aLOC setLatitude: (NSNumber *)tempString];
            
            // 2: Longitude of localiser in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aLOC setLongitude: (NSNumber *)tempString];
            
            
            // 3: Elevation in feet above MSL
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aLOC setElevation: (NSNumber *)tempString];
            
            
            // 4: Frequency in MHZ (multiplied by 100)
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aLOC setFrequency: (NSNumber *)tempString];
            
            
            // 5: Maximum reception range in nautical miles
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aLOC setRange: (NSNumber *)tempString];
            
            
            //6: Localiser bearing in true degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aLOC setBearing: (NSNumber *)tempString];
            
            // 7: Localiser identifier
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aLOC setIdentifier:tempString];
            
            // 8: Airport ICAO code
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aLOC setAirportCode:tempString];
            
            // 9: Associated runway number
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aLOC setRunway:tempString];
            
            // 10: Localiser name
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@""]
                                    intoString:&tempString];
            [aLOC setName:tempString];

            [LOCArray addObject:aLOC];
            
        }
        
        if ([tempString isEqualToString:@"6"]) // Nav item is a GS
        {
            TTNavGS *aGS = [[TTNavGS alloc]init];
            
            // Set the invars for the VOR object
            // 0: Row code for a localizer associated with an ILS
            [aGS setNavType: (NSNumber *)tempString];
            
            // 1: Latitude of localiser in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aGS setLatitude: (NSNumber *)tempString];
            
            // 2: Longitude of localiser in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aGS setLongitude: (NSNumber *)tempString];
            
            
            // 3: Elevation in feet above MSL
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aGS setElevation: (NSNumber *)tempString];
            
            
            // 4: Frequency in MHZ (multiplied by 100)
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aGS setFrequency: (NSNumber *)tempString];
            
            
            // 5: Maximum reception range in nautical miles
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aGS setRange: (NSNumber *)tempString];
            
            
            //  6: Associated localiser bearing in true degrees prefixed by glideslope angle
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aGS setGsAngleAndBearing: (NSNumber *)tempString];
            
            // 7: Localiser identifier
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aGS setIdentifier:tempString];
            
            // 8: Airport ICAO code
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aGS setAirportCode:tempString];
            
            // 9: Associated runway number
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aGS setRunway:tempString];
            
            // 10: Localiser name
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@""]
                                    intoString:&tempString];
            [aGS setName:tempString];
            
            [GSArray addObject:aGS];
            
        }
        
        if ([tempString isEqualToString:@"7"]
            || [tempString isEqualToString:@"8"]
            || [tempString isEqualToString:@"9"]) // Nav item is a Marker Beacon
        {
            TTNavBeacon *aBeacon = [[TTNavBeacon alloc]init];
            
            // Set the invars for the VOR object
            // 0: Row code for a localizer associated with an ILS
            [aBeacon setNavType: (NSNumber *)tempString];
            
            // 1: Latitude of localiser in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aBeacon setLatitude: (NSNumber *)tempString];
            
            // 2: Longitude of localiser in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aBeacon setLongitude: (NSNumber *)tempString];
            
            // 3: Elevation in feet above MSL
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aBeacon setElevation: (NSNumber *)tempString];
            
            // 4: Not used
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
                        
            // 5: Not used
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            
            // 6: Associated localiser bearing in true degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aBeacon setBearing: (NSNumber *)tempString];
            
            // 7: Not used
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            
            // 8: Airport ICAO code
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aBeacon setAirportCode:tempString];
            
            // 9: Associated runway number
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aBeacon setRunway:tempString];
            
            // 10: Localiser name
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@""]
                                    intoString:&tempString];
            [aBeacon setName:tempString];
            
            [BeaconArray addObject:aBeacon];
            
        }
        
        if ([tempString isEqualToString:@"12"]
            || [tempString isEqualToString:@"13"]) // Nav item is a DME
        {
            TTNavDME *aDME = [[TTNavDME alloc]init];
            
            // Set the invars for the VOR object
            // 0: Row code for a DME
            [aDME setNavType: (NSNumber *)tempString];
            
            // 1: Latitude of DME in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aDME setLatitude: (NSNumber *)tempString];
            
            // 2: Longitude of DME in decimal degrees
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aDME setLongitude: (NSNumber *)tempString];
            
            
            // 3: Elevation in feet above MSL
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aDME setElevation: (NSNumber *)tempString];
            
            
            // 4: Frequency in MHZ (multiplied by 100)
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aDME setFrequency: (NSNumber *)tempString];
            
            
            // 5: Minimum reception range in nautical miles
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aDME setRange: (NSNumber *)tempString];
            
            
            // 6: DME bias in nautical miles
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aDME setBias: (NSNumber *)tempString];
            
            // 7: Identifier
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aDME setIdentifier:tempString];
            
            // 8: Airport ICAO code (for DMEs associated with an ILS)
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aDME setAirportCode:tempString];
            
            // 9: Associated runway number (for DMEs associated with an ILS)
            [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&tempString];
            [aDME setRunway:tempString];
            
            // 10: DME name (all DMEs)
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@""]
                                    intoString:&tempString];
            [aDME setName:tempString];
            
            [DMEArray addObject:aDME];
            
        }
        

    }
    if (allNavData == nil)
    {
        allNavData  = [[NSMutableArray alloc] init];
    }
    [allNavData addObject:NDBArray];
    NSLog(@"NDB data loaded: %lu items.", (unsigned long)[[allNavData objectAtIndex:0] count]);
    [allNavData addObject:VORArray];
    NSLog(@"VOR data loaded: %lu items.", (unsigned long)[[allNavData objectAtIndex:1] count]);
    [allNavData addObject:LOCArray];
    NSLog(@"LOC data loaded: %lu items.", (unsigned long)[[allNavData objectAtIndex:2] count]);
    [allNavData addObject:GSArray];
    NSLog(@"GS data loaded: %lu items.", (unsigned long)[[allNavData objectAtIndex:3] count]);
    [allNavData addObject:BeaconArray];
    NSLog(@"Marker Beacon data loaded: %lu items.", (unsigned long)[[allNavData objectAtIndex:4] count]);
    [allNavData addObject:DMEArray];
    NSLog(@"DME data loaded: %lu items.", (unsigned long)[[allNavData objectAtIndex:5] count]);
    
    return allNavData;
}



-(NSMutableArray *)readScheduleFile:(NSURL *)theURL
{
    NSError *error;
    
    // Read in a file as a string w/ith error checking
    NSString *flightSchedule = [NSString stringWithContentsOfURL:theURL
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
    if (!flightSchedule)
    {
        NSLog(@"Error reading file: %@", error);
        return NULL;
    }
    
    NSMutableArray *flightArray = [[NSMutableArray alloc] init];
    NSArray *flight  = [[NSMutableArray alloc] init];
    NSArray *time    = [[NSMutableArray alloc] init];
    
    
    // Setup a number formatter to convert time string into Hour and Minute components
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // Break the raw file string (flightSchedule) into lines
    NSArray *flights = [flightSchedule componentsSeparatedByString:@"\n"];
    
    
    // Iterate over the lines in flightschedule
    for (NSString *rawFlight in flights)
    {
        // Break the flight line into components
        flight   = [rawFlight componentsSeparatedByString:@","];
        
        // Create a new TTFlight Object and initialize
        TTFlight *aFlight = [[TTFlight alloc]init];
        
        // Set the variables for the TTFlight object
        [aFlight setAirline:[flight objectAtIndex:0]];
        [aFlight setFlightNumber:[flight objectAtIndex:1]];
        [aFlight setAirportCode:[flight objectAtIndex:2]];
        [aFlight setAirportName:[flight objectAtIndex:3]];
        [aFlight setTimeString:[flight objectAtIndex:4]];
        
        // Break the time string into components
        time = [[flight objectAtIndex:4] componentsSeparatedByString:@":"];
        
        //Convert the time string into an integer
        [aFlight setHour:[numFormatter numberFromString:[time objectAtIndex:0]]];
        [aFlight setMinute:[numFormatter numberFromString:[time objectAtIndex:1]]];
        
        // NSLog(@"loading flight: %@", aFlight);
        [flightArray addObject:aFlight];
    }
    
    return flightArray;

}



@end
