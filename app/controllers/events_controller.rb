class EventsController < ApplicationController

  def index
    @events = Event.all
    
  end

  def this_method

  end


  def new
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    event_params = params.require(:event).permit(
      :description,
      :location,
      :date,
      :capacity,
      :requires_id
    )
    @event = Event.new(event_params)
    @event.save
    redirect_to events_path
  end

  def update
    @event = Event.find(params[:id])
    event_params = params.require(:event).permit(
      :description,
      :location,
      :date,
      :capacity,
      :requires_id
    )
    @event.update(event_params)
    redirect_to events_path
  end

  def destroy
    @event = Event.find(params[:iid])
    @event.destroy(event_params)
    redirect_to events_path
  end

end
