require 'test_helper'

class BookInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_info = book_infos(:one)
  end

  test "should get index" do
    get book_infos_url
    assert_response :success
  end

  test "should get new" do
    get new_book_info_url
    assert_response :success
  end

  test "should create book_info" do
    assert_difference('BookInfo.count') do
      post book_infos_url, params: { book_info: { author: @book_info.author, isbn: @book_info.isbn, title: @book_info.title } }
    end

    assert_redirected_to book_info_url(BookInfo.last)
  end

  test "should show book_info" do
    get book_info_url(@book_info)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_info_url(@book_info)
    assert_response :success
  end

  test "should update book_info" do
    patch book_info_url(@book_info), params: { book_info: { author: @book_info.author, isbn: @book_info.isbn, title: @book_info.title } }
    assert_redirected_to book_info_url(@book_info)
  end

  test "should destroy book_info" do
    assert_difference('BookInfo.count', -1) do
      delete book_info_url(@book_info)
    end

    assert_redirected_to book_infos_url
  end
end
