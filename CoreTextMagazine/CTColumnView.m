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

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((CTFrameRef)ctFrame, context);
}

@end