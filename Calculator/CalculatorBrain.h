//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Brian Kedzorski on 10/10/12.
//  Copyright (c) 2012 Brian Kedzorski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
- (double) performOperation:(NSString *)operation;
- (void) clearCalculator;

@end
