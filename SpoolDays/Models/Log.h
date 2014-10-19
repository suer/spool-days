//
//  Log.h
//  SpoolDays
//
//  Created by suer on 2014/10/19.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BaseDate;

@interface Log : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * event;
@property (nonatomic, retain) BaseDate *baseDate;

@end
