require "test_helper"

describe Munger::Data do
  include MungerSpecHelper

  before(:each) do
    @data = Munger::Data.new(:data => test_data)
  end

  it "must accept an array of hashes" do
    Munger::Data.new(:data => test_data).must_be :valid?
  end

  it "must be able to set data after init" do
    m = Munger::Data.new
    m.data = test_data
    m.must_be :valid?
  end

  it "must be able to set data in init block" do
    m = Munger::Data.new do |d|
      d.data = test_data
    end
    m.must_be :valid?
  end

  it "must be able to add more data after init" do
    m = Munger::Data.new
    m.data = test_data
    m.add_data more_test_data
    m.must_be :valid?
    additional_names = m.data.select { |r| r[:name] == 'David' || r[:name] == 'Michael' }
    additional_names.size.must_equal(4)
  end

  it "must be able to add data without initial data" do
    m = Munger::Data.new
    m.add_data more_test_data
    m.must_be :valid?
    m.size.must_equal(4)
  end

  it "must be able to extract columns from data" do
    @titles = @data.columns
    @titles.size.must_equal(4)
    @titles.must_include(:name)
    @titles.must_include(:score)
    @titles.must_include(:age)
  end

  it "must be able to add a new column with a default value" do
    @data.add_column('new_column', :default => 1)
    @data.data.first['new_column'].must_equal(1)
  end

  it "must be able to add a new column with a block" do
    @data.add_column('new_column') { |c| c.age + 1 }
    @data.data.first['new_column'].must_equal(24)
  end

  it "must be able to add multiple new columns with defaults" do
    @data.add_column(['col1', 'col2'], :default => [1, 2])
    @data.data.first['col1'].must_equal(1)
    @data.data.first['col2'].must_equal(2)
  end

  it "must be able to add multiple new columns with a block" do
    @data.add_column(['col1', 'col2']) { |c| [c.age * 2, c.score * 3]}
    @data.data.first['col1'].must_equal(46)
    @data.data.first['col2'].must_equal(36)
  end

  it "must work with add_columns, too" do
    @data.add_columns(['col1', 'col2'], :default => [1, 2])
    @data.data.first['col1'].must_equal(1)
    @data.data.first['col2'].must_equal(2)
  end

  it "must be able to transform a column" do
    @data.data.first[:age].must_equal(23)
    @data.transform_column(:age) { |c| c.age * 2 }
    @data.data.first[:age].must_equal(46)
  end

  it "must be able to transform multiple rows" do
    @data.data.first[:age].must_equal(23)
    @data.data.first[:score].must_equal(12)
    @data.transform_columns([:age, :score]) { |c| [c.age * 2, c.score * 3] }
    @data.data.first[:age].must_equal(46)
    @data.data.first[:score].must_equal(36)
  end

  it "must be able to filter the data down" do
    orig_size = @data.size
    @data.filter_rows { |r| r.age < 30 }
    @data.size.must_be :<, orig_size
    @data.size.must_equal(4)
  end

  it "must be able to pivot the data (1 column)" do
    orig_size = @data.size
    new_keys = @data.pivot(:day, :name, :score)
    @data.size.must_be :<, orig_size
    new_keys.must_include(1, 2)
    scott = @data.data.select { |r| r.name == 'Scott' }.first
    scott[1].must_equal(43)
  end

  it "must be able to pivot the data with average aggregation" do
    new_keys = @data.pivot(:day, :name, :score, :average)
    new_keys.must_include(1, 2)
    scott = @data.data.select { |r| r.name == 'Scott' }.first
    scott[1].must_equal(21)
  end

  it "must be able to pivot the data with count aggregation" do
    new_keys = @data.pivot(:day, :name, :score, :count)
    scott = @data.data.select { |r| r.name == 'Scott' }.first
    scott[1].must_equal(2)
  end

  it "must be able to pivot the data in three dimensions (1 col, 2 row)" do
    new_keys = @data.pivot(:name, [:score, :age], :score, :count)
    alice = @data.data.select { |r| r.name == 'Alice' }.first
    alice.Alice.must_equal(2)
  end

  it "must be able to add a column then pivot the data (1 column)" do
    @data.add_column(:day_of_week) { |c| Date::DAYNAMES[c.day] }
    orig_size = @data.size
    new_keys = @data.pivot(:day_of_week, :name, :score)
    @data.size.must_be :<, orig_size
    new_keys.must_include("Monday", "Tuesday")
    alice = @data.data.select { |r| r.name == 'Alice' }.first
    alice["Monday"].must_equal(12)
    alice["Tuesday"].must_equal(24)
  end

  # like sql group command, give aggregation block
  it "must be able to group the data like sql" do
    @data.group(:name)
    @data.size.must_equal(6)
  end

  it "must be able to group on multiple columns" do
    @data.group([:age, :score], :count => :day, :sum => :day, :average => :score)
    alice = @data.data.select { |r| (r.score == 12) && (r.age == 33)}.first
    alice.count_day.must_equal(2)
    alice.sum_day.must_equal(3)
    alice.average_day.must_equal(nil)
  end

  it "must be able to group with a proc aggregation" do
    pr = Proc.new {|arr| arr.inject(0) { |a,b| a + (b*2) }}
    @data.group([:age, :score], :sum => :day, ['test', pr] => :age)
    alice = @data.data.select { |r| (r.score == 12) && (r.age == 33)}.first
    alice.test_age.must_equal(132)
    alice.sum_day.must_equal(3)
  end

  it "must be able to output an array" do
    array = @data.to_a
    array.must_be_kind_of(Array)
    array.first.size.must_equal(@data.columns.size)
  end

  it "must be able to output a filtered array" do
    array = @data.to_a([:name, :age])
    array.must_be_kind_of(Array)
    array.first.size.must_equal(2)
    scotts = array.select { |a| a.include?('Scott') }
    scotts.first.must_include('Scott', 23)
  end

  it "must be able to pivot the data in three dimensions (2 col, 1 row)"

  it "must be able to pivot the data in four dimensions (2 col, 2 row)"

  it "must be able to add two Munger::Datas together if they have the same columns"

  it "must be able to add data and check if it is Munger::Data"

  it "(maybe) must be able to zip two Munger::Datas together given a unique key column in each"

end
