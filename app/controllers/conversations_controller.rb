class ConversationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_conversation, only: %i[show edit update destroy]

  # GET /conversations or /conversations.json
  def index
    @q = Conversation.all.ransack params[:q]
    @q.sorts = 'last_message_at desc' if @q.sorts.empty?
    @conversations = @q.result.page(params[:page]).per(params[:limit])
  end

  # GET /conversations/1 or /conversations/1.json
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_conversation
    @conversation = Conversation.where(id: params[:id]).or(Conversation.where(contact: params[:id])).first!
  end
end
