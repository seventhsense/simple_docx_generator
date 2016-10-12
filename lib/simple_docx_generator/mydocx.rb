#encoding: utf-8
# require 'zipruby'
require 'nokogiri'
require 'ydocx'

#= クラス/MyDocx
#  docxを扱うクラスです
#  主な機能は次のとおりです
#  * テンプレートファイルの場所を指定してインスタンス化します
#  * keysメソッドでテンプレートファイルに含まれる変数(以下、テンプレートファイルで使う変数を単に変数といいます)を取得します
#  * setメソッドで変数に値を代入することができます
#  * generateメソッドでdocxファイルを生成します
class MyDocx

  #== 変数を定義する正規表現
  #=== 変数の定義
  # * @@で始まり、@@で終わる
  # * 半角アルファベットの大文字・小文字またはアンダーバーで始まる
  # * 2文字目以降は半角アルファベットの大文字・小文字アンダーバーのほかに数字とピリオドを使うことができる
  # * 最初のピリオドから次のピリオドないし最後の@@までの文字列をプロパティという
  #   例:: @@hello.text@@
  #   - .checkboxプロパティ 値をStringの"1"に指定すると☑に置換えます。それ以外の値は☐に置換えます
  #   - .textプロパティ 改行も含めて再現します
  VAR_REGEX = Regexp.new('@@[a-zA-Z_][a-zA-Z0-9_.]+?@@')

  #== initialize
  # インスタンスの初期化
  # Param:: path_to_templateはテンプレートファイルの場所を指定します
  # テンプレートファイルに半角スペースなどを含んでいると生成されたdocxにエラーが出ます
  def initialize(path_to_template)
    @keys_index = {}
    @filename = File.basename(path_to_template)
    @dir = File.dirname(path_to_template)
    set_document_xml(path_to_template)
    set_keys_index
  end

  #== set
  # 変数に値を代入します
  # Params:: key, valueともにString valueを指定しない場合は''になります
  # Return:: setに成功したらtrue、失敗したらfalseが返ります
  # 典型的にはkeyが存在しない場合を想定しています
  def set(key, value = '')
    value = set_checkbox_value(key, value)
    if key.gsub(/@@/, '').split('.')[1] == 'text'
      replace_br(key, value)
    else
      replace(key, value)
    end
  end

  #== keys
  # 変数の一覧をArrayで返します
  # Return:: 変数の一覧をArrayで返します
  def keys
    @keys_index.map do |key, value|
      key
    end
  end

  #== keys_index
  # 変数と変数が含まれている場所です
  # Return:: 形式は変数をkey、対応する場所のArray(同じ変数がテンプレートファイル内に複数存在する可能性があります)をvalueとしたハッシュ形式です。デバッグ用。
  def keys_index
    @keys_index
  end

  #== all_text
  # すべてのテキストをArrayで返します。今のところヘッダー・フッターは未対応です。デバッグ用。
  def all_text
    @document_xml.xpath("//w:t").map do |t_node|
      t_node.content
    end
  end

  #== to_html
  # ydocxというパーサーを介して<div>タグで囲んだhtmlを返します
  # オプションで<div>タグのclass名を指定できます
  def to_html(class_name='')
    ydocx = YDocx::Document.open File.join(@dir, @filename)
    html = Nokogiri::HTML ydocx.to_html
    nodes = html.xpath("//body").children
    myhtml = Nokogiri::HTML::DocumentFragment.parse "<div></div>"
    myhtml.child['class'] = class_name unless class_name.empty?
    myhtml.child << nodes
    myhtml.to_s
  end

  #== generate
  # @document_xmlを使ってdocxファイルを生成します
  # docxファイルはテンプレートファイルと同じディレクトリに生成されます
  # もし同じファイル名のファイルが存在していた場合はそのファイルを上書きします
  # Param:: filenameにdocx拡張子をつけた名前がファイル名となります
  # もしfilenameを指定しない場合はoutput_元のファイル名.docxというファイルになります
  # Return: パス付きのfilenameを値として返します
  def generate(filename = 'output_' + @filename)
    File.delete(filename) if File.exist?(filename)
    buffer = Zip::OutputStream.write_buffer(::StringIO.new('')) do |out|
      Zip::InputStream.open(File.join(@dir, @filename)) do |input|
        while (entry = input.get_next_entry)
          out.put_next_entry(entry.name)
          if entry.name == 'word/document.xml'
            out.write @document_xml.to_xml
          else
            out.write input.read
          end
        end
      end
    end
    File.open(File.join(@dir, filename), 'wb') {|f| f.write(buffer.string)}
    File.join @dir, filename
  end

  private
  def set_document_xml(path_to_template)
    Zip::File.open(path_to_template) do |zip_files|
      document_file = zip_files.find_entry('word/document.xml')
      @document_xml = Nokogiri::XML document_file.get_input_stream.read
    end
  end

  def set_keys_index
    i = 0
    @document_xml.xpath("//w:t").each do |t_node|
      text = t_node.content
      if VAR_REGEX =~ text
        text.scan(VAR_REGEX).each do |t|
          @keys_index[t] ||= []
          @keys_index[t] << i
        end
      end
      # t_node.set_attribute("text_no" , i.to_s)
      i += 1
    end
  end

  def set_checkbox_value(key, value)
    if key.gsub(/@@/, '').split('.')[1] == 'checkbox'
      value = (value == "1") ? "☑" : "☐"
    end
    value
  end

  def replace(key, value)
    index = @keys_index[key]
    unless index == nil
      index.each do |num|
        text = @document_xml.xpath("//w:t")[num].content
        text.gsub!(key, value)
        @document_xml.xpath("//w:t")[num].content = text
      end
      true
    else
      false
    end
  end

  def replace_br(key, value)
    index = @keys_index[key]
    unless index == nil
      index.each do |num|
        index_node = @document_xml.xpath("//w:t")[num].parent
        index_p_node = index_node.parent
        @document_xml.xpath("//w:t")[num].remove
        frag = Nokogiri::XML::DocumentFragment.new @document_xml
        value.split("\n").each do |t|
          run_node = index_node.dup
          p_node = index_p_node.dup
          node = Nokogiri::XML::Node.new "t", @document_xml 
          node['prefix'] = "w"
          node.content = t
          run_node << node
          p_node << run_node
          frag << p_node
        end
        index_p_node.add_next_sibling frag
        index_p_node.remove
      end
      set_keys_index
      true
    else
      false
    end
  end

  # def br_node
  # br_node = Nokogiri::XML::Node.new "br", @document_xml
  # br_node['prefix'] = "w"
  # br_node
  # end

  # def _run_node
  # run_node = Nokogiri::XML::Node.new "r", @document_xml
  # run_node['prefix'] = "w"
  # run_node
  # end
end 
