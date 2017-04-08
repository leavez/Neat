# Neat

[![CI Status](http://img.shields.io/travis/gaojiji@gmail.com/Neat.svg?style=flat)](https://travis-ci.org/gaojiji@gmail.com/Neat)
[![Version](https://img.shields.io/cocoapods/v/Neat.svg?style=flat)](http://cocoapods.org/pods/Neat)
[![License](https://img.shields.io/cocoapods/l/Neat.svg?style=flat)](http://cocoapods.org/pods/Neat)
[![Platform](https://img.shields.io/cocoapods/p/Neat.svg?style=flat)](http://cocoapods.org/pods/Neat)

Neat is a tool solve the line height problems when using TextKit on iOS. 

Line heights (or the visual line sapcings) displayed by TextKit vary on different lines when mixing different languages in one text. It looks very ungracefull and breaks the beauty of text layout. A common example is Chinese-English mixed layout, and even English-emoji mix cannot escape!! `UILabel` and `UITextView` handle this very well. Neat make TextKit views look exactly the same to `UILabel`.

[pictures]

Neat also remove the extra line spacing of last line when text is truncated to the maxNumberOfLines. It may, but not always, happen when `lineSpacing` is greater than zero. This function makes it very convenient to constrain the spaces between textView and other views.

## Install

Install via CocoaPods:

```ruby
pod "Neat"
```

## Usage

### Basic Usages:

1. Import Neat and call `[UIFont patchMetrics];` once before textView layout. Recommend in `didFinishLaunchingWithOption:` or class load method.
2. set the delegate of textView's layouManager to `[NELineHeightFixer sharedInstance]`. If the delegate is occupied, wraps it with `NSLayoutManagerDelegateFixerWrapper`.

### Advanced:

Please read "How it works" first.

Neat contains 2 parts:

- a patch for UIFont.  `UIFont+Patch`
  - It alone solve the line spacing problems.
- a implementation of NSLayoutManagerDelegate.  `NELineHeightFixer` and `NSLayoutManagerDelegateFixerWrapper`
  - It alone solve the problem extra line spacing below last line.
  - it alone solve the line spacing problems with an small exception.

These 2 parts work together solve the problems above perfectly.

**NOTE**: The patch for UIFont effects globally since it swizzles the methods of UIFont. This may have potential conflict on other parts. Walk around: use second part alone. To solve the small expection, you could set the maximumLineHeight of attribtuedString to `fixedLineHeightForFontSize:paragraphStyle:` of NELineHeightFixer.

## How it works

The nature of diffent line heights when mixing different languages is the different metrics of different fonts. When you use system default font, you get `SFUIText`. SF only have glyphs for English text. When encountered emoji, it fall down to `AppleColorEmojiUI`. SF and AppleColorEmojiUI have different metrics, i.e. `lineHeight`, `descender` and etc. The later have larger lineHeight. When a line contain an emoji character, layoutManger gives a larger rect to display this line, which led to a larger visual line spacing.

( This is same to English-Chinese mix. `PingFang`  have small lineHeight, so pure Chinese lines have small line spacings. PingFang also have different descender, which effects baseLineOffset, making it more wired in a English-Chinese mixed line. )

Two ways to solve the problem:

- make all fonts' metrics the same
  -  by swizzling the method of UIFont and return `SFUIText`'s value
- manully set the line rects 
  - by implementing method of NSLayoutManagerDelegate:  `layoutManager:shouldSetLineFragmentRect:lineFragmentUsedRect:baselineOffset:inTextContainer:forGlyphRange:` and modify the rects and baseLineOffset.

Neat implements both ways, beacuse neither of these methods alone can solve it well. The first can't handle the extra line spacing below last line. The second alone could solve all two problems, with a exception that having a small additional space below last line when last line or the truncated part contains emoji.

## License

Neat is available under the MIT license. See the LICENSE file for more info.
