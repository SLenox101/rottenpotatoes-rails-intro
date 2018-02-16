module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  # Checks if column is in ascending order
  def highlight(field)
    if(field == params[:sort].to_s)
      return 'hilite'
    else
      return nil
    end
  end
  
  # Checks if box should be selected
  def box_checked?(rating)
    return session[:ratings].include?(rating)
  end
end
