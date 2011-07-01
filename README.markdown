# Constrainable

Simple filtering for ActiveRecord. Sanitizes simple and readable query parameters -great for building APIs & HTML filters.

## Straight to the point. Examples:

Let's asume we have a model called Post, defined as:
    Post(id: integer, title: string, body: string, author_id: integer, category: string, created_at: datetime, updated_at: datetime)

In the simplest possible case you can define a few attributes and start filtering:

    class Post < ActiveRecord::Base

      constrainable do
        fields :id, :author_id
      end

    end

    # Examle request:
    #   GET /posts?where[id][not_eq]=1&where[author_id][eq]=2
    # Params:
    #   "where" => { "id" => { "not_eq" => "1" }, "author_id" => { "eq" => "2" } }

    Post.constrain(params[:where])
    # => SELECT posts.* FROM posts WHERE id != 1 AND author_id = 2

By default, only *eq* and *not_eq* operations are enabled, but there are plenty more:

    class Post < ActiveRecord::Base

      constrainable do
        fields :id, :author_id, :with => [:in, :not_in, :gt, :gteq, :lt, :lteq]
        fields :created_at, :with => [:between]
      end

    end

    # Example request (various notations are accepted):
    #   GET /posts?
    #     where[id][not_in]=1|2|3|4&
    #     where[author_id][in][]=1&
    #     where[author_id][in][]=2&
    #     where[created_at][between]=2011-01-01...2011-02-01

Want to *alias* a column? Try this:

    class Post < ActiveRecord::Base

      constrainable do
        timestamp :created, :using => :created_at, :with => [:lt, :lte, :between]
      end

    end
    # Example request:
    #   GET /posts?where[created][lt]=2011-01-01

What about associations?

    class Post < ActiveRecord::Base
      belongs_to :author

      constrainable do
        string :author_name, :using => lambda { Author.arel_table[:name] }, :with => [:matches], :scope => lambda { includes(:author) }
      end
    end
    # Example request:
    #   GET /posts?where[author][matches]=%tom%

    Post.constrain(params[:where])
    # => SELECT posts.* FROM posts LEFT OUTER JOIN authors ON authors.id = posts.author_id WHERE authors.name LIKE '%tom%'

Integration with controllers, views & filter forms:

    # In app/models/post.rb
    class Post < ActiveRecord::Base
      constrainable do
        fields :author_id
      end
    end

    # In app/controllers/posts_controller.rb
    class PostsController < ApplicationController
      respond_to :html

      def index
        @filters = Post.constrainable.fliter(params[:where])
        @posts = Post.constrain(@filters)
        respond_with @posts
      end
    end

    # In app/views/posts/index.html.haml
    = form_for @filters, :as => :where do
      = f.collection_select :"author_id[eq]", Author.order('name'), :id, :name
