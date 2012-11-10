#encoding: utf-8
require 'zipruby'
require 'nokogiri'
class MyDocx
  VAR_REGEX = Regexp.new('@@[a-zA-Z_][a-zA-Z0-9_.]+?@@')
  def initialize(path_to_template)
    @keys_index = {}
    @filename = File.basename(path_to_template)
    @dir = File.dirname(path_to_template)
    set_document_xml(path_to_template)
    set_keys_index
  end

  def set(key, value = '')
    value = set_checkbox_value(key, value)
    if key.gsub(/@@/, '').split('.')[1] == 'text'
      replace_br(key, value)
    else
      replace(key, value)
    end
  end

  def keys
    @keys_index.map do |key, value|
      key
    end
  end

  def keys_index
    @keys_index
  end

  def all_text
    @document_xml.xpath("//w:t").map do |t_node|
      t_node.content
    end
  end

  def generate(filename = 'output_' + @filename)
    File.delete(filename) if File.exist?(filename)
    Zip::Archive.open(File.join(@dir, @filename)) do |ar1|
      Zip::Archive.open(File.join(@dir,filename), Zip::CREATE) do |ar2|
        ar2.update(ar1)
        ar2.replace_buffer('word/document.xml', @document_xml.to_xml)
      end
    end
    File.join @dir, filename
  end

  private
  def set_document_xml(path_to_template)
    zip = Zip::Archive.open(path_to_template)
    document_file = zip.fopen('word/document.xml')
    @document_xml = Nokogiri::XML document_file.read
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
        @document_xml.xpath("//w:t")[num].remove
        frag = Nokogiri::XML::DocumentFragment.new @document_xml
        value.split("\n").each do |t|
          run_node = index_node.dup
          node = Nokogiri::XML::Node.new "t", @document_xml 
          node['prefix'] = "w"
          node.content = t
          run_node << node
          frag << br_node
          frag << run_node
        end
        index_node.add_next_sibling frag
      end
      true
    else
      false
    end
    set_keys_index
    value
  end

  def br_node
    br_node = Nokogiri::XML::Node.new "br", @document_xml
    br_node['prefix'] = "w"
    br_node
  end
  def _run_node
    run_node = Nokogiri::XML::Node.new "r", @document_xml
    run_node['prefix'] = "w"
    run_node
  end
end 
