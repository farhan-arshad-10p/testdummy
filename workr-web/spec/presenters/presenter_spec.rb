require 'spec_helper'

describe Presenter do

  describe ".present" do
    it "creates a single presenter" do
      subject = MyPresenter.present :object, :the_stuff
      subject.source.should == :object
      subject.extras.should == :the_stuff
    end

    it "maps array of objects to array of presenters" do
      subject = MyPresenter.present [:thing_one, :thing_two]
      subject.size.should == 2
      subject[0].source.should == :thing_one
      subject[1].source.should == :thing_two
    end

    it "does nothing when given a nil source" do
      MyPresenter.present(nil).should_not be
    end
  end

  describe "#initialize" do
    it "sets the source object" do
      subject = Presenter.new :obj
      subject.source.should == :obj
    end
  end
end

class MyPresenter < Presenter
end
