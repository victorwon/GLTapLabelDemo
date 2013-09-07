/*
 * Copyright (c) 2011 German Laullon
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "GLTapLabel.h"

@implementation GLTapLabel

- (BOOL)isHotWord:(NSString *)word
{
    return [word hasPrefix:@"#"]
    || [word hasPrefix:@"@"]
    || [word hasPrefix:@"$"]
    || [word hasPrefix:@"http://"]
    || [word hasPrefix:@"https://"];
}

- (void)drawTextInRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *origColor = [self textColor];
    [origColor set];
    if(!self.hotFont){
        self.hotFont = self.font; // [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",self.font.fontName] size:self.font.pointSize];
    }
    
    if(!hotZones){
        hotZones = [NSMutableArray array];
        hotWords = [NSMutableArray array];
    }else{
        [hotZones removeAllObjects];
        [hotWords removeAllObjects];
    }
    
    CGSize space = [@" " sizeWithFont:self.font constrainedToSize:rect.size lineBreakMode:self.lineBreakMode];
    __block CGPoint drawPoint = CGPointMake(0,0);

    NSArray *origWords = [self.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    CGContextSetStrokeColorWithColor(context, self.linkColor.CGColor );
    CGContextSetLineWidth(context,  1.0 );
    [origWords enumerateObjectsUsingBlock:^(NSString *word, NSUInteger idx, BOOL *stop) {
        BOOL hot = [self isHotWord:word];
        UIFont *font = hot ? self.hotFont : self.font;
        
        NSString* origWord = word;
        NSString* newWord = word;
        CGSize s = [word sizeWithFont:font];
        NSMutableArray *newWords = [NSMutableArray array];
        NSString *cutWord = @"";
        int c = [word length]-1;
        
        while (s.width > rect.size.width) { // have to cut into pieces if word longer than line width
            cutWord = [origWord substringFromIndex:c];
            newWord = [origWord substringToIndex:c];
            s = [newWord sizeWithFont:font];
            c -= 1;
            if (s.width <= rect.size.width)
            {
                [newWords addObject:newWord];
                origWord = cutWord;
                s = [origWord sizeWithFont:font];
                c = [origWord length]-1;
            }
        }
        [newWords addObject:origWord];
        
        for (NSString *w in newWords) {
            CGSize s = [w sizeWithFont:font];
            
            if(drawPoint.x + s.width > rect.size.width) { // new line
                drawPoint = CGPointMake(0, drawPoint.y + s.height);
            }
            
            if (hot){
                [hotZones addObject:[NSValue valueWithCGRect:CGRectMake(drawPoint.x, drawPoint.y, s.width, s.height)]];
                [hotWords addObject:word];
                [self.linkColor set];
                if ( self.underlineLink )
                {
                    CGContextMoveToPoint( context, drawPoint.x, drawPoint.y+s.height );
                    CGContextAddLineToPoint( context, drawPoint.x+s.width, drawPoint.y+s.height );
                }
            }
            [w drawAtPoint:drawPoint withFont:font];
            [origColor set];
            
            drawPoint = CGPointMake(drawPoint.x + s.width + space.width, drawPoint.y);
        }

    }];
    
	if ( self.underlineLink )
		CGContextStrokePath( context );
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // do nothing, just consumes the touch
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = event.allTouches.anyObject;
    CGPoint point = [touch locationInView:self];
    [hotZones enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL *stop) {
        CGRect hotzone = [obj CGRectValue];
        if (CGRectContainsPoint(hotzone, point)) {
            if([self.delegate respondsToSelector:@selector(label:didSelectedHotWord:)]){
                [self.delegate label:self didSelectedHotWord:[hotWords objectAtIndex:idx]];
            }
            *stop = YES;
        }
    }];
    
}

@end
