//
//  SFEnglishKeyboard.m
//  Smallfan
//
//  Created by Smallfan on 17-2-15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#define KkeyboardBtnHeight  [UIScreen mainScreen].bounds.size.width > 320 ? 40 : 36
#define KimageHeight        [UIScreen mainScreen].bounds.size.width > 320 ? 103 : 100
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width


#define KarrayNum @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"]

#define KarrayCap  @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"]

#define KarraySmall  @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"]


#import "SFEnglishKeyboard.h"

@interface SFEnglishKeyboard ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView       *viewBG;
@property (nonatomic, strong) UIImageView       *clickImage;
@property (nonatomic, strong) UILabel           *lab;
@property (nonatomic, strong) UIButton          *altBtn;
@property (nonatomic, strong) UIButton          *shiftBtn;
@property (nonatomic, strong) NSTimer           *deleteTimer;
@end

@implementation SFEnglishKeyboard {
    NSMutableArray       *mutableArray;
    NSString             *keyStr;
    NSInteger             status;    //0:normal 1:select 2:doubleSelect
}

+ (SFEnglishKeyboard *)shareEnglishKeyboard
{
    static SFEnglishKeyboard * EnglishKeyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(EnglishKeyboard == nil)
            EnglishKeyboard = [[SFEnglishKeyboard alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 266)];

    });
    return EnglishKeyboard;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        status = 0;
        self.backgroundColor = [UIColor whiteColor];

        _viewBG = [[UIImageView alloc] initWithFrame:self.bounds];
        _viewBG.image = [UIImage imageNamed:@"keyboardBackground.png"];
        _viewBG.userInteractionEnabled = YES;
        [self addSubview:_viewBG];

        //width
        CGFloat width = kScreenWidth / 10;       //每个按键＋间隙 为10等份
        CGFloat gap = width - 30;         //间隙的宽度

        mutableArray = [NSMutableArray array];
        NSDictionary *dic;
        CGFloat x;
        NSUInteger btnHeight = 36;
        NSString *keyboardBtnHeight = nil;
        if ([UIScreen mainScreen].bounds.size.width > 320) {
            btnHeight = 44;
        }
        int tag = 0;
        //1 2 3 4 5 6 7 8 9 0
        for (int i = 0; i < 10; i++) {
            x = i * width + (gap / 2);
            tag = 1000 + i;
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",x],@"x",
                                                            @"10",@"y",
                                                            [NSString stringWithFormat:@"%d",tag],@"index",
                                                            KarrayNum[tag - 1000],@"keyStr",nil];
            [mutableArray addObject:dic];
        }

        //q w e r t y u i o p
        for (int i = 0; i < 10; i++) {
            x = i * width + (gap / 2);
            tag = 1010+i;
            keyboardBtnHeight = [NSString stringWithFormat:@"%lu",btnHeight+20];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",x],@"x",
                   keyboardBtnHeight,@"y",
                   [NSString stringWithFormat:@"%d",tag],@"index",
                   KarrayCap[tag-1010],@"keyStr",nil];
            [mutableArray addObject:dic];
        }
        
        //a s d f g h j k l
        for (int i = 0; i < 9; i++) {
            x = i * width + (gap + width) / 2;
            tag = 1020+i;
            keyboardBtnHeight = [NSString stringWithFormat:@"%lu",2*(btnHeight+20)-10];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",x],@"x",
                   keyboardBtnHeight,@"y",
                   [NSString stringWithFormat:@"%d",tag],@"index",
                   KarrayCap[tag-1010],@"keyStr",nil];
            [mutableArray addObject:dic];
        }

        //z x c v b n m
        for (int i = 0; i < 7; i++) {
            x = i * width + (gap + 3 * width) / 2;
            tag = 1029+i;
            keyboardBtnHeight = [NSString stringWithFormat:@"%lu",3*(btnHeight+20)-20];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",x],@"x",
                   keyboardBtnHeight,@"y",
                   [NSString stringWithFormat:@"%d",tag],@"index",
                   KarrayCap[tag-1010],@"keyStr",nil];
            [mutableArray addObject:dic];
        }

        //shiftBtn
        _shiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shiftBtn.frame = CGRectMake(gap / 2, [keyboardBtnHeight intValue], 40, KkeyboardBtnHeight);
        _shiftBtn.backgroundColor = [UIColor clearColor];
        [_shiftBtn setBackgroundImage:[UIImage imageNamed:@"shiftBtn_normal"] forState:UIControlStateNormal];
        [_shiftBtn setBackgroundImage:[UIImage imageNamed:@"shiftBtn_highlighted"] forState:UIControlStateHighlighted];
        [_shiftBtn setBackgroundImage:[UIImage imageNamed:@"shiftBtn_highlighted"] forState:UIControlStateSelected];
        [_viewBG addSubview:_shiftBtn];
        //shift按钮加手势
        [self singleOrdouble];

        //deleteBtn
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(kScreenWidth-(40 + gap/2), [keyboardBtnHeight intValue], 40, KkeyboardBtnHeight);
        deleteBtn.backgroundColor = [UIColor clearColor];
        [deleteBtn  addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchDown];
        [deleteBtn addTarget:self action:@selector(stopDeleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"backspace_normal"] forState:UIControlStateNormal];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"backspace_highlighted"] forState:UIControlStateHighlighted];
        [_viewBG addSubview:deleteBtn];

        //lineBtn
        UIButton *lineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lineBtn setFrame:CGRectMake(gap / 2, _viewBG.frame.size.height - btnHeight - 5, 40, KkeyboardBtnHeight)];
        [lineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lineBtn setBackgroundImage:[UIImage imageNamed:@"lineBtn_normal"] forState:UIControlStateNormal];
        [lineBtn setBackgroundImage:[UIImage imageNamed:@"lineBtn_highlighted"] forState:UIControlStateHighlighted];
        [lineBtn addTarget:self action:@selector(pressLineBtn) forControlEvents:UIControlEventTouchUpInside];
        [_viewBG addSubview:lineBtn];

        //starBtn
        UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        starBtn.frame =CGRectMake(lineBtn.frame.size.width + lineBtn.frame.origin.x + gap, lineBtn.frame.origin.y, 40, KkeyboardBtnHeight);
        starBtn.backgroundColor = [UIColor clearColor];
        [starBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [starBtn setBackgroundImage:[UIImage imageNamed:@"starBtn_normal"] forState:UIControlStateNormal];
        [starBtn setBackgroundImage:[UIImage imageNamed:@"starBtn_highlighted"] forState:UIControlStateHighlighted];
        [starBtn addTarget:self action:@selector(pressStarBtn) forControlEvents:UIControlEventTouchUpInside];
        [_viewBG addSubview:starBtn];

        //returnBtn
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        returnBtn.frame = CGRectMake(kScreenWidth-77, lineBtn.frame.origin.y, 73, KkeyboardBtnHeight);
        returnBtn.backgroundColor = [UIColor clearColor];
        [returnBtn setTitle:@"确定" forState:UIControlStateNormal];
        [returnBtn  addTarget:self action:@selector(returnBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [returnBtn setBackgroundImage:[UIImage imageNamed:@"returnKey"] forState:UIControlStateNormal];
        [_viewBG addSubview:returnBtn];

        //spaceBtn
        UIButton *spaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat spaceBtnX = gap+starBtn.frame.size.width+starBtn.frame.origin.x;
        CGFloat spaceBtnWidth = _viewBG.frame.size.width - spaceBtnX - (gap + 77);
        spaceBtn.frame = CGRectMake(spaceBtnX, lineBtn.frame.origin.y, spaceBtnWidth, KkeyboardBtnHeight);
        spaceBtn.layer.cornerRadius = 3.f;
        spaceBtn.clipsToBounds = YES;
        spaceBtn.backgroundColor = [UIColor whiteColor];
        [spaceBtn setTitle:@"空格" forState:UIControlStateNormal];
        [spaceBtn setTitleColor:[UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
        [spaceBtn setBackgroundImage:[UIImage imageNamed:@"space_normal"] forState:UIControlStateNormal];
        [spaceBtn  addTarget:self action:@selector(spaceBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_viewBG addSubview:spaceBtn];

        _clickImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, KimageHeight)];
        _clickImage.image = [UIImage imageNamed:@"chooseBackGroud.png"];
        _clickImage.hidden = YES;
        [self addSubview:_clickImage];

        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 54, KkeyboardBtnHeight)];
        _lab.textColor = [UIColor blackColor];
        _lab.textAlignment = 1;
        _lab.backgroundColor = [UIColor clearColor];
        _lab.font = [UIFont systemFontOfSize:24.f];
        [_clickImage addSubview:_lab];
    }
    return self;
}

