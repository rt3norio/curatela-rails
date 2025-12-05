class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  
  helper_method :current_curatelado
  
  def current_curatelado
    return nil unless user_signed_in?
    return @current_curatelado if defined?(@current_curatelado)
    
    @current_curatelado = if session[:current_curatelado_id]
                            current_user.curatelados.find_by(id: session[:current_curatelado_id])
                          else
                            current_user.curatelados.first
                          end
  end
end
