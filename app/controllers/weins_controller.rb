class WeinsController < ApplicationController
  before_action :set_wein, only: [:show, :edit, :update, :destroy]
  # GET /weins
  # GET /weins.json
  def index
    @weins = Wein.where(["name LIKE ?","%#{params[:search]}%"]).page(params[:page]).per(42)
     #@weins = Wein.all.order('price')
     #@weins  = Wein.all.order(:price)
     # @weins = Wein.where(["name LIKE ?","%#{params[:search]}%"]).order(price: :asc)
     #@weins = @weins.sort { |a, b| a.price <=> b.price }
    #@prices = @weins.pluck(:price).map { |p| sprintf("€%2.2f", p) }
     
   #  .order(price: :asc)
#@prices = @products.pluck(:price).map { |p| sprintf("€%2.2f", p) }
  end

  # GET /weins/1
  # GET /weins/1.json
  def show
  end

  # GET /weins/new
  def new
    @wein = Wein.new
  end

  # GET /weins/1/edit
  def edit
  end

  # POST /weins
  # POST /weins.json
  def create
    @wein = Wein.new(wein_params)

    respond_to do |format|
      if @wein.save
        format.html { redirect_to @wein, notice: 'Wein was successfully created.' }
        format.json { render :show, status: :created, location: @wein }
      else
        format.html { render :new }
        format.json { render json: @wein.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weins/1
  # PATCH/PUT /weins/1.json
  def update
    respond_to do |format|
      if @wein.update(wein_params)
        format.html { redirect_to @wein, notice: 'Wein was successfully updated.' }
        format.json { render :show, status: :ok, location: @wein }
      else
        format.html { render :edit }
        format.json { render json: @wein.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weins/1
  # DELETE /weins/1.json
  def destroy
    @wein.destroy
    respond_to do |format|
      format.html { redirect_to weins_url, notice: 'Wein was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wein
      @wein = Wein.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wein_params
      params.require(:wein).permit(:name, :image_url, :price, :vintage)
    end
end
