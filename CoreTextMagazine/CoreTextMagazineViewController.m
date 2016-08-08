//
//  ViewController.m
//  CoreTextMagazine
//
//  Created by Swarup_Pattnaik on 04/08/16.
//  Copyright © 2016 Swarup_Pattnaik. All rights reserved.
//

#import "CoreTextMagazineViewController.h"
#import "CTView.h"
#import "MarkupParser.h"

@implementation CoreTextMagazineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"txt"];
    NSString* text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    MarkupParser* p = [[MarkupParser alloc] init];
    NSAttributedString* attString = [p attrStringFromMarkup: text];
    [(CTView*)self.view setAttString: attString];
    [(CTView *)[self view] buildFrames];

}

@end