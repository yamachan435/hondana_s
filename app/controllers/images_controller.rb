class ImagesController < ApplicationController
  protect_from_forgery except: :create

  def show
    image = Image.find(params[:id])
    render json: image, except: [:data]
  end

  def create
    image = Image.new
    image.isbn = params[:isbn]
    image.save!
    render json: image, except: [:data]
  end

  def download
    image = Image.find(params[:id])
    send_data image.data, type: "image/jpg", disposition: 'inline'
  end

  def upload
    image = Image.find(params[:id])
    image.data = request.raw_post
    image.save!
    render json: image, except: [:json]
  end

  def api_isbn
    image = Image.find_by(isbn: params[:isbn])
    #render image.id

    send_data image.data, type: "image/jpg", disposition: 'inline'
  end
end
