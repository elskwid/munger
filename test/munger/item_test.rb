require "test_helper"

describe Munger::Item do
  include MungerSpecHelper

  before(:all) do
    @data = Munger::Data.new(:data => test_data)
  end

  it "must accept a hash with symbols" do
    hash = {'key1' => 'value1', 'key2' => 'value2'}
    item = Munger::Item.ensure(hash)
    item.key1.must_equal('value1')
  end

  it "must accept a hash with strings" do
    hash = {:key1 => 'value1', :key2 => 'value2'}
    item = Munger::Item.ensure(hash)
    item.key1.must_equal('value1')
    item.key2.wont_equal('value1')
    item.key3.must_equal(nil)
  end

  it "must accept mixed types" do
    hash = {:key1 => 'value1', 'key2' => 'value2'}
    item = Munger::Item.ensure(hash)
    item.key1.must_equal('value1')
    item.key2.must_equal('value2')
  end

  it "must be able to access hash values indifferently" do
    hash = {:key1 => 'value1', 'key2' => 'value2'}
    item = Munger::Item.ensure(hash)
    item['key1'].must_equal('value1')
    item[:key2].must_equal('value2')
  end

  it "must return a hash after being initialized with a hash" do
    hash = {:key1 => "value1", :key2 => "value2"}
    Munger::Item.ensure(hash).to_hash.must_be_kind_of(Hash)
  end

end
