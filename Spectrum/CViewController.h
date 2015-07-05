//  Created by morimotor on 12/12/27.
//  Copyright (c) 2012年 morimotor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"


@interface CViewController : UIViewController<UIPickerViewDelegate>
{
    
    // ピッカー
    IBOutlet UIPickerView* picker;
    
    IBOutlet UITextField* sorceURL;
    
    IBOutlet UISegmentedControl *segmentedControl;
    
    IBOutlet UILabel* label;
    
    // スペクトル描画
	DrawView* drawview;
    
    NSMutableArray* dataNumList;    // データにある日付の情報
    NSString* prestr;

}

@property(nonatomic, retain)UILabel* label;
@property(nonatomic, retain)UIPickerView* picker;
@property(nonatomic, retain)UITextField* sorceURL;
@property(nonatomic, retain)DrawView* drawview;

-(IBAction)getData:(id)sender;
-(IBAction)lineOn:(id)sender;

@end
