//  Created by morimotor on 12/04/22.
//  Copyright (c) 2012年 morimotor. All rights reserved.
//

#import "DrawView.h"

#define S_BLUE(x)  [_g setColorR:0 g:0 b:200 a:x]
#define S_BLACK(x) [_g setColorR:0 g:0 b:0 a:x]
#define S_RED(x)   [_g setColorR:255 g:0 b:0 a:x]
#define S_GREEN(x) [_g setColorR:0 g:255 b:0 a:x]

@implementation DrawView

@synthesize flag;
@synthesize dateStr;
@synthesize data;
@synthesize memflag;

- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
     	_g = [[Graphic alloc]init];
    }
    
    flag = [NSNumber numberWithInt:1];
    memflag = [NSNumber numberWithInt:0];
    return self;
}

-(void)drawRect:(CGRect)rect
{
	

	[_g setContext:UIGraphicsGetCurrentContext()];
    [_g setLineWidth:2.0f];
	
    year = [[dateStr substringWithRange:NSMakeRange(0, 4)]intValue];
    month = [[dateStr substringWithRange:NSMakeRange(5, 2)]intValue];
    day = [[dateStr substringWithRange:NSMakeRange(8, 2)]intValue];

    
    
    
    // まとめて表示
    if([flag intValue])
    {
        S_BLUE(255);
        [_g drawString:[NSString stringWithFormat:@"センサ1"] x:10+0 y:2];
        S_GREEN(255);
        [_g drawString:[NSString stringWithFormat:@"センサ2"] x:10+80 y:2];
        S_RED(255);
        [_g drawString:[NSString stringWithFormat:@"センサ3"] x:10+160 y:2];
        S_BLACK(255);
        [_g drawString:[NSString stringWithFormat:@"センサ4"] x:10+240 y:2];
        

        for (int count=0; count<[data count]; count++)
        {
            NSArray *arr = [data objectAtIndex:count];
            
            if([[arr objectAtIndex:0]intValue] != year)continue;
            if([[arr objectAtIndex:1]intValue] != month)continue;
            if([[arr objectAtIndex:2]intValue] != day)continue;
            
            float k = 924 / (60.0f * 24.0f);  // 横軸合わせ係数(１分あたりのピクセル数)
            float n = 415 / 300.0f;  // 縦軸係数
            int min = [[arr objectAtIndex:3]intValue];
            int sens = [[arr objectAtIndex:5]intValue];
            
            
            if([[arr objectAtIndex:4]intValue]==1) //センサ1なら
            {
                S_BLUE(150);
                [_g fillRectX:30+min*k y:MY-30 w:3 h:-sens*n];
            }
            
            if([[arr objectAtIndex:4]intValue]==2) //センサ2なら
            {
                S_GREEN(150);
                [_g fillRectX:30+min*k y:MY-30 w:3 h:-sens*n];
                
            }
            
            if([[arr objectAtIndex:4]intValue]==3) //センサ3なら
            {
                S_RED(150);
                [_g fillRectX:30+min*k y:MY-30 w:3 h:-sens*n];
                
            }
            
            if([[arr objectAtIndex:4]intValue]==4) //センサ4なら
            {
                S_BLACK(150);
                [_g fillRectX:30+min*k y:MY-30 w:3 h:-sens*n];
                
            }
            
            
            
        }
        
        

        S_BLACK(255);
        // 軸線
        [_g drawLineX0:30 y0:30 x1:30 y1:MY-30];
        [_g drawLineX0:30 y0:MY-30 x1:MX-30 y1:MY-30];
        
        // 目盛り
        for(int i =0; i<=23;i++)
        {
            int memsize = 8;// 目盛りの長さ
            [_g drawLineX0:30+i*38.5f y0:MY-30 x1:30+i*38.5f y1:MY-30-memsize];
            [_g drawLineX0:30+i*38.5f+19.25f y0:MY-30 x1:30+i*38.5f+19.25f y1:MY-30-memsize/2];
            [_g drawString:[NSString stringWithFormat:@"%2d:00", i] x:30+i*38.5f-7 y:MY-30+5];
        }
        
        // 目盛り
        for(int i =0; i<=20;i++)
        {
            float a = (415.0f)/(300.0f);// 縦係数
            int memsize = 3 + [memflag intValue] * 921;// 目盛りの長さ
            [_g drawLineX0:30 y0:MY-30-i*15*a x1:30+memsize y1:MY-30-i*15*a];
            
            [_g drawString:[NSString stringWithFormat:@"%2d", i*15] x:5 y:MY-30-i*15*a-5];
        }
        
    }

    
    // 分割して表示
    else if(![flag intValue])
    {
        
        S_BLUE(255);
        [_g drawString:[NSString stringWithFormat:@"センサ1"] x:10+0 y:2];
        S_GREEN(255);
        [_g drawString:[NSString stringWithFormat:@"センサ2"] x:10+CX y:2];
        S_RED(255);
        [_g drawString:[NSString stringWithFormat:@"センサ3"] x:10 y:2+CY];
        S_BLACK(255);
        [_g drawString:[NSString stringWithFormat:@"センサ4"] x:10+CX y:2+CY];
        
        
        for (int count=0; count<[data count]; count++)
        {
            NSArray *arr = [data objectAtIndex:count];

            if([[arr objectAtIndex:0]intValue] != year)continue;
            if([[arr objectAtIndex:1]intValue] != month)continue;
            if([[arr objectAtIndex:2]intValue] != day)continue;
            
            float k = 432.0f / (60.0f * 24.0f);  // 横軸合わせ係数
            float n = 177.5f / 300.0f;  // 縦軸係数
            int min = [[arr objectAtIndex:3]intValue];
            int sens = [[arr objectAtIndex:5]intValue];
            
            
            if([[arr objectAtIndex:4]intValue]==1) //センサ1なら
            {
                S_BLUE(255);
                [_g drawLineX0:30+k*min y0:CY-30 x1:30+k*min y1:CY-30-sens*n];
  
            }
            
            if([[arr objectAtIndex:4]intValue]==2) //センサ2なら
            {
                S_GREEN(255);
                [_g drawLineX0:CX+30+k*min y0:CY-30 x1:CX+30+k*min y1:CY-30-sens*n];
                
            }
            
            if([[arr objectAtIndex:4]intValue]==3) //センサ3なら
            {
                S_RED(255);
                [_g drawLineX0:30+k*min y0:MY-30 x1:30+k*min y1:MY-30-sens*n];
                
            }
            
            if([[arr objectAtIndex:4]intValue]==4) //センサ4なら
            {
                S_BLACK(255);
                [_g drawLineX0:CX+30+k*min y0:MY-30 x1:CX+30+k*min y1:MY-30-sens*n];
                
            }
            
            
            
        }
        
        
        S_BLACK(255);
        
        // 軸線
        // 左上
        [_g drawLineX0:30 y0:30 x1:30 y1:CY-30];
        [_g drawLineX0:30 y0:CY-30 x1:CX-30 y1:CY-30];

        // 左下
        [_g drawLineX0:30 y0:CY+30 x1:30 y1:MY-30];
        [_g drawLineX0:30 y0:MY-30 x1:CX-30 y1:MY-30];
        
        // 右上
        [_g drawLineX0:CX+30 y0:30 x1:CX+30 y1:CY-30];
        [_g drawLineX0:CX+30 y0:CY-30 x1:MX-30 y1:CY-30];
        
        // 右下
        [_g drawLineX0:CX+30 y0:CY+30 x1:CX+30 y1:MY-30];
        [_g drawLineX0:CX+30 y0:MY-30 x1:MX-30 y1:MY-30];
        
        // 目盛り
        for(int i =0; i<=23;i++)
        {
            int memsize = 3;// 目盛りの長さ
            [_g drawLineX0:30+i*18 y0:MY-30 x1:30+i*18 y1:MY-30-memsize];
            [_g drawLineX0:30+i*18 y0:CY-30 x1:30+i*18 y1:CY-30-memsize];
            [_g drawLineX0:CX+30+i*18 y0:MY-30 x1:CX+30+i*18 y1:MY-30-memsize];
            [_g drawLineX0:CX+30+i*18 y0:CY-30 x1:CX+30+i*18 y1:CY-30-memsize];
            
            [_g drawLineX0:30+i*18+9 y0:MY-30 x1:30+i*18+9 y1:MY-30-memsize/2];
            [_g drawLineX0:30+i*18+9 y0:CY-30 x1:30+i*18+9 y1:CY-30-memsize/2];
            [_g drawLineX0:CX+30+i*18+9 y0:MY-30 x1:CX+30+i*18+9 y1:MY-30-memsize/2];
            [_g drawLineX0:CX+30+i*18+9 y0:CY-30 x1:CX+30+i*18+9 y1:CY-30-memsize/2];
            
            [_g drawString:[NSString stringWithFormat:@"%2d", i] x:30+i*18-7 y:MY-30+5];
            [_g drawString:[NSString stringWithFormat:@"%2d", i] x:CX+30+i*18-7 y:MY-30+5];
            [_g drawString:[NSString stringWithFormat:@"%2d", i] x:30+i*18-7 y:CY-30+5];
            [_g drawString:[NSString stringWithFormat:@"%2d", i] x:CX+30+i*18-7 y:CY-30+5];
            
            
        }
        
        // 目盛り
        for(int i =0; i<=10;i++)
        {
            
            int memsize = 3 + [memflag intValue] * 429;// 目盛りの長さ
            [_g drawLineX0:30 y0:CY-30-i*17.75f x1:30+memsize y1:CY-30-i*17.75f];
            [_g drawLineX0:CX+30 y0:CY-30-i*17.75f x1:CX+30+memsize y1:CY-30-i*17.75f];
            [_g drawLineX0:30 y0:MY-30-i*17.75f x1:30+memsize y1:MY-30-i*17.75f];
            [_g drawLineX0:CX+30 y0:MY-30-i*17.75f x1:CX+30+memsize y1:MY-30-i*17.75f];
            
            
            [_g drawString:[NSString stringWithFormat:@"%2d", i*30] x:5 y:CY-30-i*17.75f-5];
            [_g drawString:[NSString stringWithFormat:@"%2d", i*30] x:CX+5 y:CY-30-i*17.75f-5];
            [_g drawString:[NSString stringWithFormat:@"%2d", i*30] x:5 y:MY-30-i*17.75f-5];
            [_g drawString:[NSString stringWithFormat:@"%2d", i*30] x:CX+5 y:MY-30-i*17.75f-5];
        }
        
    }
    
}
@end
