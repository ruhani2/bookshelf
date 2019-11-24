class Book < ApplicationRecord
  include ThinkingSphinx::Scopes

  belongs_to :author
  has_attached_file :cover_image, :styles => { :small => "150x150>" }
  do_not_validate_attachment_file_type :cover_image
  sphinx_scope(:cached_books) { |id|
    {:conditions => {:id => id}}
  }
  after_save ThinkingSphinx::RealTime.callback_for(:author)

  ThinkingSphinx::Index.define :book, :with => :real_time do
    # fields
    indexes title, :sortable => true
    indexes description
    indexes author.name, :as => :author, :sortable => true
  
    # attributes
    has author_id,  :type => :integer
    has created_at, :type => :timestamp
    has updated_at, :type => :timestamp
  end

  def author_name=(name)
    self.author = Author.find_or_create_by(name: name)
  end

  def author_name
    self.author ? self.author.name : nil
  end

  private

  def self.cached
    Rails.cache.fetch("books", :expires_in => 1.week) { Book.all }
  end
end
