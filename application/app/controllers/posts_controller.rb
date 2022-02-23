class PostsController < ApplicationController

  before_action :find_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
    @datamanual = Post.new
    @namaevent = Event.joins(:type_of_event)
                           .where(status:true).first.name.to_s
    event_id = Event.find_by(status: true).id
    type_of_event_id = Event.where(id:event_id).first.type_of_event_id
    @eventtype = TypeOfEvent.joins(:events).where(id:type_of_event_id).first.name
  end

  def create
    activeEvent = Event.joins(:type_of_event)
    .select("
      events.id,
      events.name as event_name,
      type_of_events.name
      ")
      .where('events.status=true')
      .first
      
    find_guest = Guest.where(event_id: activeEvent.id).where(guest_id: params[:post][:guest_id]).first
    @post = Post.new(
      :guest_id => find_guest.nama,
      :image => params[:post][:image],
      :event_id => activeEvent.id,
      :event_type => activeEvent.name,
      :event_name => activeEvent.event_name
    )
    @post.save_path
    if @post.valid? && @post.save
      render json: @post, status: :created, location: @post
    else
      render json: {'message': 'not valid'}, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit

  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:guest_id, :image)
    # params.require(:post).permit(:guest_id, :image, :event_name, :event_type, :event_id)
  end
end
