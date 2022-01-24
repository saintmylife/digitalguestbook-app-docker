class DashboardWorker
  include Sidekiq::Worker

  def perform(content)
    ActionCable.server.broadcast 'room_channel', content: content
  end
end
