describe User do
  it { is_expected.to have_many :restaurants }

  it { is_expected.to have_many :reviews }

  it { is_expected.to have_many :reviewed_restaurants }

  it { is_expected.to have_many :endorsements }
end
