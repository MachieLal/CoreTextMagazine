//
//  CTView.m
//  CoreTextMagazine
//
//  Created by Swarup_Pattnaik on 04/08/16.
//  Copyright © 2016 Swarup_Pattnaik. All rights reserved.
//

#import "CTView.h"
#import <CoreText/CoreText.h>
#import "MarkupParser.h"
@implementation CTView


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, self.bounds );
    
//    Not Working  -- > Crashing
//    CGMutablePathRef path2 = (__bridge CGMutablePathRef)([UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
//                                                                                        radius:fmin(self.bounds.size.width, self.bounds.size.height)/2
//                                                                                    startAngle:0
//                                                                                      endAngle:2*M_PI
//                                                                                     clockwise:YES]);
//    NSAttributedString* attString = [[NSAttributedString alloc]
//                                      initWithString:@"Hello core text world!"]; //2
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString); //3
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [_attString length]), path, NULL);
    
    CTFrameDraw(frame, context); //4
    
    CFAutorelease(frame); //5
    CFAutorelease(path);
//    CFRelease(path2);

    CFRelease(framesetter);
}


@end
