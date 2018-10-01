//
//  TranDataRect.h
//  PocketExpense
//
//  Created by MV on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranDataRect :  UIView {
    UILabel *dateStringLabel;
     
    UIView    *incView;
    UIView    *expView;
    
    UIView *line;
  }

@property (nonatomic, retain) UILabel *dateStringLabel;
@property (nonatomic, retain)   UIView    *incView;
@property (nonatomic, retain) UIView    *expView; 

-(void)setViewByMaxValue:(double)mV withIncAmount:(double)iV withExpAmount:(double)eV anmtied:(BOOL)a;
@end

 