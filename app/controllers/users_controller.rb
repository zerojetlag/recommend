class UsersController < ApplicationController
  def show
    user = User.find_by_student_number(params[:id])
    @books = user.books.page params[:page]
    @recommend_books = Book.limit(30).page params[:page]
  end
  def index
   @users = User.page params[:page]
  end
end
