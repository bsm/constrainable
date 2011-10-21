ENV["RAILS_ENV"] ||= 'test'

$: << File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'bundler/setup'
Bundler.require :default, :test

require 'active_support'
require 'active_record'
require 'active_record/fixtures'
require 'action_view'
require 'rspec'
require 'rspec/rails/adapters'
require 'rspec/rails/fixture_support'
require 'bsm/constrainable'

ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.configurations["test"] = { 'adapter' => 'sqlite3', 'database' => ":memory:" }
ActiveRecord::Base.establish_connection :test
ActiveRecord::Base.connection.create_table :posts do |t|
  t.string  :title
  t.string  :body
  t.integer :author_id
  t.string  :category
  t.timestamps
end
ActiveRecord::Base.connection.create_table :authors do |t|
  t.string  :name
end

RSpec.configure do |c|
  c.fixture_path = File.dirname(__FILE__) + '/fixtures'
end

class String

  def clean_sql
    squish.gsub(/[`"]/, "").gsub(/\.0+/, "")
  end

end

class Author < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :author

  constrainable do
    integer   :id, :author_id, :with => [:in, :not_in]
    timestamp :created, :using => :created_at, :with => [:gt, :lt, :between]
    match     :author_name, :as => :string, :using => proc { Author.scoped.table[:name] }, :scope => proc { includes(:author) }
    string    :category
  end

  scope :articles, proc { where(:category => "article") }
end

