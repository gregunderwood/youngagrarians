class CategoriesController < ApplicationController
  
  # GET /categories
  # GET /categories.json
  def index    
    @categories = Category.all    
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.create(params[:category])
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])
    @category.update_attributes(params[:category])
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
  end
end
