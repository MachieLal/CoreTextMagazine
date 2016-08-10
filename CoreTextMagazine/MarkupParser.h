//
//  MarkupParser.h
//  CoreTextMagazine
//
//  Created by Swarup_Pattnaik on 06/08/16.
//  Copyright © 2016 Swarup_Pattnaik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIColor.h>


@interface MarkupParser : NSObject {
    
    NSString* font;
    UIColor* color;
    UIColor* strokeColor;
    float strokeWidth;
    
    NSMutableArray* images;
}





@property (strong, nonatomic) NSString* font;
@property (strong, nonatomic) UIColor* color;
@property (strong, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@property (strong, nonatomic) NSMutableArray* images;

-(NSAttributedString*)attrStringFromMarkup:(NSString*)html;

@end
