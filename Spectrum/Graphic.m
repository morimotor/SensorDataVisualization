//  http://www.saturn.dti.ne.jp/~npaka/iphone/index.html

#import "Graphic.h"

@implementation Graphic
/*------------------------------
 　初期化
 ------------------------------*/
- (id)init 
{
    if (self=[super init])
	{
        _context=NULL;
        _contextBMP=NULL;
        _font=[UIFont boldSystemFontOfSize:12];
    }
    return self;
}

//メモリ解放
- (void)dealloc 
{
    [self releaseContext]; 
}

/*------------------------------
 　コンテキスト
 ------------------------------*/
- (void)setContext:(CGContextRef)context 
{
    //コンテキストの解放
    [self releaseContext];
    
    //コンテキストの指定
    _context=context;
    CGContextRetain(_context);
}

//コンテキストの生成
- (void)makeContext:(CGSize)size
{
    //コンテキストの解放
    [self releaseContext];
	
    //コンテキストの生成
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    _contextBMP=malloc(size.width*size.height*sizeof(unsigned char)*4); 
    _context=CGBitmapContextCreate(_contextBMP, size.width,size.height,8,size.width*4,colorSpace,kCGImageAlphaPremultipliedFirst);
    if (_context==nil)
	{
        CGColorSpaceRelease(colorSpace);
        [self releaseContext];
        return;
    }
    CGContextClearRect(_context,CGRectMake(0,0,size.width,size.height));
    CGColorSpaceRelease(colorSpace);
}

//コンテキストの解放
- (void)releaseContext 
{
    if (_context!=NULL) 
	{
        CGContextRelease(_context);
        _context=NULL;
    }
    if (_contextBMP!=NULL)
	{
        free(_contextBMP);
        _contextBMP=NULL;
    }
}

//コンテキストのプッシュ
- (void)pushContext 
{
    UIGraphicsPushContext(_context);  
}

//コンテキストのポップ
- (void)popContext 
{
    UIGraphicsPopContext();
}

