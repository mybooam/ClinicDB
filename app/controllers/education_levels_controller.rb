class EducationLevelsController < ApplicationController
  # GET /education_levels
  # GET /education_levels.xml
  def index
    @education_levels = EducationLevel.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @education_levels }
    end
  end

  # GET /education_levels/1
  # GET /education_levels/1.xml
  def show
    @education_level = EducationLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @education_level }
    end
  end

  # GET /education_levels/new
  # GET /education_levels/new.xml
  def new
    @education_level = EducationLevel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @education_level }
    end
  end

  # GET /education_levels/1/edit
  def edit
    @education_level = EducationLevel.find(params[:id])
  end

  # POST /education_levels
  # POST /education_levels.xml
  def create
    @education_level = EducationLevel.new(params[:education_level])

    respond_to do |format|
      if @education_level.save
        flash[:notice] = 'EducationLevel was successfully created.'
        format.html { redirect_to(@education_level) }
        format.xml  { render :xml => @education_level, :status => :created, :location => @education_level }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @education_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /education_levels/1
  # PUT /education_levels/1.xml
  def update
    @education_level = EducationLevel.find(params[:id])

    respond_to do |format|
      if @education_level.update_attributes(params[:education_level])
        flash[:notice] = 'EducationLevel was successfully updated.'
        format.html { redirect_to(@education_level) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @education_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /education_levels/1
  # DELETE /education_levels/1.xml
  def destroy
    @education_level = EducationLevel.find(params[:id])
    @education_level.destroy

    respond_to do |format|
      format.html { redirect_to(education_levels_url) }
      format.xml  { head :ok }
    end
  end
end
