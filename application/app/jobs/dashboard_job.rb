class DashboardJob < ApplicationJob
  queue_as :default

  def perform(content)
    ActionCable.server.broadcast 'room_channel', content: content
  end
end
