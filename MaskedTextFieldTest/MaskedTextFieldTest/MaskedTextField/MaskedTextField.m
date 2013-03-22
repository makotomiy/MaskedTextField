//
//  MaskedTextField.m
//  RPS
//
//  Created by Marcos Garcia on 5/4/12.
//  Copyright (c) 2012 Coderockr. All rights reserved.
//

#import "MaskedTextField.h"

@implementation MaskedTextField

@synthesize formatter = _formatter;

#pragma mark - Getters
- (NSFormatter *) formatter
{
    return _formatter;
}

#pragma mark - Setters
- (void) setFormatter:(NSFormatter *)formatter
{
    _formatter = formatter;
}

#pragma mark - Constructors
- (MaskedTextField *) initWithFormatter:(NSFormatter *)formatter
{
    self = [super init];
    self.formatter = formatter;
    return self;
}

#pragma mark - UITextFieldDelegate methods
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *text = [[NSMutableString alloc] initWithString:[textField text]];

    if (string != nil) {
        [text replaceCharactersInRange:range
                            withString:string];
    }
    
    [self.formatter getObjectValue:&text
                         forString:text
                  errorDescription:nil];

    if (text == nil) {
        text = [NSMutableString stringWithString:@""];
    }
    
    NSString *newText = [self.formatter stringForObjectValue:text];
    
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange lastDigitPosition = [newText rangeOfCharacterFromSet:numbers
                                                                options:NSBackwardsSearch];
    
    NSUInteger oldLength = [textField.text length];
    
    if (lastDigitPosition.location == NSNotFound) {
        [textField setText:@""];
    } else {
        [textField setText:[newText substringToIndex:lastDigitPosition.location + 1]];
    }
    
    NSInteger offset = [textField.text length] - oldLength;
    
    if (offset > 0) {
        UITextPosition *pos = [textField positionFromPosition:textField.beginningOfDocument offset:range.location + offset];
        [textField setSelectedTextRange:[textField textRangeFromPosition:pos toPosition:pos]];
    }
    
    return NO;
}

@end
