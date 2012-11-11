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
      @mydocx.set( '@@hello@@', 'HELLOOOO').should be_true
    end

    it "get false when try to set incollect key and value" do
      @mydocx.set( '@@HELLO@@', 'HELLOOOO').should be_false
    end
  end

  describe ".generate" do
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
      @mydocx.all_text.join.should include '☑'
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

   it 'dosnt contain \n when replace \n\r to <w:br />' do
     @mydocx.set('@@hello.text@@', "こんにちは \n world")
     @mydocx.generate
     output_mydocx = MyDocx.new('spec/fixtures/output_helloworld.docx')
     output_mydocx.all_text.join.should_not include "\n"
   end 
  end
end
