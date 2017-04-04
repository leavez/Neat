//
//  ViewController.m
//  TextKit
//
//  Created by Gao on 3/25/17.
//  Copyright © 2017 leave. All rights reserved.
//

#import "ViewController.h"
#import "TextView.h"
#import <Neat/Neat.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) TextView *textKitView;
@property (nonatomic) UILabel *label;

@property (nonatomic) NSMutableAttributedString *text;
@property (nonatomic) NSMutableDictionary *attributes;
@property (nonatomic) NSMutableParagraphStyle *paragraphStyle;
@property (nonatomic) NSInteger maxNumberOfLine;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 1;
    paragraphStyle.lineSpacing = 0;
    self.paragraphStyle = paragraphStyle;

    self.attributes =
    [@{NSFontAttributeName : [UIFont systemFontOfSize:18],
       NSParagraphStyleAttributeName : paragraphStyle,
       } mutableCopy];

    self.text = [[NSMutableAttributedString alloc] initWithString:[self textOfIndex:1] attributes:self.attributes];
    [self updateViews];
}


#pragma mark - display views

- (void)displayWithTextKitView:(NSAttributedString *)text {
    TextView *tv = [[TextView alloc] initWithFrame:CGRectZero];
    self.textKitView = tv;
    tv.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.scrollView addSubview:tv];

    NSTextStorage *storage = [[NSTextStorage alloc] initWithAttributedString:text];
    TextRenderer *renderer = [[TextRenderer alloc] initWithTextStorage:storage];
    renderer.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    renderer.textContainer.lineFragmentPadding = 0;
    renderer.textContainer.maximumNumberOfLines = self.maxNumberOfLine;
    renderer.layoutManager.delegate = [NELineHeightFixer sharedInstance];
    tv.renderer = renderer;

    // layout
    [self addContraintToView:tv];
    tv.preferredMaxLayoutWidth = 200;
}

- (void)displayWithUILabel:(NSAttributedString *)text {

    UILabel *label = [[UILabel alloc] init];
    self.label = label;
    label.alpha = 0.3;
    label.backgroundColor = [UIColor orangeColor];
    NSMutableAttributedString *t = [text mutableCopy];
    [t addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(0, t.length)];

    [self.scrollView addSubview:label];
    label.attributedText = t;
    label.preferredMaxLayoutWidth = 200;
    label.numberOfLines = self.maxNumberOfLine;
    [self addContraintToView:label];

}

- (void)addContraintToView:(UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *parent = view.superview;
    NSLayoutConstraint *top = [view.topAnchor constraintEqualToAnchor:parent.topAnchor constant:0];
    NSLayoutConstraint *left = [view.leftAnchor constraintEqualToAnchor:parent.leftAnchor constant:0];
    NSLayoutConstraint *bottom = [view.bottomAnchor constraintLessThanOrEqualToAnchor:parent.bottomAnchor constant:0];
    [parent addConstraints:@[top, left, bottom]];
}


- (void)updateViews {
    [self.textKitView removeFromSuperview];
    [self.label removeFromSuperview];
    self.textKitView = nil;
    self.label = nil;
    [self displayWithTextKitView:self.text];
    [self displayWithUILabel:self.text];
}


#pragma mark - actions 

- (IBAction)fontSizeSilderChanged:(UISlider *)sender {
    CGFloat size = sender.value;
    NSLog(@"font size: %f", size);
    [self.text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0,self.text.string.length)];
    self.attributes[NSFontAttributeName] = [UIFont systemFontOfSize:size];
    [self updateViews];
}

- (IBAction)lineSpacingSliderChanged:(UISlider *)sender {
    CGFloat lineSpacing = sender.value;
    //lineSpacing = floor(lineSpacing);
    NSLog(@"line spacing: %f", lineSpacing);
    self.paragraphStyle.lineSpacing = lineSpacing;
    [self updateViews];
}
- (IBAction)textSilderChanged:(UISlider *)sender {
    NSString *text = [self textOfIndex:(NSInteger)(sender.value)];
    self.text = [[NSMutableAttributedString alloc] initWithString:text attributes:self.attributes];
    [self updateViews];
}


