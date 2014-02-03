require 'spec_helper'

describe Rating do
  describe "validations" do
    it "is unique to user and article"
  end

  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :article }
  end
end
