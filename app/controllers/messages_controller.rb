class MessagesController < ApplicationController
  before_action :find_conversation
  before_action :authenticate_user!
  before_action :is_user_part_of_conversation, only: [:index]
  
  def index
    @message = @conversation.messages.new
    @messages = @conversation.messages
  end

  def create
    @message = @conversation.messages.create(message_params)
  end

  def is_user_part_of_conversation
    redirect_to root_path unless (@conversation.sender_id == current_user.id || @conversation.receiver_id == current_user.id)
  end

  private

  def message_params
    params.require(:message).permit(:message_body, :user_id)
  end

  def find_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

end
