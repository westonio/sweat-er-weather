class Api::V1::BooksController < ApplicationController
  def search
    facade = BooksFacade.new.search_books(params[:location], params[:quantity])
    render json: BooksSerializer.new(facade)
  end
end