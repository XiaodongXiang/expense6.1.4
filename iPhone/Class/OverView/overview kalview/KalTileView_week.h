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
typedef char KalTileType_week;

@class KalDate_week;

@interface KalTileView_week : UIView
{
  KalDate_week *date;
  CGPoint origin;
  struct {
    unsigned int selected : 1;
    unsigned int highlighted : 1;
    unsigned int marked : 1;
    unsigned int type : 2;
  } flags;
    
    double totalExpAmount;
    double totalExpPaid;//没用到
    double totalIncAmount;
    double totalIncPaid;//没用到
    
    BOOL showOutDate;
    double tileHigh;
}

@property (nonatomic, strong) KalDate_week *date;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isMarked) BOOL marked;
@property (nonatomic) KalTileType_week type;


@property(nonatomic,setter = setTotalExpAmount:)double totalExpAmount;
@property(nonatomic,setter = setTotalExpPaid:)double totalExpPaid;
@property(nonatomic,setter = setTotalIncAmount:)double totalIncAmount;
@property(nonatomic,setter = setTotalIncPaid:)double totalIncPaid;

@property (nonatomic, assign)BOOL showOutDate;
@property (nonatomic, strong)UIView *bottomLine;
@property (nonatomic, strong)UIView *rightLine;

//@property(nonatomic)double totalExpAmount;
//@property(nonatomic)double totalExpPaid;
//@property(nonatomic)double totalIncAmount;
//@property(nonatomic)double totalIncPaid;

- (void)resetState;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;

@end
