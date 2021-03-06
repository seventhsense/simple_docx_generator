#encoding: utf-8
require 'spec_helper'
describe MyDocx do
  before do
    @mydocx = MyDocx.new 'spec/fixtures/helloworld.docx'
  end

  describe ".keys" do
    it 'get keys collect' do
      @mydocx.keys.should include("@@hello@@","@@world@@")
    end
  end
  describe ".keys_index" do
    it 'get keys_index collect' do
      @mydocx.keys_index.should include({"@@hello@@"=>[0, 1]})
    end
  end
  describe ".all_text" do
    it 'get all_text collect' do
     @mydocx.all_text.should include("@@hello@@ @@world@@", " @@hello@@") 
    end
  end
  describe ".set" do
    it "set collectly key and value" do
      @mydocx.set( '@@hello@@', 'HELLOOOO')
      @mydocx.all_text.join.should include "HELLOOOO" 
    end
    it "set collectly key and value" do
      @mydocx.set( '@@hello@@', 'HELLOOOO')
      @mydocx.all_text.join.should_not include "@@hello@@" 
    end

    it "get true when collectly set key and value" do
      @mydocx.set( '@@hello@@', 'HELLOOOO').should be true
    end

    it "get false when try to set incollect key and value" do
      @mydocx.set( '@@HELLO@@', 'HELLOOOO').should be false
    end
  end

  describe ".generate" do
    it 'generate new file with output_' do
      @mydocx.set( '@@hello@@', 'HELLOOOO')
      @mydocx.generate
      expect(File).to exist ("spec/fixtures/output_helloworld.docx")
    end
    it 'generate collect docx file' do
      @mydocx.set( '@@hello@@', 'HELLOOOO')
      @mydocx.generate
      output_mydocx = MyDocx.new('spec/fixtures/output_helloworld.docx')
      output_mydocx.all_text.join.should include "HELLOOOO"
    end
  end

  describe "set_checkbox_value" do
    it 'get key for checkbox property' do
      @mydocx.keys.should include "@@hello.checkbox@@"
    end
    it 'set ☑ when checkbox is set as "1"' do
      @mydocx.set('@@hello.checkbox@@', "1")
      @mydocx.generate
      output_mydocx = MyDocx.new('spec/fixtures/output_helloworld.docx')
      output_mydocx.all_text.join.should include '☑'
    end
    it 'set ☐ when checkbox is set as "0"' do
      @mydocx.set('@@hello.checkbox@@', "0")
      @mydocx.all_text.join.should include '☐'
    end
  end

  describe ".replace_rb" do
   # it 'replace \n\r to <w:br />' do
     # @mydocx.set('@@hello.text@@', "こんにちは \n world")
     # @mydocx.generate
     # output_mydocx = MyDocx.new('spec/fixtures/output_helloworld.docx')
     # output_mydocx.all_text.join.should include "<w:br />"
   # end 

   it 'doesnt contain \n when replace \n\r to <w:br />' do
     @mydocx.set('@@hello.text@@', "こんにちは \n world")
     @mydocx.generate
     output_mydocx = MyDocx.new('spec/fixtures/output_helloworld.docx')
     output_mydocx.all_text.join.should_not include "\n"
   end 

   it 'does with fax cover template without no word error' do
     @mydocx2 = MyDocx.new('spec/fixtures/Fax_cover_sheet.docx')
     @mydocx2.set('@@memo.text@@', "拝啓 \n お元気ですか。")
     @mydocx2.generate
     output_mydocx2 = MyDocx.new('spec/fixtures/output_Fax_cover_sheet.docx')
     output_mydocx2.all_text.join.should include "拝啓", "お元気ですか"
   end
  end

  describe ".to_html" do
    it 'contain @@hello@@ before set' do
      html = @mydocx.to_html
      html.should include "@@hello@@"
    end
    it 'contain <div>' do
      html = @mydocx.to_html
      html.should include "<div>"
    end

    it 'set class with option' do 
      html = @mydocx.to_html "myclass"
      html.should include '<div class="myclass">'
    end
  end

  describe "access @document_xml" do
    it "can access @document_xml" do
      document_xml = @mydocx.document_xml
      document_xml.should include '<w:t>@@hello.text@@ @@hello.text@@ @@hello2.text@@</w:t>'
      # File.open 'spec/fixtures/old_document_xml.xml', 'w' do |text|
        # text.puts document_xml
      # end
    end

    it "can save new document_xml" do
      xml = File.read 'spec/fixtures/document_xml.xml'
      @mydocx.update_xml xml
      keys = @mydocx.keys
      old_xml = File.read 'spec/fixtures/old_document_xml.xml'
      @mydocx.update_xml old_xml
      keys.should include "@@hello3@@", "@@world4@@"
    end
  end

  # describe "keys_index" do
    # keys_index = @mydocx.keys_index
    # p keys_index
  # end
end

