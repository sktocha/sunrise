require 'spec_helper'

describe "Sunrise Manager Edit" do
  subject { page }
  before(:all) do 
    @admin = FactoryGirl.create(:admin_user)
    
    @root = FactoryGirl.create(:structure_main)
    @page = FactoryGirl.create(:structure_page, :parent => @root)
  end
  
  context "admin" do
    before(:each) { login_as @admin }

    describe "update" do
      before(:each) do
        visit edit_path(:model_name => "structures", :id => @page.id)
        
        #save_and_open_page
        
        fill_in "structure[title]", :with => "Aimbulance updated"
        select(StructureType.posts.title, :from => "structure_kind")
        select(PositionType.default.title, :from => "structure_position")
        uncheck('structure[is_visible]')
        
        click_button "Refresh"
      end
      
      it "should update an object with correct attributes" do
        @page.reload
        
        @page.title.should == "Aimbulance updated"
        @page.structure_type.should == StructureType.posts
        @page.position_type.should == PositionType.default
        @page.is_visible.should == false
      end
    end
    
    describe "Update /manage/pages/:id/edit" do
      before(:each) do
        visit edit_path(:model_name => "pages", :id => @page.id)
        
        fill_in "structure[main]", :with => "Main updated"
        fill_in "structure[sidebar]", :with => "Sidebar updated"
        
        click_button "Refresh"
      end
      
      it "should update an object with correct attributes" do
        @page.reload
        
        @page.main.should == "Main updated"
        @page.sidebar.should == "Sidebar updated"
      end
    end
  end
  
  describe "anonymous user" do
    before(:each) do
      visit edit_path(:model_name => "structures", :id => @page.id)
    end
    
    it "should redirect to login page" do
      should have_content('Sign in')
    end
  end
end