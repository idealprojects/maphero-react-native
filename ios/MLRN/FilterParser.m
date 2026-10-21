#import "FilterParser.h"
#import <MapHero/MapHero.h>

@implementation FilterParser

+ (NSPredicate*)parse:(NSArray *)filterList
{
    if (filterList == nil || filterList.count < 1) {
        return nil;
    }
    return [NSPredicate predicateWithMHJSONObject:filterList];
}

@end
