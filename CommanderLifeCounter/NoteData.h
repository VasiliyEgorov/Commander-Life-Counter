//
//  NoteData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 18.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NoteData : NSObject


- (NSString*) dateForCell:(NSDate*)date;
- (NSString*) splitTextForCell:(NSAttributedString*)cellText withNoteString:(NSString*)noteString;
- (NSString*) splitTextForCell:(NSAttributedString*)textViewAttributedString withDetailedString:(NSString*)detailedString;
- (NSAttributedString*)placePhoto:(UIImage*)photo inTextView:(UITextView*)textView;
- (NSData*) searchForImageInAttributedText:(NSAttributedString*) attributedString;
- (NSAttributedString*)placeCircleInTextView:(UITextView*)textView;

@end
