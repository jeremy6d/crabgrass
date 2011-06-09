require File.dirname(__FILE__) + '/../../../../test/test_helper'

class GalleryControllerTest < ActionController::TestCase
  fixtures :pages, :users

  def setup
  end

  def test_show
    login_as :blue
    gallery = Gallery.create!( :user => users(:blue),
      :title => "Empty Gallery")
    get :show, :page_id => gallery.id
    assert_response :success
    assert_equal [], assigns['images']
  end

  def test_upload_ready_for_progress_bar
    login_as :blue
    gallery = Gallery.create!( :user => users(:blue),
      :title => "Empty Gallery")
    get :upload, :page_id => gallery.id
    assert_response :success
    assert_not_nil assigns['upload_id'],
      "edit action should create upload-id"
    assert_select '#progress[style="display: none;"]', 1,
      "a hidden progress bar should be displayed" do
      assert_select '#bar[style="width: 0%;"]', "0 %",
        "the progress bar should contain a bar"
      end
  end

# this controller does not really even exist yet:
  def test_create
    login_as :blue

    assert_difference 'Gallery.count' do
      post :create, :id => Gallery.param_id, :page => {:title => 'pictures'}, :assets => [upload_data('photo.jpg')]
    end

    assert_not_nil assigns(:page)
    assert_equal 1, assigns(:page).images.count
    assert_not_nil assigns(:page).page_terms
    assert_equal assigns(:page).page_terms, assigns(:page).images.first.page_terms
  end

  def test_create_same_name
    login_as :gerrard

    data_ids, page_ids, page_urls = [],[],[]
    3.times do
      post 'create', :page => {:title => "dupe", :summary => ""}, :id => Gallery.param_id
      page = assigns(:page)

      assert_equal "dupe", page.title
      assert_not_nil page.id

      # check that we have:
      # a new page
      assert !page_ids.include?(page.id)
      # a new url
      assert !page_urls.include?(page.name_url)

      # remember the values we saw
      page_ids << page.id
      page_urls << page.name_url
    end
  end

  def test_upload_zipfile
    login_as :blue

    assert_difference 'Gallery.count' do
      post :create, :id => Gallery.param_id, :page => {:title => 'pictures'}, :assets => [upload_data('photo.jpg')]
    end

    assert_difference 'Asset.count' do
      post :upload_zip, :id => Gallery.param_id, :zipfile => upload_data('no-subdir.zip')
    end

    assert_difference 'Asset.count' do
      post :upload_zip, :id => Gallery.param_id, :zipfile => upload_data('subdir.zip')
    end

    assert_equal 3, assigns(:page).images.count
    assert_not_nil assigns(:page).page_terms
    assert_equal assigns(:page).page_terms, assigns(:page).images.first.page_terms
  end

end