- (NSString *)textOfIndex:(NSInteger)index {
    switch (index % 6) {
        case 0:
            return @""
            "iOS提供了Core AnimationÈ框架，只需要开发者提供关键帧信息，比如提供某个animatable属性终点的关键帧信息，然后中间的值则通过一定的算法进行插值计算，从而实现补间动画。Core Aniamtion中进行插值计算所依赖的时间曲线由CAMediaTimingFunction提供。 Pop Animation在使用上和Core Animation很相似，都涉及Animation对象以及Animation的载体的概念，不同的是Core Animation的载体只能是CALayer，而Pop Animation可以是任意基于NSObject的对象。当然大多数情况Animation都是界面上显示的可视的效果，所以动画执行的载体一般都直接或者间接是UIView或者CALayer was there there .";
        case 1:
            return @""
            "iOS提供了Core AnimationÈ框架，只需要开\n发者提供关键帧信息，比如提供某个animatable属性终点的关键帧信息，然后中间的值则通过一定的算法进行插值计算，从而实现补间动画。Core Aniamtion中进行插值计算所依赖的时间曲线由CAMediaTimingFunction提供。 Pop Animation在使用上和Core Animation很相似，都涉及Animation对象以及Animation的载体的概念，不同的是Core Animation的载体只能是CALayer，而Pop Animation可以是任意基于NSObject的对象。当然大多数情况Animation都是界面上显示的可视的效果，所以动画执行的载体一般都直接或者间接是UIView或者CALayer was there there .";
        case 2:
            return @""
            "iOS提供😇了Core AnimationÈ框架，只需要开\n发者提供关键帧信息，比如提供某个animatable属性终点的关键帧信息，然后中间的值则通过一定的算法进行插值计算，从而实现补间动画。Core Aniamtion中进行插值计算所依赖的时间曲线由CAMediaTimingFunction提供。 Pop Animation\n\n在使用上和Core Animation很相似，都涉及Animation对象以及Animation的载体的概念，不同的是Core Animation的载体只能是CALayer，而Pop Animation可以是任意基于NSObject的对象。当然大多数情况Animation都是界面上显示的可😇视的效果，所以动画执行的载体一般都直接或者🤗间接😎是UIView或者CALayer was there there .";
        case 3:
            return @""
            "2012年12月。エヴァ：Qの公開後🤗、僕は EVA 壊れました。 The 所謂、鬱状態となりました。 ６年間、自分の魂を削って再びエヴァを作っていた事への、当然の報いでした。明けた2013年。その一年間は精神的な負の波が何度も揺れ戻してくる年でした。自分が代表を務め、自分が作品 works を背負っているスタジオにただの１度も近づく事が出来ませんでした。\n他者や世間との関係性がおかしくなり、まるで回復しない疲労困憊も手伝って、ズブズブと精神的な不安定感に取り込まれていきました。その間、様々な方々に迷惑をかけました。が、妻や友人らの御蔭で、この世に留まる事が出来、宮崎駿氏に頼まれた声の仕事がアニメ制作へのしがみつき行為として機能した事や、友人らが僕のアニメファンの源になっていた作品の新作をその時期に作っていてくれた御蔭で、アニメーションから心が離れずにすみました。友人が続けている戦隊シリーズも、特撮ファンとしての心の支えになっていました。The series contains numerous allusions to the Kojiki and the Nihongi, the sacred texts of Shinto. The Shinto vision of the primordial cosmos is referenced in the series, and the mythical lances of the Shinto deities Izanagi and Izanami are used as weapons in battles between Evangelions and Angels.[63] Elements of the Judeo-Christian tradition also feature prominently throughout the series, including references to Adam, Lilith, Eve, the Lance of Longinus,[64]";
        case 4:
            return @""
            "중국조선어에 관한 망🤗라적인 언어 I don't know what the text said. 규범은 동북3성조선어문사업협의소조가 1977년에 작성한 ‘조선말규범집’이 처음이다. 이 규 This will test Korean and Enghlish mix layout 범집에는 표준발음법, 맞춤법, 띄어쓰기, 문장부호에 관한 규범이 수록되었다. ‘조선말규범집’은 어휘에 관한 규범을 덧붙이고, 일부를 가필 수정한 개정판이 1984년에 만들어졌다.[1]\n 중국조선말은 1949년 중화인민공화국 건국 이래, 조선민주주의인민공화국(이하 북조선)의 언어에 규범의 토대를 두어 온 경위로, 중국조선말의 언어 규범은 모두 북조선의 규범(조선말규범집 등)과  hello 거의 동일하며, 1992년 한중수교 이후에는 대한민국으로부터 진출한 기업이나 한국어 교육 기관의 영향력이 커짐에 따라 남한식 한국어의 사용이 확대되고 있다.";
        case 5:
            return @""
            "للغة العربية هي🤗 أكثر اللغات تحدثاً ونطقاً ضمن مجموعة اللغات hello world السامية، وإحدى أكثر اللغات انتشاراً في العالم، يتحدثها أكثر من 422 مليون نسمة،[2](1) ويتوزع متحدثوها في الوطن العربي، بالإضافة إلى العديد من المناطق الأخرى المجاورة كالأحواز وتركيا وتشاد ومالي والسنغال وإرتيريا و إثيوبيا و جنوب السودان و إيران. اللغة العربية ذات أهمية قصوى لدى المسلمين، فهي لغة مقدسة (لغة القرآن)، ولا تتم الصلاة (وعبادات أخرى) في الإسلام إلا بإتقان بعض من كلماتها.[4][5] العربية هي أيضاً لغة شعائرية رئيسية لدى عدد من الكنائس المسيحية في الوطن العربي، كما كتبت بها كثير من أهم الأعمال الدينية والفكرية اليهودية في العصور الوسطى. وأثّر انتشار الإسلام، وتأسيسه دولاً، ";
        default:return @"";
    }
}