//スクリーンショットの取得
- (UIImage*)makeScreenShot 
{
    CGImageRef imageRef=CGBitmapContextCreateImage(_context);
    UIImage* image=[[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

/*------------------------------
 　各設定
 ------------------------------*/   
//色の指定
- (void)setColorR:(float)r g:(float)g b:(float)b 
{
    CGContextSetRGBFillColor(_context,r,g,b,1);
    CGContextSetRGBStrokeColor(_context,r,g,b,1);
}

//色の指定
- (void)setColorR:(float)r g:(float)g b:(float)b a:(float)a 
{
    CGContextSetRGBFillColor(_context,r,g,b,a);
    CGContextSetRGBStrokeColor(_context,r,g,b,a);
}

//ライン幅の指定
- (void)setLineWidth:(float)lineWidth 
{
    CGContextSetLineWidth(_context,lineWidth);
}

//フォントの指定
- (void)setFont:(UIFont*)font
{
    _font=font;
}

//平行移動の指定　
- (void)setTranslateX:(float)x y:(float)y 
{
    CGContextTranslateCTM(_context,x,y); 
}

//スケールの指定　
- (void)setScaleW:(float)w h:(float)h 
{
    CGContextScaleCTM(_context,w,h);
}

//回転の指定　
- (void)setRotate:(float)rotate 
{
    CGContextRotateCTM(_context,rotate); 
}

//クリッピングの指定
- (void)clipRectX:(float)x y:(float)y w:(float)w h:(float)h 
{
    CGContextClipToRect(_context,CGRectMake(x,y,w,h));
}

//行列のプッシュ
- (void)pushMatrix 
{
    CGContextSaveGState(_context);  
}

//行列のポップ
- (void)popMatrix 
{
    CGContextRestoreGState(_context);
}

/*------------------------------
 　描画
 ------------------------------*/
//ラインの描画
- (void)drawLineX0:(float)x0 y0:(float)y0 x1:(float)x1 y1:(float)y1 
{
    CGContextSetLineCap(_context,kCGLineCapRound);
    CGContextMoveToPoint(_context,(int)x0,(int)y0);
    CGContextAddLineToPoint(_context,(int)x1,(int)y1);
    CGContextStrokePath(_context);
}

//ポリラインの描画
- (void)drawPolylineX:(float[])x y:(float[])y length:(int)length 
{
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,x[0],y[0]);
    for (int i=1;i<length;i++) 
	{
        CGPathAddLineToPoint(path,NULL,x[i],y[i]);
    }
    [self drawPolyline:path];
    CGPathRelease(path);
}

//ポリラインの描画
- (void)drawPolyline:(CGPoint[])vertex length:(int)length 
{
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,vertex[0].x,vertex[0].y);
    for (int i=1;i<length;i++) 
	{
        CGPathAddLineToPoint(path,NULL,vertex[i].x,vertex[i].y);
    }
    [self drawPolyline:path];
    CGPathRelease(path);
}

//ポリラインの描画
- (void)drawPolyline:(CGMutablePathRef)line 
{
    CGContextSetLineCap(_context,kCGLineCapRound);
    CGContextSetLineJoin(_context,kCGLineJoinRound);
    CGContextAddPath(_context,line);
    CGContextDrawPath(_context,kCGPathStroke);
}

//矩形の描画
- (void)drawRectX:(float)x y:(float)y w:(float)w h:(float)h
{    
    CGContextMoveToPoint(_context,(int)x,(int)y);
    CGContextAddLineToPoint(_context,(int)x+(int)w,(int)y);
    CGContextAddLineToPoint(_context,(int)x+(int)w,(int)y+(int)h);
    CGContextAddLineToPoint(_context,(int)x,(int)y+(int)h);
    CGContextAddLineToPoint(_context,(int)x,(int)y);
    CGContextAddLineToPoint(_context,(int)x+(int)w,(int)y);
    CGContextStrokePath(_context);
}

//矩形の塗り潰し
- (void)fillRectX:(float)x y:(float)y w:(float)w h:(float)h 
{    
    CGContextFillRect(_context,CGRectMake(x,y,w,h));
}

//円の描画
- (void)drawCircleX:(float)x y:(float)y r:(float)r 
{    
    CGContextAddEllipseInRect(_context,CGRectMake(x-r,y-r,r*2,r*2));
    CGContextStrokePath(_context);
}

//円の描画
- (void)drawCircleX:(float)x y:(float)y w:(float)w h:(float)h 
{    
    CGContextAddEllipseInRect(_context,CGRectMake(x,y,w,h));
    CGContextStrokePath(_context);
}

//円の塗り潰し
- (void)fillCircleX:(float)x y:(float)y r:(float)r 
{    
    CGContextFillEllipseInRect(_context,CGRectMake(x-r,y-r,r*2,r*2));
}

//円の塗り潰し
- (void)fillCircleX:(float)x y:(float)y w:(float)w h:(float)h 
{    
    CGContextFillEllipseInRect(_context,CGRectMake(x,y,w,h));
}

//三角形の描画
- (void)drawTriangle:(CGPoint[])pos 
{
    CGContextMoveToPoint(_context,pos[0].x,pos[0].y);
    CGContextAddLineToPoint(_context,pos[1].x,pos[1].y);
    CGContextAddLineToPoint(_context,pos[2].x,pos[2].y);
    CGContextStrokePath(_context);
}

//三角形の塗り潰し
- (void)fillTriangle:(CGPoint[])pos
{
    CGContextMoveToPoint(_context,pos[0].x,pos[0].y);
    CGContextAddLineToPoint(_context,pos[1].x,pos[1].y);
    CGContextAddLineToPoint(_context,pos[2].x,pos[2].y);
    CGContextFillPath(_context);
}

//イメージの描画
- (void)drawImage:(UIImage*)image x:(float)x y:(float)y
{
    if (image==nil) return;    
    [image drawAtPoint:(CGPointMake(x,y))];
}

//イメージの描画
- (void)drawImage:(UIImage*)image x:(float)x y:(float)y w:(float)w h:(float)h
{
    if (image==nil) return;
    [image drawInRect:(CGRectMake(x,y,w,h))];
}

//文字列の描画
- (void)drawString:(NSString*)string x:(float)x y:(float)y
{
    [string drawAtPoint:CGPointMake(x,y) withFont:_font];
}
@end

