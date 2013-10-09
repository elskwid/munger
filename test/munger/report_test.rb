require "test_helper"

describe Munger::Report do
  include MungerSpecHelper

  before(:each) do
    @data = Munger::Data.new(:data => test_data)
    @report = Munger::Report.new(:data => @data)
  end

  it "must accept a Munger::Data object" do
    Munger::Report.new(:data => @data).must_be :valid?
  end

  it "must accept a array of hashes" do
    Munger::Report.new(:data => test_data).must_be :valid?
    Munger::Report.new(:data => invalid_test_data).wont_be :valid?
  end

  it "must be able to sort fields by array" do
    @report.sort = 'name'
    data = @report.process.process_data
    data.map { |a| a[:data].name }[0, 4].join(',').must_equal('Alice,Alice,Alice,Chaz')

    @report.sort = ['name', 'age']
    data = @report.process.process_data
    data.map { |a| a[:data].age }[0, 4].join(',').must_equal('33,33,34,28')

    @report.sort = [['name', :asc], ['age', :desc]]
    data = @report.process.process_data
    data.map { |a| a[:data].age }[0, 4].join(',').must_equal('34,33,33,28')
  end

  it "must be able to custom sort fields" do
    @report.sort = [['name', Proc.new {|a, b| a[2] <=> b[2]} ]]
    data = @report.process.process_data
    data.map { |a| a[:data].name }[0, 4].join(',').must_equal('Chaz,Rich,Alice,Alice')
  end

  it "must be able to order columns" do
    @report.columns([:name, :age, :score])
    @report.columns.must_equal([:name, :age, :score])
  end

  it "must be able to alias column titles" do
    titles = {:name => 'My Name', :age => 'The Age', :score => 'Super Score'}
    @report.column_titles = titles
    @report.column_titles.must_equal(titles)
  end

  it "must default to all columns" do
    @report.columns.map { |c| c.to_s }.sort.join(',').must_equal('age,day,name,score')
  end


  it "must be able to subgroup data" do
    @report.sort('name').subgroup('name').process
    @report.get_subgroup_rows.size.must_equal(6)
  end

  it "must be able to add subgroup headers"
  #  do
  #   @report.sort('score').subgroup('score', :with_headers => true)
  #   @report.aggregate(:sum => :score).process
  #   puts Munger::Render.to_text(@report)
  # end

  it "must add the grouping name on the group line somewhere"

  it "must be able to subgroup in multiple dimensions"

  it "must be able to aggregate columns into subgroup rows" do
    @report.sort('name').subgroup('name').aggregate(:sum => :score).process
    @report.get_subgroup_rows(1).size.must_equal(6)
    @report.get_subgroup_rows(0).size.must_equal(1)
    @report.get_subgroup_rows(0).first[:data][:score].must_equal(151)
  end

  it "must be able to aggregate multiple columns into subgroup rows" do
    @report.sort('name').subgroup('name').aggregate(:sum => [:score, :age]).process
    data = @report.get_subgroup_rows(0).first[:data]
    data[:score].must_equal(151)
    data[:age].must_equal(294)

    @report.sort('name').subgroup('name').aggregate(:sum => :score, :average => :age).process
    data = @report.get_subgroup_rows(0).first[:data]
    data[:score].must_equal(151)
    data[:age].must_equal(29)
  end

  it "must be able to aggregate with :average" do
    @report.sort('name').subgroup('name').aggregate(:average => :score).process
    @report.get_subgroup_rows(0).first[:data][:score].must_equal(15)
  end

  it "must be able to aggregate with :custom" do
    @report.sort('name').subgroup('name')
    @report.aggregate(Proc.new { |d| d.inject { |t, a| 2 * (t + a) } } => :score).process
    @report.get_subgroup_rows(0).first[:data][:score].must_equal(19508)
  end

  it "must be able to style cells" do
    @report.process
    @report.style_cells('highlight') { |c, r| c == 32 }
    styles = @report.process_data.select { |r| r[:meta][:cell_styles] }
    styles.size.must_equal(2)
  end

  it "must be able to style cells in certain columns" do
    @report.process
    @report.style_cells('highlight', :only => :age) { |c, r| c == 32 }
    @report.style_cells('big', :except => [:name, :day]) { |c, r| c.size > 2 }
    styles = @report.process_data.select { |r| r[:meta][:cell_styles] }
    styles.size.must_equal(10)

    janet = @report.process_data.select { |r| r[:data].name == 'Janet' }.first
    jstyles = janet[:meta][:cell_styles]

    jstyles[:age].sort.join(',').must_equal('big,highlight')
    jstyles[:score].must_equal(["big"])
  end

  it "must be able to style rows" do
    @report.process
    @report.style_rows('over_thirty') { |row| row.age > 29 }
    @report.style_cells('highlight', :only => :age) { |c, r| c == 32 }

    janet = @report.process_data.select { |r| r[:data].name == 'Janet' }.first[:meta]
    janet[:row_styles].must_equal(["over_thirty"])
    janet[:cell_styles].size.must_equal(1)
    janet[:cell_styles][:age].must_equal(["highlight"])
  end

  it "must know when it is processed" do
    @report.processed?.wont_equal(true)
    @report.process
    @report.processed?.must_equal(true)
  end

  it "must be able to style columns"

  it "must be able to attach formatting independent of content"
  # so can format numbers without hurting ability to aggregate correctly
  # or add hyperlinks using data from columns not being shown

  it "must be able to add and retrieve column formatters" do
    @report.column_formatters = {:name => :to_s}
    @report.process
    @report.column_formatters.size.must_equal(1)
    @report.column_formatter(:name).must_equal(:to_s)
  end

  it "must be able to aggregate rows into new column"


end
