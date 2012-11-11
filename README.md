# SimpleDocxGenerator

RubyやRailsからdocxファイルの@@で囲まれた文字列を置換えます.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_docx_generator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_docx_generator

## Usage

### docxファイルを準備する

変数（@@で始まり@@で終わる大文字小文字の英数字とアンダーバー）を含むテンプレートを準備します.
ex. @@hello@@

変数の後ろに.checkboxとつけるとWordのチェックボックスを作成します.
値に"1"を設定するとチェックつきのチェックボックスを出力します.

### require 'simple_docx_generator'


### initialize
mydocx = MyDocx.new(path_to_docxfile)

### 変数を確認する
mydocx.keysでテンプレート内の変数を得ます

### 変数に値をセットする
mydocx.set key, value

### 新しいdocxファイルを作成する
mydocx.generate filename
テンプレートファイルと同じディレクトリにfilename.docx名前のdocxファイルが生成されます.
filenameを省略すると、output_元のファイル名となります.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
