class BusinessesController < ApplicationController
  before_action :business, only: [:show, :edit, :update, :destroy, :add_location, :add_article]

  # GET /businesses
  # GET /businesses.json
  def index
    @businesses = load_businesses
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
  end

  # GET /businesses/new
  def new
    @business = Business.new
    @business.articles.build
    @business.locations.build
  end

  # GET /businesses/1/edit
  def edit
  end

  def add_location
    respond_to do |format|
      if business.locations.create(location_params)
        format.html { redirect_to @business, notice: 'Location was successfully added.' }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit, notice: 'Could not add the location.' }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_article
    respond_to do |format|
      if business.articles.create(url: location_params[:url])
        format.html { redirect_to @business, notice: 'Article was successfully added.' }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit, notice: 'Could not add the article.' }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /businesses
  # POST /businesses.json
  def create
    @business = Business.new(business_params)

    respond_to do |format|
      if @business.save
        format.html { redirect_to @business, notice: 'Business was successfully created.' }
        format.json { render :show, status: :created, location: @business }
      else
        @business.articles.build if @business.articles.empty?
        @business.locations.build if @business.locations.empty?
        format.html { render :new }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to @business, notice: 'Business was successfully updated.' }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to businesses_url, notice: 'Business was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def business
    @business ||= Business.find(params[:id])
  end
  helper_method :business

  # Only allow a list of trusted parameters through.
  def business_params
    params.require(:business).permit(:name, :lonlat, :opengraph_data, :notes,
      locations_attributes: [:name, :address, :id, :_destroy],
      articles_attributes: [:url, :id, :_destroy]
    )
  end

  def search_params
    params.permit(:q, :limit)
  end

  def location_params
    params.require(:location).permit(:address, :name)
  end

  def article_params
    params.permit(:url)
  end

  def load_businesses
    if search_params.has_key?(:q)
      Business.search search_params[:q], limit: limit, match: :word_start
    else
      Business.limit(10)
    end
  end

  def limit
    search_params[:limit] || limit_by_format
  end

  def limit_by_format
    params[:format] == "json" ? 50 : 20
  end
end
