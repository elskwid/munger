require "minitest/autorun"
require "minitest/pride"
require "munger"

require "fileutils"
require "logger"
require "pp"
require "date"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

module MungerSpecHelper
  def test_data
    [{:name => "Scott", :age => 23, :day => 1, :score => 12},
     {:name => "Chaz",  :age => 28, :day => 1, :score => 12},
     {:name => "Scott", :age => 23, :day => 2, :score => 1},
     {:name => "Janet", :age => 32, :day => 2, :score => 24},
     {:name => "Rich", :age => 32, :day => 2, :score => 14},
     {:name => "Gordon", :age => 33, :day => 1, :score => 21},
     {:name => "Scott", :age => 23, :day => 1, :score => 31},
     {:name => "Alice", :age => 33, :day => 1, :score => 12},
     {:name => "Alice", :age => 34, :day => 2, :score => 12},
     {:name => "Alice", :age => 33, :day => 2, :score => 12}
      ]
  end

  def more_test_data
    [{:name => "David", :age => 40, :day => 1, :score => 12},
     {:name => "Michael",  :age => 32, :day => 2, :score => 20},
     {:name => "David", :age => 40, :day => 2, :score => 13},
     {:name => "Michael",  :age => 28, :day => 1, :score => 15}]
  end

  def invalid_test_data
    ["one", "two", "three"]
  end

  def test_ar_data
    test_data.map{|r| ARLike.new(r)}
  end

end

# Hack to provide assertion for tags without needing
# hpricot or Nokogiri
module Minitest::Assertions
  def assert_has_tag(tag, html, options = {})
    tag = tag.split(".").join("|") if tag.include?(".")
    # ignore options for now
    assert html.match(/#{tag}/)
  end

  def refute_has_tag(tag, html, options = {})
    refute html.match(/#{tag}/)
  end
end

String.infect_an_assertion :assert_has_tag, :must_have_tag
String.infect_an_assertion :refute_has_tag, :wont_have_tag
