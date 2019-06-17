//
//  TTFileHandler.h
//  Tracon Trainer
//
//  Created by Hans van Riet on 10/8/13.
//  Copyright (c) 2013 Hans van Riet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTFileHandler : NSObject

-(void)openDataFiles;
-(NSMutableArray *)readScheduleFile:(NSURL *)theURL;
-(NSMutableArray *)readNavDataFile:(NSURL *)theURL;
-(NSMutableArray *)readFixDataFile:(NSURL *)theURL;



@end
