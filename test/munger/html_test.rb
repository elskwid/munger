require "test_helper"

describe Munger::Render::Html do
  include MungerSpecHelper

  before(:each) do
    @data = Munger::Data.new(:data => test_data)
    @report = Munger::Report.new(:data => @data)
  end

  it "must accept a Munger::Report object" do
    Munger::Render::Html.new(@report.process).must_be :valid?
  end

  it "must render a basic html table" do
    @render = Munger::Render::Html.new(@report.process)
    count = @report.rows

    html = @render.render
    html.must_have_tag('table')
    html.must_have_tag('tr', :count => count + 1) # rows plus header
  end

  it "must render a thead section for the table" do
    @render = Munger::Render::Html.new(@report.process)
    html = @render.render
    html.must_have_tag('thead', :count => 1)
  end

  it "must render a tbody section for the table" do
    @render = Munger::Render::Html.new(@report.process)
    html = @render.render
    html.must_have_tag('tbody', :count => 1)
  end

  it "must accept a custom table class" do
    rep = Munger::Render::Html.new(@report.process, :classes => {:table => 'helloClass'})
    html = rep.render
    html.must_have_tag('table.helloClass')
  end

  it "must use aliased column titles" do
    @report = @report.columns([:age, :name, :score])
    @report.column_titles = {:age => "The Age", :name => "The Name"}
    html = Munger::Render::Html.new(@report.process).render
    html.must_match(/The Age/)
  end

  it "must render columns in the right order" do
    @report = @report.columns([:age, :name]).process
    html = Munger::Render::Html.new(@report).render
    html.must_have_tag('th', :count => 2) # rows plus header
    html.must_match(/age(.*?)name/)
  end

  it "must render groups" do
    @report = @report.subgroup(:age).aggregate(:sum => :score).process
    html = Munger::Render::Html.new(@report).render
    html.must_match(/151/) # only in the aggregate group
    html.must_have_tag('tr.group0', :count => 1)
    html.must_have_tag('tr.group1', :count => 9)
  end

  it "must render group headers" do
    @report = @report.subgroup(:age, :with_headers => true).process
    html = Munger::Render::Html.new(@report).render
    html.must_have_tag('tr.groupHeader1', :count => 9)
  end

  it "must render cell styles" do
    @report.process.style_rows('over_thirty') { |row| row.age > 29 }

    html = Munger::Render::Html.new(@report).render
    html.must_have_tag('tr.over_thirty', :count => 6)
  end

  it "must render row styles" do
    @report.process.style_cells('highlight', :only => :age) { |c, r| c == 32 }
    html = Munger::Render::Html.new(@report).render
    html.must_have_tag('td.highlight')
  end

  it "must render column styles"

  it "must render default css if you ask"

end
