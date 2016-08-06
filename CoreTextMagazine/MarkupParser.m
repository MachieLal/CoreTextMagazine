//
//  MarkupParser.m
//  CoreTextMagazine
//
//  Created by Swarup_Pattnaik on 06/08/16.
//  Copyright © 2016 Swarup_Pattnaik. All rights reserved.
//


#import "MarkupParser.h"

@implementation MarkupParser

@synthesize font, color, strokeColor, strokeWidth;
@synthesize images;

-(id)init
{
    self = [super init];
    if (self) {
        self.font = @"Arial";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
    }
    return self;
}

-(NSAttributedString*)attrStringFromMarkup:(NSString*)markup
{
    
}

-(void)dealloc
{
    self.font = nil;
    self.color = nil;
    self.strokeColor = nil;
    self.images = nil;
    
}

@end