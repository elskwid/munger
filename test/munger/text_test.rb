require "test_helper"

describe Munger::Render::Text do
  include MungerSpecHelper

  before(:each) do
    @data = Munger::Data.new(:data => test_data)
    @report = Munger::Report.new(:data => @data)
  end

  it "should accept a Munger::Report object" do
    Munger::Render::Text.new(@report.process).must_be :valid?
  end

  it "should render a basic text table" do
    @render = Munger::Render::Text.new(@report.process)
    count = @report.rows
    text = @render.render
    text.split("\n").size.must_be :>, count
  end

end
