require "application_system_test_case"

class BookInfosTest < ApplicationSystemTestCase
  setup do
    @book_info = book_infos(:one)
  end

  test "visiting the index" do
    visit book_infos_url
    assert_selector "h1", text: "Book Infos"
  end

  test "creating a Book info" do
    visit book_infos_url
    click_on "New Book Info"

    fill_in "Author", with: @book_info.author
    fill_in "Isbn", with: @book_info.isbn
    fill_in "Title", with: @book_info.title
    click_on "Create Book info"

    assert_text "Book info was successfully created"
    click_on "Back"
  end

  test "updating a Book info" do
    visit book_infos_url
    click_on "Edit", match: :first

    fill_in "Author", with: @book_info.author
    fill_in "Isbn", with: @book_info.isbn
    fill_in "Title", with: @book_info.title
    click_on "Update Book info"

    assert_text "Book info was successfully updated"
    click_on "Back"
  end

  test "destroying a Book info" do
    visit book_infos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Book info was successfully destroyed"
  end
end
