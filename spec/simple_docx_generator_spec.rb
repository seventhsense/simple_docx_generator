#encoding: utf-8
require 'spec_helper'
describe SimpleDocxGenerator do
  before do
    @mydocx = MyDocx.new 'spec/fixtures/helloworld.docx'
  end
  describe ".keys" do
    it 'get keys collect' do
      @mydocx.keys.should == %w[@@hello@@ @@world@@]
    end
  end
  describe ".keys_index" do
    it 'get keys_index collect' do
      @mydocx.keys_index.should == {"@@hello@@"=>[0, 1], "@@world@@"=>[0]}
    end
  end
  describe ".all_text" do
    it 'get all_text collect' do
     @mydocx.all_text.should == ["@@hello@@ @@world@@", " @@hello@@"] 
    end
  end
  describe ".set" do
    it "set collectly key and value" do
      @mydocx.set( '@@hello@@', 'HELLOOOO')
      @mydocx.all_text.should == ["HELLOOOO @@world@@", " HELLOOOO"] 
    end
  end
  describe ".generate" do
    it 'generate collect docx file' do
      @mydocx.set( '@@hello@@', 'HELLOOOO')
      @mydocx.generate
      output_mydocx = MyDocx.new('spec/fixtures/output_helloworld.docx')
      output_mydocx.all_text.should == ["HELLOOOO @@world@@", " HELLOOOO"]
    end
  end
end
