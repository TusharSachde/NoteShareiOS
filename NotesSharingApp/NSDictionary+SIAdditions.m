//
//  NSDictionary+Utility.m
//  ICEBKScouting
//
//  Created by Naveen Aranha on 11/12/12.
//  Copyright (c) 2012 Naveen Aranha. All rights reserved.
//

#import "NSDictionary+SIAdditions.h"

@implementation NSDictionary (SIAdditions)
- (id)si_objectOrNilForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


@end