//单双击
-(void)singleOrdouble
{
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_shiftBtn addGestureRecognizer:singleRecognizer];

    // 双击的 Recognizer
    UITapGestureRecognizer* doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [_shiftBtn addGestureRecognizer:doubleRecognizer];

    // 关键在这一行，如果双击确定偵測失败才會触发单击
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
}

-(void)changeKeyboardType
{
    [self.delegate changeKeyboard];
}

//点击－按钮
- (void)pressLineBtn
{
    NSString *returnStr= @"-";
    [self.delegate returnString:returnStr];
}

//点击＊按钮
- (void)pressStarBtn
{
    NSString *returnStr = @"*";
    [self.delegate returnString:returnStr];
}

//删除按钮事件
- (void)deleteBtnAction
{
    [self.delegate englishKeyboardBackspace];
	
	if (_deleteTimer) {
		[_deleteTimer invalidate];
		_deleteTimer = nil;
	}
    _deleteTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                    target:self
                                                  selector:@selector(deleteBtnLongPressAction)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)stopDeleteBtnAction
{
    [_deleteTimer invalidate];
    _deleteTimer = nil;
}

-(void)deleteBtnLongPressAction
{
    [self.delegate englishKeyboardBackspace];
}

//空格
-(void)spaceBtnAction
{
    keyStr = @" ";
    [self.delegate returnString:keyStr];
}

