class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = load_locations
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def location_params
    params.require(:location).permit(:business_id, :name, :address, :notes, :latlon)
  end

  def search_params
    params.permit(:lat, :lon, :radius, :tl_lat, :tl_lon, :br_lat, :br_lon, :category)
  end

  def load_locations
    if search_params.has_key?(:radius) && search_params.keys.length == 3
      Location.search "*", where: {location: {near: {lat: search_params[:lat], lon: search_params[:lon]}, within: search_params[:radius]}}, limit: 50
    elsif search_params.has_key?(:tl_lat) && search_params.keys.length >= 4
      search = Location.within(search_params.to_hash.symbolize_keys.slice(:tl_lat, :tl_lon, :br_lat, :br_lon))
      if search_params.has_key?(:category)
        search = search.for_category_name(search_params[:category])
      end
      search.limit(50)
    else
      Location.limit(10)
    end
  end
end
