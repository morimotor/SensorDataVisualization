//  Created by morimotor on 12/04/22.
//  Copyright (c) 2012年 morimotor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graphic.h"

#define MX 984
#define MY 475

#define CX (MX/2.0f)
#define CY (MY/2.0f)


@interface DrawView : UIView
{
    Graphic* _g;

    NSNumber* flag;
    NSNumber* memflag;
    
    NSString* dateStr;
    NSMutableArray* data;
    
    int year;
    int month;
    int day;
}

@property(nonatomic, retain)NSNumber* flag;
@property(nonatomic, retain)NSNumber* memflag;
@property(nonatomic, retain)NSString* dateStr;
@property(nonatomic, retain)NSMutableArray* data;


@end
