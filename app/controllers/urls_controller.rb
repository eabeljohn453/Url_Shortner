class UrlsController < ApplicationController
  def index
    urls = Url.all
    render json: urls
  end

  def create
    url = Url.create(url_params)

    if url.persisted?
      render json: url, status: :created
    else
      render json: { errors: url.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def redirect
    url = Url.find_by(short_code: params[:short_code])
    if url
      url.increment!(:clicks)
      redirect_to url.original_url, status: :found,allow_other_host: true
    else
      render json:{error:"url not valid"}, status: :not_found
    end
  end

  private

  def url_params
    params.permit(:original_url,:short_code)
  end
end