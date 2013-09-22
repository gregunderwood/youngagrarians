class Category < ActiveRecord::Base
  has_many :locations
  has_many :subcategories
  attr_accessible :name

  def as_json(options)
    super :include => :subcategories
  end
end