- (void)change:(void(^)())action {
    action();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self change:action];
    });
}

- (IBAction)lineHeightMultipleChanged:(UISlider *)sender {
    float value = sender.value;
    NSLog(@"%s: %f", __func__, value);
    self.paragraphStyle.lineHeightMultiple = value;
    [self updateViews];
}

- (IBAction)paragrashSpacingChanged:(UISlider *)sender {
    float value = sender.value;
    NSLog(@"%s: %f", __func__, value);
    self.paragraphStyle.paragraphSpacing = value;
    [self updateViews];
}
- (IBAction)firstLineHeadIndentChanged:(UISlider *)sender {
    float value = sender.value;
    NSLog(@"%s: %f", __func__, value);
    self.paragraphStyle.firstLineHeadIndent = value;
    [self updateViews];
}
- (IBAction)headIndentChanged:(UISlider *)sender {
    float value = sender.value;
    NSLog(@"%s: %f", __func__, value);
    self.paragraphStyle.headIndent = value;
    [self updateViews];
}
- (IBAction)tailIndentChanged:(UISlider *)sender {
    float value = sender.value;
    NSLog(@"%s: %f", __func__, value);
    self.paragraphStyle.tailIndent = value;
    [self updateViews];
}

- (IBAction)maxNumberOfLinesChanged:(UISlider *)sender {
    int value = (int)sender.value;
    NSLog(@"%s: %d", __func__, value);
    self.textKitView.renderer.textContainer.maximumNumberOfLines = value;
    [self.textKitView setNeedsDisplay];
    [self.textKitView invalidateIntrinsicContentSize];
    self.label.numberOfLines = value;
    self.maxNumberOfLine = value;
}

- (IBAction)minimumLineHeightChanged:(UISlider *)sender {
    float value = sender.value;
    NSLog(@"%s: %f", __func__, value);
    self.paragraphStyle.minimumLineHeight = value;
    [self updateViews];
}
- (IBAction)maximumLineHeightChanged:(UISlider *)sender {
    float value = sender.value;
    NSLog(@"%s: %f", __func__, value);
    self.paragraphStyle.maximumLineHeight = value;
    [self updateViews];
}
- (IBAction)paragraphSpacingBeforeChanged:(UISlider *)sender {
    float value = sender.value;
    NSLog(@"%s: %f", __func__, value);
    self.paragraphStyle.paragraphSpacingBefore = value;
    [self updateViews];
}
- (IBAction)BaseWritingDirectionChanged:(UISlider *)sender {
    int value = (int)sender.value;
    NSLog(@"%s: %d", __func__, value);
    self.paragraphStyle.baseWritingDirection = value;
    [self updateViews];
}
- (IBAction)hyphenationFactorChanged:(UISlider *)sender {
    float value = sender.value;
    NSLog(@"%s: %f", __func__, value);
    self.paragraphStyle.hyphenationFactor = value;
    [self updateViews];
}







@end
