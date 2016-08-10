//
//  CTView.h
//  CoreTextMagazine
//
//  Created by Swarup_Pattnaik on 04/08/16.
//  Copyright © 2016 Swarup_Pattnaik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTColumnView.h"

@interface CTView : UIScrollView<UIScrollViewDelegate>

@property (assign, nonatomic) float frameXOffset;
@property (assign, nonatomic) float frameYOffset;
@property (strong, nonatomic) NSMutableArray* frames;

@property (strong, nonatomic) NSArray* images;
@property (strong, nonatomic) NSAttributedString * attString;

-(void)setAttString:(NSAttributedString *)attString withImages:(NSArray*)imgs;

-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col;

//- (void)drawRect:(CGRect)rect;

- (void)buildFrames;

@end
