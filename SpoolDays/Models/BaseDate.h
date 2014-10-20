#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Log;

@interface BaseDate : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSSet *logs;
@end

@interface BaseDate (CoreDataGeneratedAccessors)

- (void)addLogsObject:(Log *)value;
- (void)removeLogsObject:(Log *)value;
- (void)addLogs:(NSSet *)values;
- (void)removeLogs:(NSSet *)values;

@end
