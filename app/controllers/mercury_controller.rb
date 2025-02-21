class MercuryController < ActionController::Base
  include ::Mercury::Authentication

  protect_from_forgery
  before_action :disable_csp
  before_action :authenticate, :only => :edit
  layout false

  def edit
    render html: '', :layout => 'mercury'
  end

  def resource
    Rails.logger.info "Rendering resource with #################################### #{params}}"
    render :action => "/#{params[:type]}/#{params[:resource]}"
  end

  def snippet_options
    @options = params[:options] || {}
    render :action => "/snippets/#{params[:name]}/options"
  end

  def snippet_preview
    render :action => "/snippets/#{params[:name]}/preview"
  end

  def test_page
    render html: params
  end

  private

  def authenticate
    redirect_to "/#{params[:requested_uri]}" unless can_edit?
  end

  def disable_csp
    Rails.logger.info "disabling csp for: ******************************************* #{params[:requested_uri]}"
    csp = []
    csp << "default-src 'self' data: blob:;"
    csp << "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdnjs.cloudflare.com;"
    csp << "style-src 'self' 'unsafe-inline' 'unsafe-eval' https://fonts.googleapis.com;"
    csp << "font-src 'self' https://fonts.gstatic.com;"
    csp << "img-src 'self' data: blob: https://tile.openstreetmap.org/;"

    response.headers['Content-Security-Policy'] = csp.join(" ")
  end
end