//return
-(void)returnBtnAction
{
    [self.delegate returnKeyBoard];
}

//单击事件
-(void)handleSingleTapFrom
{
    status = status == 0 ? 1 : 0;
    if (status == 0) {
        [_shiftBtn setSelected:NO];
    }else{
        [_shiftBtn setSelected:YES];
    }
}

//双击事件
-(void)handleDoubleTapFrom
{
    status = status == 0 ? 2 : 0;
    if (status == 0) {
        [_shiftBtn setSelected:NO];
    }else{
        [_shiftBtn setSelected:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:_viewBG];
    for (NSDictionary *dic in mutableArray) {
        int x = [[dic objectForKey:@"x"] intValue];
        int w = 30;
        NSInteger y = [[dic objectForKey:@"y"] integerValue];
        int h = 40;
        if (point.x <= x+w && point.x >= x ) {
            if (point.y <= y+h && point.y >= y) {
                _clickImage.hidden = NO;
                _clickImage.frame = CGRectMake(x-16, y-63, 63, KimageHeight);
                _lab.text = [dic  objectForKey:@"keyStr"];
                [self bringSubviewToFront:_clickImage];
                return;
            }
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:_viewBG];
    for (NSDictionary *dic in mutableArray) {
        int x = [[dic objectForKey:@"x"] intValue];
        int w = 30;
        NSInteger y = [[dic objectForKey:@"y"] integerValue];
        int h = 40;
        if (point.x <= x+w && point.x >= x ) {
            if (point.y <= y+h && point.y >= y) {
                _clickImage.hidden = NO;
                _clickImage.frame = CGRectMake(x-16, y-63, 63, KimageHeight);
                _lab.text = [dic  objectForKey:@"keyStr"];
                [self bringSubviewToFront:_clickImage];
                return;
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:_viewBG];
    keyStr = @"";
    for (NSDictionary *dic in mutableArray) {
        int x = [[dic objectForKey:@"x"] intValue];
        int w = 30;
        NSInteger y = [[dic objectForKey:@"y"] integerValue];
        int h = 40;
        if (point.x <= x+w && point.x >= x ) {
            if (point.y <= y+h && point.y >= y) {
                _lab.text = [dic  objectForKey:@"keyStr"];
                [self bringSubviewToFront:_clickImage];
                if (point.y <= 50) {
                    keyStr = KarrayNum[[[dic objectForKey:@"index"] intValue] - 1000];
                }else{
                    if (status == 1 || status == 2) {
                        keyStr = KarrayCap[[[dic objectForKey:@"index"] intValue]-1010];
                    }else {
                        keyStr = KarraySmall[[[dic objectForKey:@"index"] intValue]-1010];
                    }
                }
                [self bringSubviewToFront:_viewBG];
                [self.delegate returnString:keyStr];
                _clickImage.hidden = YES;

                if (status == 1) {
                    status = 0;
                    [_shiftBtn setSelected:NO];
                }
                return;
            }
        }
    }
    _clickImage.hidden = YES;
}

@end
