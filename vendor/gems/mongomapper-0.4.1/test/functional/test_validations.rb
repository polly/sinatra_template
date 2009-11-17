require 'test_helper'

class ValidationsTest < Test::Unit::TestCase
  def setup
    clear_all_collections
  end
  
  context "Saving a new document that is invalid" do
    setup do
      @document = Class.new do
        include MongoMapper::Document
        key :name, String, :required => true
      end
    end
    
    should "not insert document" do
      doc = @document.new
      doc.save
      @document.count.should == 0
    end
    
    should "populate document's errors" do
      doc = @document.new
      doc.errors.size.should == 0
      doc.save
      doc.errors.full_messages.should == ["Name can't be empty"]
    end
  end
  
  context "Saving a document that is invalid (destructive)" do
    setup do
      @document = Class.new do
        include MongoMapper::Document
        key :name, String, :required => true
      end
    end
    
    should "raise error" do
      doc = @document.new
      lambda { doc.save! }.should raise_error(MongoMapper::DocumentNotValid)
    end
  end
  
  context "Saving an existing document that is invalid" do
    setup do
      @document = Class.new do
        include MongoMapper::Document
        key :name, String, :required => true
      end
      
      @doc = @document.create(:name => 'John Nunemaker')
    end
    
    should "not update document" do
      @doc.name = nil
      @doc.save
      @document.find(@doc.id).name.should == 'John Nunemaker'
    end
    
    should "populate document's errors" do
      @doc.name = nil
      @doc.save
      @doc.errors.full_messages.should == ["Name can't be empty"]
    end
  end
  
  context "Adding validation errors" do
    setup do
      @document = Class.new do
        include MongoMapper::Document
        key :action, String
        def action_present
          errors.add(:action, 'is invalid') if action.blank?
        end
      end
    end
    
    should "work with validate_on_create callback" do
      @document.validate_on_create :action_present
      
      doc = @document.new
      doc.action = nil
      doc.should have_error_on(:action)
      
      doc.action = 'kick'
      doc.should_not have_error_on(:action)
      doc.save
      
      doc.action = nil
      doc.should_not have_error_on(:action)
    end
    
    should "work with validate_on_update callback" do
      @document.validate_on_update :action_present
      
      doc = @document.new
      doc.action = nil
      doc.should_not have_error_on(:action)
      doc.save
      
      doc.action = nil
      doc.should have_error_on(:action)
      
      doc.action = 'kick'
      doc.should_not have_error_on(:action)
    end
  end
  
  context "validating uniqueness of" do
    setup do
      @document = Class.new do
        include MongoMapper::Document
        key :name, String
        validates_uniqueness_of :name
      end
    end

    should "not fail if object is new" do
      doc = @document.new
      doc.should_not have_error_on(:name)
    end

    should "not fail when new object is out of scope" do
      document = Class.new do
        include MongoMapper::Document
        key :name
        key :adult
        validates_uniqueness_of :name, :scope => :adult
      end
      doc = document.new("name" => "joe", :adult => true)
      doc.save.should be_true

      doc2 = document.new("name" => "joe", :adult => false)
      doc2.should be_valid

    end

    should "allow to update an object" do
      doc = @document.new("name" => "joe")
      doc.save.should be_true

      @document \
        .stubs(:find) \
        .with(:first, :conditions => {:name => 'joe'}, :limit => 1) \
        .returns(doc)

      doc.name = "joe"
      doc.valid?.should be_true
      doc.should_not have_error_on(:name)
    end

    should "fail if object name is not unique" do
      doc = @document.new("name" => "joe")
      doc.save.should be_true

      @document \
        .stubs(:find) \
        .with(:first, :conditions => {:name => 'joe'}, :limit => 1) \
        .returns(doc)

      doc2 = @document.new("name" => "joe")
      doc2.should have_error_on(:name)
    end
    
    context "scoped by a single attribute" do
      setup do
        @document = Class.new do
          include MongoMapper::Document
          key :name, String
          key :scope, String
          validates_uniqueness_of :name, :scope => :scope
        end
        @document.collection.clear
      end
      
      should "fail if the same name exists in the scope" do
        doc = @document.new("name" => "joe", "scope" => "one")
        doc.save.should be_true
        
        @document \
          .stubs(:find) \
          .with(:first, :conditions => {:name => 'joe', :scope => "one"}, :limit => 1) \
          .returns(doc)

        doc2 = @document.new("name" => "joe", "scope" => "one")
        doc2.should have_error_on(:name)
      end
      
      should "pass if the same name exists in a different scope" do
        doc = @document.new("name" => "joe", "scope" => "one")
        doc.save.should be_true
        
        @document \
          .stubs(:find) \
          .with(:first, :conditions => {:name => 'joe', :scope => "two"}, :limit => 1) \
          .returns(nil)

        doc2 = @document.new("name" => "joe", "scope" => "two")
        doc2.should_not have_error_on(:name)
      end
    end
    
    context "scoped by a multiple attributes" do
      setup do
        @document = Class.new do
          include MongoMapper::Document
          key :name, String
          key :first_scope, String
          key :second_scope, String
          validates_uniqueness_of :name, :scope => [:first_scope, :second_scope]
        end
        @document.collection.clear
      end
      
      should "fail if the same name exists in the scope" do
        doc = @document.new("name" => "joe", "first_scope" => "one", "second_scope" => "two")
        doc.save.should be_true
        
        @document \
          .stubs(:find) \
          .with(:first, :conditions => {:name => 'joe', :first_scope => "one", :second_scope => "two"}, :limit => 1) \
          .returns(doc)

        doc2 = @document.new("name" => "joe", "first_scope" => "one", "second_scope" => "two")
        doc2.should have_error_on(:name)
      end
      
      should "pass if the same name exists in a different scope" do
        doc = @document.new("name" => "joe", "first_scope" => "one", "second_scope" => "two")
        doc.save.should be_true
        
        @document \
          .stubs(:find) \
          .with(:first, :conditions => {:name => 'joe', :first_scope => "one", :second_scope => "one"}, :limit => 1) \
          .returns(nil)

        doc2 = @document.new("name" => "joe", "first_scope" => "one", "second_scope" => "one")
        doc2.should_not have_error_on(:name)
      end
    end
  end
  
  context "validates uniqueness of with :unique shortcut" do
    should "work" do
      @document = Class.new do
        include MongoMapper::Document
        key :name, String, :unique => true
      end
      
      doc = @document.create(:name => 'John')
      doc.should_not have_error_on(:name)
      
      @document \
        .stubs(:find) \
        .with(:first, :conditions => {:name => 'John'}, :limit => 1) \
        .returns(doc)
      
      second_john = @document.create(:name => 'John')
      second_john.should have_error_on(:name, 'has already been taken')
    end
  end
end
