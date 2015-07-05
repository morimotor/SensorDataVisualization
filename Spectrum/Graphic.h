// http://www.saturn.dti.ne.jp/~npaka/iphone/index.html

#import <UIKit/UIKit.h>


@interface Graphic : NSObject
{
    CGContextRef   _context;   // コンテキスト
    unsigned char* _contextBMP;// コンテキストBMP
	UIFont*        _font;      // フォント
}

// コンテキスト
- (void)setContext:(CGContextRef)context;
- (void)makeContext:(CGSize)size;
- (void)releaseContext;
- (void)pushContext;
- (void)popContext;
- (UIImage*)makeScreenShot;

// 設定
- (void)setLineWidth:(float)lineWidth;
- (void)setColorR:(float)r g:(float)g b:(float)b a:(float)a;
- (void)setColorR:(float)r g:(float)g b:(float)b;
- (void)setFont:(UIFont*)font;
- (void)setTranslateX:(float)transX y:(float)transY;
- (void)setRotate:(float)rotate;
- (void)setScaleW:(float)scaleW h:(float)scaleH;
- (void)clipRectX:(float)x y:(float)y w:(float)w h:(float)h;
- (void)pushMatrix;
- (void)popMatrix;

// 描画
- (void)drawLineX0:(float)x0 y0:(float)y0 x1:(float)x1 y1:(float)y1;
- (void)drawPolylineX:(float[])x y:(float[])y length:(int)length;
- (void)drawPolyline:(CGPoint[])vertex length:(int)length;
- (void)drawPolyline:(CGMutablePathRef)line;
- (void)drawRectX:(float)x y:(float)y w:(float)w h:(float)h;
- (void)fillRectX:(float)x y:(float)y w:(float)w h:(float)h;
- (void)drawCircleX:(float)x y:(float)y r:(float)r;
- (void)drawCircleX:(float)x y:(float)y w:(float)w h:(float)h;
- (void)fillCircleX:(float)x y:(float)y r:(float)r;
- (void)fillCircleX:(float)x y:(float)y w:(float)w h:(float)h;
- (void)drawTriangle:(CGPoint[])pos;
- (void)fillTriangle:(CGPoint[])pos;
- (void)drawImage:(UIImage*)image x:(float)x y:(float)y;
- (void)drawImage:(UIImage*)image x:(float)x y:(float)y w:(float)w h:(float)h;
- (void)drawString:(NSString*)string x:(float)x y:(float)y;
@end