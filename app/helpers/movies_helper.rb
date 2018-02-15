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
end
