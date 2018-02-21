[![Gem Version](https://badge.fury.io/rb/simple_docx_generator.svg)](https://badge.fury.io/rb/simple_docx_generator)
[![Dependency Status](https://gemnasium.com/badges/github.com/seventhsense/simple_docx_generator.svg)](https://gemnasium.com/github.com/seventhsense/simple_docx_generator)
[![Code Climate](https://codeclimate.com/github/seventhsense/simple_docx_generator/badges/gpa.svg)](https://codeclimate.com/github/seventhsense/simple_docx_generator)
[![Test Coverage](https://codeclimate.com/github/seventhsense/simple_docx_generator/badges/coverage.svg)](https://codeclimate.com/github/seventhsense/simple_docx_generator/coverage)
[![Travis CI](https://travis-ci.org/seventhsense/simple_docx_generator.svg?branch=master)](https://travis-ci.org/seventhsense/simple_docx_generator)


# SimpleDocxGenerator

RubyやRailsからdocxファイルの@@で囲まれた文字列を置換えます.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_docx_generator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_docx_generator --source git://github.com/seventhsense/simple_docx_generator.git

## Usage

### docxファイルを準備する

変数（@@で始まり@@で終わる大文字小文字の英数字とアンダーバー）を含むテンプレートを準備します.
ex. @@hello@@

変数の後ろに.checkboxとつけるとWordのチェックボックスを作成します.
値に"1"を設定するとチェックつきのチェックボックスを出力します.
変数の後ろに.textとつけると改行も反映されます.

### require 'simple_docx_generator'


### initialize
    
    mydocx = MyDocx.new(path_to_docxfile)

### 変数を確認する
    
    mydocx.keys
    
テンプレート内の変数を得ます

### 変数に値をセットする
    
    mydocx.set key, value

### 新しいdocxファイルを作成する

    mydocx.generate filename

テンプレートファイルと同じディレクトリにfilename.docxという名前のdocxファイルが生成されます.
filenameを省略すると、output_元のファイル名となります.

### Railsでの活用

 [状況に応じてRailsのフォームの種類を変える](http://blog.scimpr.com/2012/11/09/%e7%8a%b6%e6%b3%81%e3%81%ab%e5%bf%9c%e3%81%98%e3%81%a6rails%e3%81%ae%e3%83%95%e3%82%a9%e3%83%bc%e3%83%a0%e3%81%ae%e7%a8%ae%e9%a1%9e%e3%82%92%e5%a4%89%e3%81%88%e3%82%8b/)

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/ztu2OP_p4ec/0.jpg)](https://www.youtube.com/watch?v=ztu2OP_p4ec)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
