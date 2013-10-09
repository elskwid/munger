require "test_helper"

describe Munger::Render::CSV do
  include MungerSpecHelper

  before(:each) do
    @data = Munger::Data.new(:data => test_data + [{:name => 'Comma, Guy', :age => 100, :day => 0, :score => 0}])
    @report = Munger::Report.new(:data => @data)
  end

  it "should accept a Munger::Report object" do
    Munger::Render::Text.new(@report.process).must_be :valid?
  end

  it "should render a basic text table" do
    @render = Munger::Render::CSV.new(@report.process)
    count = @report.rows
    text = @render.render
    text.split("\n").size.must_be :>, count
  end

  it "should quote data with commas" do
    @render = Munger::Render::CSV.new(@report.process)
    text = @render.render
    text.must_match /"Comma, Guy"/
  end
end
