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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zombies" ofType:@"txt"];
    NSString* text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    MarkupParser* parser = [[MarkupParser alloc] init];
    NSAttributedString* attString = [parser attrStringFromMarkup: text];
    [(CTView *)[self view] setAttString:attString withImages: parser.images];
    [(CTView *)[self view] buildFrames];
    

}

@end