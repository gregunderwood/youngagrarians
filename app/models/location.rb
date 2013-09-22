class Location < ActiveRecord::Base
  include Gmaps4rails::ActsAsGmappable
  acts_as_gmappable :process_geocoding => :process

  belongs_to :category
  has_and_belongs_to_many :subcategories

  attr_accessible :latitude, :longitude, :gmaps, :address, :name, :content, :bioregion, :phone, :url, :fb_url, 
                  :twitter_url, :description, :is_approved, :category_id, :resource_type, :email, :postal, :show_until,
                  :street_address, :city, :country_code, :country_name, :province_code, :province_name

  def gmaps4rails_address
    "#{address}"
  end

  def process
    if address.nil? || address.empty?
      return false
    end
    true
  end

  def as_json(options = nil)
    super :include => [ :category, :subcategories ], :except => [ :category_id, :is_approved ]
  end

  def self.search(term, province = nil)
    results = []
    if not term.nil? and not term.empty?
      category = Category.find_by_name term
      subcategory = Category.find_by_name term
      if category
        results += Location.where(:is_approved => true).where('category_id', category.id).all        
      end
      if subcategory
        results += Location.joins(:subcategories).where(:is_approved => true).where('subcategories.id = ?', subcategory.id).all
      end
      term = "%#{term}%"
      results += Location.where(:is_approved => true)
        .where("name LIKE ? OR address LIKE ? OR postal LIKE ? OR content LIKE ? OR bioregion LIKE ? OR phone LIKE ? OR description LIKE ?", 
               term, term, term, term, term, term, term).all 
    end
    return results.uniq
  end
end

 