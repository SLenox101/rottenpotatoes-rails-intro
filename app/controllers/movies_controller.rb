class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @movies = Movie.all

    # Fill in missing params
    if(params[:sort] == nil and params[:ratings] == nil and (session[:sort] != nil or session[:ratings] != nil))
      if(params[:sort] == nil and session[:sort] != nil)
        params[:sort] = session[:sort]
      end
      if(params[:ratings] == nil and session[:ratings] != nil)
        params[:ratings] = session[:ratings]
      end
      flash.keep
      redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    elsif(params[:sort] == nil and session[:sort] != nil)
      params[:sort] = session[:sort]
      flash.keep
      redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    elsif(params[:ratings] == nil and session[:ratings] != nil)
      params[:ratings] = session[:ratings]
      flash.keep
      redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    end
   
    # Filter/Order Movies
    if(params[:ratings])
      @movies = @movies.where(:rating => params[:ratings].keys)
      session[:ratings] = params[:ratings]
    end
    
    if(params[:sort])
      @movies = @movies.order(params[:sort])
      session[:sort] = params[:sort]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
