//
//  NoteData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 18.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "NoteData.h"
#import "Constants.h"
#import "UIImage+Category.h"

static const int cellTextLabelLenght = 40;
static const int startPointForCellTextLabel = 0;

@interface NoteData ()


@end

@implementation NoteData



- (NSString*) dateForCell:(NSDate*)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dayMonthYear = [formatter stringFromDate:date];
    
    return dayMonthYear;
    
}

#pragma mark - Split text for cell methods

- (NSString*) splitTextForCell:(NSAttributedString*)textViewAttributedString withNoteString:(NSString*)noteString  {
 
    NSString *stringForCellText = [self findAndDeleteNsTextAttachment:textViewAttributedString];
    
    if ([stringForCellText isEqualToString:EMPTY]) {
        
        noteString = NOTEXT;
     
    }
     else {
 
        NSString *resultNoteString = [stringForCellText substringWithRange:
                                      NSMakeRange(startPointForCellTextLabel, [stringForCellText length])];
     
        noteString = resultNoteString;
    
    }
    
    return noteString;
}



- (NSString*) splitTextForCell:(NSAttributedString*)textViewAttributedString withDetailedString:(NSString*)detailedString {
  
    NSString *stringForCellText = [self findAndDeleteNsTextAttachment:textViewAttributedString];
    
    if ([stringForCellText length] <= cellTextLabelLenght) {
        
             return detailedString = NOADDITIONALTEXT;
    }
    
    else  {
        
        NSString *string = [stringForCellText substringFromIndex:cellTextLabelLenght];
        
        NSRange range = [string rangeOfString:@" "];
        
        if (range.location != NSNotFound && [string length] > range.location + 1) {
            NSString *detailedString = [string substringFromIndex:range.location + 1];
            return detailedString;
        } else {
            return detailedString = NOADDITIONALTEXT;
        }

    }
}


- (NSString*) findAndDeleteNsTextAttachment:(NSAttributedString*)textViewAttributedString {
    
    NSMutableAttributedString *mutAtrString = [[NSMutableAttributedString alloc] initWithAttributedString:textViewAttributedString];
    
    [mutAtrString enumerateAttribute:NSAttachmentAttributeName
                             inRange:NSMakeRange(0, [mutAtrString length])
                             options:0
                          usingBlock:^(id textImage, NSRange range, BOOL *stop) {
                              
                              if ([textImage isKindOfClass:[NSTextAttachment class]]) {
                                  
                                  [mutAtrString replaceCharactersInRange:range withString:EMPTY];
                              }
                          }];
    
    return [self replaceIllegalCharactersInString:mutAtrString.string];
}

- (NSString*) replaceIllegalCharactersInString:(NSString*)replacebleString {
    
    NSString *stringWithoutDoubleWhiteSpaces = [replacebleString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    
    NSString *stringWithoutNewline = [stringWithoutDoubleWhiteSpaces stringByReplacingOccurrencesOfString:@"\n" withString:EMPTY];
    
    NSString *trimmedString = [stringWithoutNewline stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return trimmedString;
}

- (NSData*) searchForImageInAttributedText:(NSAttributedString*) attributedString {
    
    __block NSData *imageData = nil;
    
    [attributedString enumerateAttribute:NSAttachmentAttributeName
                                 inRange:NSMakeRange(0, [attributedString length])
                                 options:0
                              usingBlock:^(id textImage, NSRange range, BOOL *stop) {
                                  
                                  if ([textImage isKindOfClass:[NSTextAttachment class]]) {
                                      
                                      NSTextAttachment *attachment = (NSTextAttachment *)textImage;
                                      UIImage *image = nil;
                                      
                                      if ([attachment image]) {
                                          
                                          image = [attachment image];
                                          
                                          if (image) {
                                              
                                              UIImage *resizedImage = [UIImage scaleImage:image toFrame:CGRectMake(0, 0, 41, 41)];
                                              UIImage *croppedImage = [UIImage cropImage:resizedImage toRect:CGRectMake(0, 0, 41, 41)];
                                              imageData = [UIImage convertImageToData:croppedImage];
                                              *stop = YES;
                                          }
                                      }
                                  }
                              }];
    
    return imageData;
}





#pragma mark - Resize and attach photo to textView attributed text methods

- (NSAttributedString*)placePhoto:(UIImage*)photo inTextView:(UITextView*)textView {
    
    NSMutableAttributedString *newContext = [[NSMutableAttributedString alloc] init];
    
    [newContext appendAttributedString:textView.attributedText];

    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    
    textAttachment.image = photo; 
    
    NSAttributedString *atrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
    
    [newContext appendAttributedString:space];
    
    [newContext replaceCharactersInRange:NSMakeRange([newContext length] - 1, 0) withAttributedString:atrStringWithImage];
  
    NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@"\n"];
    
    [newContext appendAttributedString:spaceString];
    
    [newContext addAttributes:textView.typingAttributes range:NSMakeRange(0, [newContext length])];
  
    return newContext;
}

- (NSAttributedString*)placeCircleInTextView:(UITextView*)textView {
    
    NSMutableAttributedString *newContext = [[NSMutableAttributedString alloc] init];
    
    [newContext appendAttributedString:textView.attributedText];
    
    NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@"\n"];
    
    [newContext appendAttributedString:spaceString];
    
    NSAttributedString *circle = [[NSAttributedString alloc] initWithString:@"○  "];

    [newContext appendAttributedString:circle];
    
    [newContext addAttributes:textView.typingAttributes range:NSMakeRange(0, [newContext length])];
    
    return newContext;
}


@end
