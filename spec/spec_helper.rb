ENV["RAILS_ENV"] ||= 'test'

$: << File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default, :test

require 'active_support'
require 'active_record'
require 'active_record/fixtures'
require 'action_view'
require 'rspec'
require 'rspec/rails/adapters'
require 'rspec/rails/fixture_support'
require 'bsm/constrainable'

SPEC_DATABASE     = File.dirname(__FILE__) + '/tmp/test.sqlite3'
Time.zone_default = Time.__send__(:get_zone, "UTC")
ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.configurations["test"] = { 'adapter' => 'sqlite3', 'database' => SPEC_DATABASE }

RSpec.configure do |c|
  c.fixture_path = File.dirname(__FILE__) + '/fixtures'
  c.before(:all) do
    FileUtils.mkdir_p File.dirname(SPEC_DATABASE)
    base = ActiveRecord::Base
    base.establish_connection(:test)
    base.connection.create_table :posts do |t|
      t.string  :title
      t.string  :body
      t.integer :author_id
      t.string  :category
      t.timestamps
    end
    base.connection.create_table :authors do |t|
      t.string  :name
    end
  end

  c.after(:all) do
    FileUtils.rm_f(SPEC_DATABASE)
  end
end

class String

  def clean_sql
    gsub(/[`"]/, "").gsub(/\.0+/, "")
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

