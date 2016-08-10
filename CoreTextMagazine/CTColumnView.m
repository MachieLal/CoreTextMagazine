//
//  CTColumnView.m
//  CoreTextMagazine
//
//  Created by Swarup_Pattnaik on 07/08/16.
//  Copyright © 2016 Swarup_Pattnaik. All rights reserved.
//

#import "CTColumnView.h"

@implementation CTColumnView
-(void)setCTFrame: (id) f
{
    ctFrame = f;
}

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]!=nil) {
        self.images = [NSMutableArray array];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //at the end of drawRect:
    for (NSArray* imageData in self.images) {
        UIImage* img = [imageData objectAtIndex:0];
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }
    
    CTFrameDraw((CTFrameRef)ctFrame, context);
}

@end