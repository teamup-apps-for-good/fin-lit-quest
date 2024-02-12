class PreferencesController < ApplicationController
  before_action :set_preference, only: %i[ show edit update destroy ]

  # GET /preferences or /preferences.json
  def index
    @preferences = Preference.all
  end

  # GET /preferences/1 or /preferences/1.json
  def show
  end

  # GET /preferences/new
  def new
    @preference = Preference.new
  end

  # GET /preferences/1/edit
  def edit
  end

  # POST /preferences or /preferences.json
  def create
    @preference = Preference.new(preference_params)

    respond_to do |format|
      if @preference.save
        format.html { redirect_to preference_url(@preference), notice: "Preference was successfully created." }
        format.json { render :show, status: :created, location: @preference }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /preferences/1 or /preferences/1.json
  def update
    respond_to do |format|
      if @preference.update(preference_params)
        format.html { redirect_to preference_url(@preference), notice: "Preference was successfully updated." }
        format.json { render :show, status: :ok, location: @preference }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preferences/1 or /preferences/1.json
  def destroy
    @preference.destroy!

    respond_to do |format|
      format.html { redirect_to preferences_url, notice: "Preference was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preference
      @preference = Preference.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def preference_params
      params.require(:preference).permit(:occupation, :item_id, :multiplier)
    end
end
