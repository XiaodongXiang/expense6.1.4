/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

enum {
  KalTileTypeRegular   = 0,
  KalTileTypeAdjacent  = 1 << 0,
  KalTileTypeToday     = 1 << 1,
};
typedef char KalTileType;

@class KalDate;

@interface KalTileView : UIView
{
  KalDate *date;
  CGPoint origin;
  struct {
    unsigned int selected : 1;
    unsigned int highlighted : 1;
    unsigned int marked : 1;
    unsigned int type : 2;
  } flags;
    
    
    
    //NSMutableArray *paidmarkArray;
    
    BOOL overDue;
	BOOL paid;
	BOOL unpaid;
	BOOL paidHalf;
    
    
	BOOL isBillShow;
	BOOL isTran;
    
	BOOL showOutDate;
	BOOL drawLeft;
	double totalExpAmount;
	double totalExpPaid;
	double totalIncAmount;
	double totalIncPaid;

    
    
}

@property (nonatomic, retain) KalDate *date;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isMarked) BOOL marked;
@property (nonatomic) KalTileType type;
@property (nonatomic,assign) CGPoint origin;

@property (nonatomic, getter=isPaidMarked) BOOL paidmarked;
@property (nonatomic, getter=isUnpaidMarked) BOOL unpaidmarked;
@property (nonatomic) BOOL isBillShow;
@property (nonatomic) BOOL isTran;

@property (nonatomic) BOOL showOutDate;
@property (nonatomic) BOOL drawLeft;
@property (nonatomic,assign) double totalExpAmount;
@property (nonatomic,assign) double totalExpPaid;
@property (nonatomic,assign) double totalIncAmount;
@property (nonatomic,assign) double totalIncPaid;
@property (nonatomic) BOOL overDue;
@property (nonatomic) BOOL paid;
@property (nonatomic) BOOL unpaid;
@property (nonatomic) BOOL paidHalf;

@property(nonatomic,strong)UILabel *labelInc;
@property(nonatomic,strong) UILabel *labelExp;
@property (nonatomic, strong)UIView *bottomLine;
@property (nonatomic, strong)UIView *rightLine;


- (void)resetState;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;
- (id)initWithFrame:(CGRect)frame withShowStatus:(BOOL)s drawMonth:(BOOL)dvs;

@end
