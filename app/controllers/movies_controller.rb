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
    
    # Fill in missing session ratings
    if(!session[:ratings])
      session[:ratings] = @all_ratings
    end
    
    # Fill in missing params from the session
    if(!params[:sort] and session[:sort])
      params[:sort] = session[:sort]
      #flash.keep
      #redirect_to(movies_path(:sort => session[:sort]))
    end
    
    if(!params[:ratings] and session[:ratings] and session[:ratings].keys)
      params[:ratings] = session[:ratings]
      #flash.keep
      #redirect_to(movies_path(:ratings => session[:ratings]))
    end
   
    # Filter/Order Movies
    if(params[:ratings] and params[:ratings].keys)
      @movies = @movies.where(:rating => params[:ratings].keys)
      session[:ratings] = params[:ratings]
    end
    
    if(params[:sort].to_s == "title")
      @movies = @movies.order("movies.title ASC")
      session[:sort] = params[:sort]
    elsif(params[:sort].to_s == "release_date")
      @movies = @movies.order("movies.release_date ASC")
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
