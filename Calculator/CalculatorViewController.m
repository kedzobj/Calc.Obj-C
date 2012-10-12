//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Brian Kedzorski on 10/9/12.
//  Copyright (c) 2012 Brian Kedzorski. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

//Here we're creating a private property we can use to keep track of whether we're adding a number.

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

/*
 Using @synthesize to synthesize our setter and getter methods for these properties. This also synthesizes our instance variables.
*/

@synthesize fullOperationDisplay;
@synthesize display, userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;


- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
        return _brain;
}

/*
 This method says:
 "When this method is called, check to see if the full display has an equals sign. If so, get an index of the display (which should just be 1 - the equal sign), and move back one space in said index. This will remove the "=" from the display."
 */

-(void) clearEqualSignFromFullDisplay {
    if ([self.fullOperationDisplay.text hasSuffix:@"="]) {
        self.fullOperationDisplay.text = [self.fullOperationDisplay.text substringToIndex:self.fullOperationDisplay.text.length-1];
    }
}

/*
 This method says:
 "When the digit button is pressed, clear the display and get the title of the button from its sender. If the user is already in the middle of entering a number, append the button's digit on to the current display. If a number has not already been entered, change the display to the button's digit and remind our controller that we are now entering numbers."
*/

- (IBAction)digitPressed:(UIButton *)sender {
    [self clearEqualSignFromFullDisplay];
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
       self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

/*
 This method says:
 "When the decimal button is pressed, use "clearEqualSignFromFullDisplay" to clear the display. If the user has entered numbers already, check the value of our display's text to see if a decimal already exists, and if not, append a decimal place to the existing text. If numbers have not yet been entered, then change the display text to "0." and tell our "userIsInTheMiddleOfEnteringANumber" that, yes, we are now entering numbers."
*/

- (IBAction)dotPressed {
    [self clearEqualSignFromFullDisplay];
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    }
        else {
        self.display.text = @".0";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

/*
 This method says
 "When the enter button is pressed, send the number from the display bar to the pushOperand method of the brain/model. Tell our method that checks to see if we're entering a number that we are done entering numbers and append the entered values to the full operation display"
 */

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.fullOperationDisplay.text = [self.fullOperationDisplay.text stringByAppendingFormat:@"%@ ", self.display.text];
    
}

/*
 This method (excluding the "+/-" function) says:
 "If the user presses an operation button, check to see if they're in the middle of entering numbers. If so, perform the "enterpressed" method; otherwise, move on. Then, take the title that is being passed by the button's sender, send it to the brain/model's performOperation method, and then update the display text with the result."
*/

- (IBAction)operationPressed:(UIButton *)sender {
    [self clearEqualSignFromFullDisplay];
    
    if (self.userIsInTheMiddleOfEnteringANumber && [sender.currentTitle isEqualToString:@"+/-"]) {
        if ([self.display.text hasPrefix:@"-"]) {
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text = [NSString stringWithFormat:@"-%@", self.display.text];
        }
    } else {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            [self enterPressed];
        }
        double result = [self.brain performOperation:sender.currentTitle];
        self.display.text = [NSString stringWithFormat:@"%g", result];
        self.fullOperationDisplay.text = [self.fullOperationDisplay.text stringByAppendingFormat:@"%@ =", sender.currentTitle];
    }
}

/*
 This method says:
 "Basically, reset all of the methods and variables that are keeping track of what we've done so far. Set our display to 0, our full display to nothing, clear the calculator's stack in our brain/model, and remind our controller that we aren't typing a number anymore."
*/

- (IBAction)clearDisplay {
    self.display.text = @"0";
    self.fullOperationDisplay.text = @"";
    [self.brain clearCalculator];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

/*
 This method says:
 "When the user touches the backspace button, get an index of our current display (using the length method), and move back one value in the index of our stack. If there isn't anything to index (==0), set the display to zero and remind the controller that we aren't typing a number anymore."
*/

- (IBAction)backspace {
    self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
    if (self.display.text.length == 0) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (void)viewDidUnload {
    [self setFullOperationDisplay:nil];
    [super viewDidUnload];
}

@end
