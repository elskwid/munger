Gem::Specification.new do |s|
  s.platform  =  Gem::Platform::RUBY
  s.name      =  "munger"
  s.version   =  "0.1.4.2"
  s.authors   =  ['Scott Chacon', 'Brandon Mitchell', 'Don Morrison', 'Eric Lindvall']
  s.email     =  "schacon@gmail.com"
  s.summary   =  "A reporting engine in Ruby"
  s.homepage  =  "http://github/schacon/munger"
  s.has_rdoc  =  true

  s.files = [
    "munger.gemspec",
    "Rakefile",
    "README",
    "examples/column_add.rb",
    "examples/development.log",
    "examples/example_helper.rb",
    "examples/sinatra_app.rb",
    "examples/test.html",
    "lib/munger.rb",
    "lib/munger/data.rb",
    "lib/munger/item.rb",
    "lib/munger/render.rb",
    "lib/munger/report.rb",
    "lib/munger/render/csv.rb",
    "lib/munger/render/html.rb",
    "lib/munger/render/sortable_html.rb",
    "lib/munger/render/text.rb"]

  s.test_files = [
    "test/test_helper.rb",
    "test/munger/csv_test.rb",
    "test/munger/data_ar_test.rb",
    "test/munger/data_test.rb",
    "test/munger/html_test.rb",
    "test/munger/item_test.rb",
    "test/munger/new_test.rb",
    "test/munger/render_test.rb",
    "test/munger/report_test.rb",
    "test/munger/text_test.rb"]

  s.add_dependency "builder"

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", "~>5.0.8"
end
