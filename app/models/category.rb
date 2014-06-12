class Category < ActiveRecord::Base
  has_many :topics, dependent: :nullify

  validates :name, presence: true
  validates :slug, presence: true, format: { with: /\A[a-zA-Z0-9-]+\z/ }

  def count(category_id, category_slug)
    case category_slug.to_s
    when 'S'
      Post.all.where(:category_id => category_id).count
    when 'T'
      Topic.all.where(:category_id => category_id).count
    end
  end
end
