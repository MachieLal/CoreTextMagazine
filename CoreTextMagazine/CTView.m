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


//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    
//    // Flip the coordinate system
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    
//    CGMutablePathRef path = CGPathCreateMutable(); //1
//    CGPathAddRect(path, NULL, self.bounds );
//    
////    Not Working  -- > Crashing
////    CGMutablePathRef path2 = (__bridge CGMutablePathRef)([UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
////                                                                                        radius:fmin(self.bounds.size.width, self.bounds.size.height)/2
////                                                                                    startAngle:0
////                                                                                      endAngle:2*M_PI
////                                                                                     clockwise:YES]);
////    NSAttributedString* attString = [[NSAttributedString alloc]
////                                      initWithString:@"Hello core text world!"]; //2
//    
//    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString); //3
//    CTFrameRef frame =
//    CTFramesetterCreateFrame(framesetter,
//                             CFRangeMake(0, [_attString length]), path, NULL);
//    
//    CTFrameDraw(frame, context); //4
//    
//    CFAutorelease(frame); //5
//    CFAutorelease(path);
////    CFRelease(path2);
//
//    CFRelease(framesetter);
//}

- (void)buildFrames
{
    _frameXOffset = 20; //1
    _frameYOffset = 20;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.frames = [NSMutableArray array];
    
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectInset(self.bounds, _frameXOffset, _frameYOffset);
    CGPathAddRect(path, NULL, textFrame );
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString);
    
    int textPos = 0; //3
    int columnIndex = 0;
    
    while (textPos < [_attString length]) { //4
        CGPoint colOffset = CGPointMake( (columnIndex+1)*_frameXOffset + columnIndex*(textFrame.size.width/2), 20 );
        CGRect colRect = CGRectMake(0, 0 , textFrame.size.width/2-10, textFrame.size.height-40);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        
        //create an empty column view
        CTColumnView* content = [[CTColumnView alloc] initWithFrame: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        content.backgroundColor = [UIColor clearColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height) ;
        
        //set the column view contents and add it as subview
        [content setCTFrame:(__bridge id)frame];  //6
        [self.frames addObject: (__bridge id)frame];
        [self addSubview: content];
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    
    //set the total width of the scroll view
    int totalPages = (columnIndex+1) / 2; //7
    self.contentSize = CGSizeMake(totalPages*self.bounds.size.width, textFrame.size.height);
}

@end
