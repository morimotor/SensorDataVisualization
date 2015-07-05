//  Created by morimotor on 12/12/27.
//  Copyright (c) 2012年 morimotor. All rights reserved.
//

#import "CViewController.h"

@interface CViewController ()

@end

@implementation CViewController

@synthesize sorceURL;
@synthesize picker;
@synthesize drawview;
@synthesize label;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.picker.delegate = self;
    
    sorceURL.text = @"http://hogehoge.html";
    // drawviewの初期データを入れる
	drawview = [[DrawView alloc] initWithFrame:CGRectMake(20, 20, MX, MY)];
	[drawview setBackgroundColor:[UIColor whiteColor]];
	
	// drawviewの追加
	[self.view addSubview:drawview];
    
	[segmentedControl addTarget:self action:@selector(segmentedControlPressed:)forControlEvents:UIControlEventValueChanged];
    
    dataNumList = [[NSMutableArray alloc] init];
    
    [dataNumList addObject:@"データがありません"];
    prestr = [dataNumList objectAtIndex:[picker selectedRowInComponent:0]];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
}

-(void)segmentedControlPressed:(id)sender
{
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0:
            drawview.flag = [NSNumber numberWithInt:1];
            [drawview setNeedsDisplay];
            break;
        case 1:
            drawview.flag = [NSNumber numberWithInt:0];
            [drawview setNeedsDisplay];
            break;
    }
}


//定期処理
- (void)onTick:(NSTimer*)timer
{
    NSString* _str = [dataNumList objectAtIndex:[picker selectedRowInComponent:0]];
    
    
    if([_str isEqualToString:prestr])
    {
        return;
    }
    
   
    NSLog(@"表示データ更新:%@", _str);
    prestr = _str;
    
    drawview.dateStr = _str;
    
    [drawview setNeedsDisplay];
}

-(IBAction)lineOn:(id)sender
{
    if([drawview.memflag intValue]==0)drawview.memflag = [NSNumber numberWithInt:1];
    else if([drawview.memflag intValue]==1)drawview.memflag = [NSNumber numberWithInt:0];
    [drawview setNeedsDisplay];
}


/*------------------------------
 　ピッカーの初期化
 ------------------------------*/

// ピッカーの列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pikerView
{
	// 列数
	return 1;
}

// ピッカーの各列の行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	// 行の数
	return [dataNumList count];
}

// 各列各行で表示するもの
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	if(component == 0)
	{
		if(row <= [dataNumList count])return [dataNumList objectAtIndex:row];
		else return [NSString stringWithFormat:@""];
	}	
	else return [[NSNumber numberWithInteger:row]stringValue];
	
}


// 行の高さ
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	// 行の高さ
	return 35.0;
}


/*------------------------------
 　データ取得
 ------------------------------*/


//正規表現で特定の文字列に挟まれた文字列を取り出すメソッド
-(NSString*)stringCut:(NSString*)sendString:(NSString*)templateString{
    
	NSError *error   = nil;
	
	NSRegularExpression *testRegex = [NSRegularExpression regularExpressionWithPattern:templateString options:0 error:&error];
	if( testRegex == nil ) NSLog( @"Error making regex: %@", error );
	NSTextCheckingResult *result = [testRegex firstMatchInString:sendString options:0 range:NSMakeRange(0, [sendString length])];
    
	NSString *string = [sendString substringWithRange:[result rangeAtIndex:1]];
	
	return string;
}

// sendStringからseparateStringをとりのぞく
-(NSString*)arrayCut:(NSString*)sendString:(NSString*)separateString{
    
	NSArray *array = [sendString componentsSeparatedByString:separateString];
	
	int arrayCount = [array count];
	
	NSMutableString *Mstring = [[NSMutableString alloc] init];
	
	for (int count=0; count<arrayCount; count++) {
		[Mstring appendString:[array objectAtIndex:count]];
	}
	NSString *string =Mstring;
	
	return string;
}

-(IBAction)getData:(id)sender
{
    [dataNumList removeAllObjects];
    
	//指定のURLからhtmlファイルを読み込む
	NSURL *url = [NSURL URLWithString:sorceURL.text];
    
	//htmlの全ての文字列（改行含む）
	NSString *allDataString = [[NSString alloc] initWithContentsOfURL:url encoding:NSShiftJISStringEncoding error:nil];
    
	//htmlの全ての文字列（改行含まない）
	NSString *_dataString = [self arrayCut:allDataString :@"\r\n"];
    NSString *dataString = [self arrayCut:_dataString :@"\n"];
    
    //NSLog(@"%@", dataString);
    NSLog(@"dataString:%d byte", [dataString length]);
    
	
	//情報のみを抜き出す（改行含まない）
	NSString *dataString2 = [self stringCut:dataString :@"<table>(.+?)</table>"];
    NSLog(@"dataString2(no break):%d byte", [dataString2 length]);
    //NSLog(@"%@", dataString2);
    
	//情報のテーブルを各行で分ける
	NSArray *dataString2Array = [dataString2 componentsSeparatedByString:@"</tr>"];
	
	
	NSMutableArray *Marray = [[NSMutableArray alloc]init];
	
	for (int count=0; count<[dataString2Array count]; count++)
    {
        [Marray addObject:[[dataString2Array objectAtIndex:count] componentsSeparatedByString:@"/td>"]];
        
	}
	
	NSMutableArray *MarrayTest = [[NSMutableArray alloc]init];
	NSMutableArray *MarrayTest_a = [[NSMutableArray alloc]init];
        
    for (int count_y=0; count_y<[Marray count]-1; count_y++)
    {
        
        for (int count_x=0; count_x<[[Marray objectAtIndex:count_y] count]-1; count_x++)
        {
			NSString *str =[[Marray objectAtIndex:count_y] objectAtIndex:count_x];
            NSString *str2 = [self stringCut:str :@"d>(.+?)<"];
        
            
            // 時間を累計分に変換（10:20->10*60+20=620）
            int _m=0;;
            if(count_x == 3)
            {
                NSString *h = [str2 substringToIndex:2];
                NSString *m = [str2 substringFromIndex:3];
                
                _m =[h intValue]*60 + [m intValue];
                
            }
            
            float _d = [str2 intValue];
            if(count_x == 3) _d = _m;
            if(count_x == 5 || count_x == 6)_d=[str2 floatValue];
            
            NSNumber * num = [[NSNumber alloc]initWithFloat:_d];
            
            [MarrayTest_a addObject:num];
            
            
		}
        
		NSArray *tempArray = [NSArray arrayWithArray:MarrayTest_a];
		
        [MarrayTest addObject:tempArray];
        
        NSString* _Str = [NSString stringWithFormat:@"%04d年%02d月%02d日", [[MarrayTest_a objectAtIndex:0]intValue], [[MarrayTest_a objectAtIndex:1]intValue], [[MarrayTest_a objectAtIndex:2]intValue]];
        
        NSLog(@"%@",_Str);
        if(![dataNumList containsObject:_Str])
        {
            [dataNumList addObject:_Str];
            [picker reloadAllComponents];
        }
        
        [MarrayTest_a removeAllObjects];
	}
    
    
    drawview.data = MarrayTest;
    
    [drawview setNeedsDisplay];
    
    [dataNumList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.picker.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(bool)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) ||
        (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)) {
        return YES;
    }
    return NO;
}

@end
