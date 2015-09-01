//
//  NSArray+BoundsException.m
//  F1Centre
//
//  Created by Naveen Aranha on 21/02/13.
//
//

#import "NSArray+SIAdditions.h"

@implementation NSArray (SIAdditions)
- (id)si_objectOrNilAtIndex:(NSUInteger)index
{
    if (index>=self.count) return nil;
    id object = [self objectAtIndex:index];
    
    return [object isEqual:[NSNull null]] ? nil : object;
}
@end
