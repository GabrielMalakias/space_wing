require 'spec_helper'
require_relative '../../../../apps/web/controllers/sensors/show'
require_relative '../../../../lib/usgard/commands/sensor/find_by_id'

describe Web::Controllers::Sensors::Show, type: :controller do
  let(:id) { '10' }
  let(:user) { instance_double(User, id: user_id) }
  let(:action) { described_class.new(find_by_id: find_by_id) }
  let(:sensor) { Sensor.new }
  let(:user_id) { 1 }
  let(:find_by_id) { double(Usgard::Commands::Sensor::FindById) }

  before do
    stub_current_user!(user)
  end

  let(:params) do
    { id: id }
  end

  context 'when has a result' do
    before do
      allow(find_by_id)
        .to receive(:call)
        .with(id, user_id: user_id)
        .and_return(sensor)
    end

    it 'status is 200' do
      response = action.call(params)

      expect(response[0]).to eq 200

      expect(action.exposures[:sensor]).to eq(sensor)
    end
  end

  context 'when is not found' do
    before do
      allow(find_by_id)
        .to receive(:call)
        .with(id, user_id: user_id)
        .and_return(nil)
    end

    it 'status is 404' do
      response = action.call(params)

      expect(response[0]).to eq 404
    end
  end
end
