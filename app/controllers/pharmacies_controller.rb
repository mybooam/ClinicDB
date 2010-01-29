class PharmaciesController < ApplicationController
  # GET /pharmacies
  # GET /pharmacies.xml
  def index
    @pharmacies = Pharmacy.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pharmacies }
    end
  end

  # GET /pharmacies/1
  # GET /pharmacies/1.xml
  def show
    @pharmacy = Pharmacy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pharmacy }
    end
  end

  # GET /pharmacies/new
  # GET /pharmacies/new.xml
  def new
    @pharmacy = Pharmacy.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pharmacy }
    end
  end

  # GET /pharmacies/1/edit
  def edit
    @pharmacy = Pharmacy.find(params[:id])
  end

  # POST /pharmacies
  # POST /pharmacies.xml
  def create
    @pharmacy = Pharmacy.new(params[:pharmacy])

    respond_to do |format|
      if @pharmacy.save
        flash[:notice] = 'Pharmacy was successfully created.'
        format.html { redirect_to(@pharmacy) }
        format.xml  { render :xml => @pharmacy, :status => :created, :location => @pharmacy }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pharmacy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pharmacies/1
  # PUT /pharmacies/1.xml
  def update
    @pharmacy = Pharmacy.find(params[:id])

    respond_to do |format|
      if @pharmacy.update_attributes(params[:pharmacy])
        flash[:notice] = 'Pharmacy was successfully updated.'
        format.html { redirect_to(@pharmacy) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pharmacy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pharmacies/1
  # DELETE /pharmacies/1.xml
  def destroy
    @pharmacy = Pharmacy.find(params[:id])
    @pharmacy.destroy

    respond_to do |format|
      format.html { redirect_to(pharmacies_url) }
      format.xml  { head :ok }
    end
  end
end
