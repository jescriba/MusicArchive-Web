require 'rails_helper'

describe Album do

  it "has a valid factory" do
    expect(FactoryBot.build(:album).save).to be true
  end

  # it "is invalid without a name" do
  #   expect(FactoryBot.build(:song, name: nil).save).to be false
  # end
  #
  # it "is invalid without a unique name" do
  #   user = FactoryBot.create(:song)
  #   expect(FactoryBot.build(:song, name: “Song 1”)).to be false
  # end

end
