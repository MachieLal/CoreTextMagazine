//
//  CTView.h
//  CoreTextMagazine
//
//  Created by Swarup_Pattnaik on 04/08/16.
//  Copyright © 2016 Swarup_Pattnaik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTView : UIView

@property (assign, nonatomic) float frameXOffset;
@property (assign, nonatomic) float frameYOffset;

@property (strong, nonatomic) NSAttributedString * attString;

- (void)drawRect:(CGRect)rect;

@end
