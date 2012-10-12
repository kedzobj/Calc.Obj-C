//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Brian Kedzorski on 10/10/12.
//  Copyright (c) 2012 Brian Kedzorski. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;


/*
 lazy instantiation of NSMutableArray. We're waiting until the last possible moment to make space for
 this array.
*/

- (NSMutableArray *)operandStack
{
    if (!_operandStack) {
        _operandStack=[[NSMutableArray alloc] init];
    }
        return _operandStack;
}


/* This method says:
    "Take a double as the operand value, turn it into an NSNumber, add this object to the array (our stack). We do this because our array cannot take a primitive type, like a number."
*/

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

/* This method says:
 "I pop operands off of the stack once they have been used by performOperation below. I look at the array and, as long as there is a number in the array, I return the last number/object and then remove it."
 */

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

/* This method says:
 "'I'm the basis of the operations for the calculator.' Check the string value of the title of the button that is passed in from the controller and perform the corresponding operation by popping the numbers/objects/operands off of the array. This result is turned into an object by the pushOperand method and the results are then returned, in the case of this app, to the controller.   "
 */

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = - [self popOperand] + subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    } else if ([operation isEqualToString:@"sin"]) {
        double sined = [self popOperand];
        result = sin(sined);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
    } else if ([operation isEqualToString:@"π"]) {
        result = M_PI;
    }
        
    //calculate result
    [self pushOperand:result];
    
    return result;
}

/* This method says:
 "Clear the array of all objects."
 */

- (void)clearCalculator
{
    [self.operandStack removeAllObjects];
}

@end
