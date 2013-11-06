class SubcategoriesController < ApplicationController  
  def index
    @subcategories = Subcategory.all
  end
end
