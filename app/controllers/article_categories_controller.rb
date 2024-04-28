class ArticleCategoriesController < ApplicationController
    before_action :set_category, only: %i[edit update destroy delete show]

    def index
      @article_categories = ArticleCategory.order(created_at: :desc)
      authorize @article_categories
    end

    def new
      @article_category = ArticleCategory.new
      authorize @article_category
    end

    def edit
      authorize @article_category
    end

    def delete
      authorize @article_category
    end

    def create
      @article_category = ArticleCategory.new(article_category_params)
      authorize @article_category

      respond_to do |format|
          if @article_category.save
              flash[:notice] = "Article category was successfully created."
              format.html { redirect_to article_categories_url }
              format.json { render :show, status: :created, location: @article_category }
          else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @article_category.errors, status: :unprocessable_entity }
          end
      end
    end

    def update
      authorize @article_category
      respond_to do |format|
          if @article_category.update(article_category_params)
              flash[:notice] = "Article category was successfully updated."
              format.html { redirect_to article_categories_url }
              format.json { render :show, status: :ok, location: @article_category }
          else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @article_category.errors, status: :unprocessable_entity }
          end
      end
    end

    def destroy
      authorize @article_category
      @article_category.destroy
      respond_to do |format|
          flash[:notice] = "Article category was successfully deleted."
          format.html { redirect_to article_categories_url }
          format.json { head :no_content }
      end
    end

    private

    def set_category
      @article_category = ArticleCategory.find(params[:id])
    end

    def article_category_params
        params.require(:article_category).permit(:name)
    end
end
