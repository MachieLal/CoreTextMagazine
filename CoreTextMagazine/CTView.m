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
    
//    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectInset(self.bounds, _frameXOffset, _frameYOffset);
//    CGPathAddRect(path, NULL, textFrame );
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString);
    
    int textPos = 0; //3
    int columnIndex = 0;
    
    while (textPos < [_attString length]) { //4
        CGPoint colOffset = CGPointMake( (columnIndex+1)*_frameXOffset + columnIndex*(textFrame.size.width/2), _frameYOffset );
        CGRect colRect = CGRectMake(0, 0 , textFrame.size.width/2-_frameXOffset, textFrame.size.height);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        
        //create an empty column view
        CTColumnView* content = [[CTColumnView alloc] initWithFrame: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        content.backgroundColor = [UIColor yellowColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height) ;
        
        //set the column view contents and add it as subview
        [content setCTFrame:(__bridge id)frame];  //6
//        [self.frames addObject: (__bridge id)frame];
//        [self attachImagesWithFrame:frame inColumnView: content];

        [self addSubview: content];
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    
    //set the total width of the scroll view
    int totalPages = (columnIndex+1) / 2; //7
    self.contentSize = CGSizeMake(totalPages*self.bounds.size.width, textFrame.size.height+100);
}

-(void)setAttString:(NSAttributedString *)string withImages:(NSArray*)imgs
{
    self.attString = string;
    self.images = imgs;
    
    CTTextAlignment alignment = kCTTextAlignmentJustified;
    
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0])); //{ settingCount == sizeof(settings) / sizeof(settings[0]) }
    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)paragraphStyle, (NSString*)kCTParagraphStyleAttributeName,
                                    nil];
    
    NSMutableAttributedString* stringCopy = [[NSMutableAttributedString alloc] initWithAttributedString:self.attString];
    [stringCopy addAttributes:attrDictionary range:NSMakeRange(0, [_attString length])];
    self.attString = (NSAttributedString*)stringCopy;
}

-(void)attachImagesWithFrame:(CTFrameRef)frame inColumnView:(CTColumnView*)col
{
    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(frame); //1
    
    CGPoint origins[[lines count]];// Declaring a static array with number of elements = [lines count]
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(frame); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) return; //quit if no images for this column
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObject in lines) { //5
        CTLineRef line = (__bridge CTLineRef)lineObject;
        
        for (id runObject in (NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (__bridge CTRunRef)runObject;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
                CGRect runBounds;
                CGFloat ascent;//height above the baseline
                CGFloat descent;//height below the baseline
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset + _frameXOffset;
                runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y + _frameYOffset;
                runBounds.origin.y -= descent;
                
                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(frame); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x - _frameXOffset - self.contentOffset.x, colRect.origin.y - _frameYOffset - self.frame.origin.y);
                [col.images addObject: //11
                 [NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]
                 ];
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
}

@end
