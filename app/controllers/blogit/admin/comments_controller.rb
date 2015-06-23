module Blogit
  module Admin
    class CommentsController < ::Blogit::Admin::ApplicationController
      
      if Rails.version < 4
        before_filter :authenticate_blogger
      else
        before_action :authenticate_blogger
      end

      def create
        @comment = post.comments.new(comment_params)

        respond_to do |format|
          format.js {
            # the rest is dealt with in the view
            @comment.save
          }

          format.html {
            if @comment.save
              redirect_to(post, notice: t(:successfully_added_comment, scope: 'blogit.comments'))
            else
              render "blogit/posts/show"
            end
          }

        end

      end

      def destroy
        @comment = post.comments.find(params[:id])
        @comment.destroy
        respond_to do |format|
          format.html { redirect_to(post, notice: t(:successfully_removed_comment, scope: 'blogit.comments'))}
          format.js
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:name, :nickname, :email, :body, :website)
      end

      def post
        @post ||= Blogit::Post.find(params[:post_id])
      end
    
    end
  end

end