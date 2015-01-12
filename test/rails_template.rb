
# Generate some test models

# Post
generate :model, "post title:string body:text published_at:datetime author_id:integer category_id:integer"
post_code = <<-CODE
  belongs_to :author, :class_name => 'User'
  belongs_to :category
  accepts_nested_attributes_for :author

  validates_presence_of :author, :category, :title, :published_at
CODE
inject_into_file 'app/models/post.rb', post_code, :after => "class Post < ActiveRecord::Base\n"

# Category
generate :model, 'category name:string description:text'
category_code = <<-CODE
  has_many :posts

  validates_presence_of :name
CODE
inject_into_file 'app/models/category.rb', category_code, :after => "class Category < ActiveRecord::Base\n"

# User
generate :model, "user first_name:string last_name:string username:string type:string"
user_code = <<-CODE
  has_many :posts, :foreign_key => 'author_id'

  validates_presence_of :first_name, :last_name, :username
  validates_length_of :username, :minimum => 3
CODE
inject_into_file 'app/models/user.rb', user_code, :after => "class User < ActiveRecord::Base\n"

# Author < User
create_file 'app/models/author.rb', "class Author < User; end"
# Publisher < User
create_file 'app/models/publisher.rb', "class Publisher < User; end"


# NotAModel
create_file 'app/models/not_a_model.rb', "class NotAModel; end"

# Version (paper_trail)
generate :model, "version item_id:integer item_type:string"

# Add active_sanity
append_file 'Gemfile', "gem 'active_sanity', :path => '../../'"

run "bundle"
rake "db:migrate"
