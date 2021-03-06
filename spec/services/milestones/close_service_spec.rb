require 'spec_helper'

describe Milestones::CloseService, services: true do
  let(:user) { create(:user) }
  let(:project) { create(:empty_project) }
  let(:milestone) { create(:milestone, title: "Milestone v1.2", project: project) }

  before do
    project.team << [user, :master]
  end

  describe '#execute' do
    before do
      Milestones::CloseService.new(project, user, {}).execute(milestone)
    end

    it { expect(milestone).to be_valid }
    it { expect(milestone).to be_closed }

    describe 'event' do
      let(:event) { Event.recent.first }

      it { expect(event.milestone).to be_truthy }
      it { expect(event.target).to eq(milestone) }
      it { expect(event.action_name).to eq('closed') }
    end
  end
end
