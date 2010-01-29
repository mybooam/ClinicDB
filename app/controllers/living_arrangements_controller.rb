class LivingArrangementsController < ApplicationController
  # GET /living_arrangements
  # GET /living_arrangements.xml
  def index
    @living_arrangements = LivingArrangement.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @living_arrangements }
    end
  end

  # GET /living_arrangements/1
  # GET /living_arrangements/1.xml
  def show
    @living_arrangement = LivingArrangement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @living_arrangement }
    end
  end

  # GET /living_arrangements/new
  # GET /living_arrangements/new.xml
  def new
    @living_arrangement = LivingArrangement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @living_arrangement }
    end
  end

  # GET /living_arrangements/1/edit
  def edit
    @living_arrangement = LivingArrangement.find(params[:id])
  end

  # POST /living_arrangements
  # POST /living_arrangements.xml
  def create
    @living_arrangement = LivingArrangement.new(params[:living_arrangement])

    respond_to do |format|
      if @living_arrangement.save
        flash[:notice] = 'LivingArrangement was successfully created.'
        format.html { redirect_to(@living_arrangement) }
        format.xml  { render :xml => @living_arrangement, :status => :created, :location => @living_arrangement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @living_arrangement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /living_arrangements/1
  # PUT /living_arrangements/1.xml
  def update
    @living_arrangement = LivingArrangement.find(params[:id])

    respond_to do |format|
      if @living_arrangement.update_attributes(params[:living_arrangement])
        flash[:notice] = 'LivingArrangement was successfully updated.'
        format.html { redirect_to(@living_arrangement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @living_arrangement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /living_arrangements/1
  # DELETE /living_arrangements/1.xml
  def destroy
    @living_arrangement = LivingArrangement.find(params[:id])
    @living_arrangement.destroy

    respond_to do |format|
      format.html { redirect_to(living_arrangements_url) }
      format.xml  { head :ok }
    end
  end
end
