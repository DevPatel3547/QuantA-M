class ArticlesController < ApplicationController
    before_action :set_article, only: %i[edit update destroy delete show]

    def index
      filtered_categories = params[:category]
      searched_articles = params[:search]

      if filtered_categories.present?
        @articles = Article.where(article_category_id: filtered_categories)
      elsif searched_articles.present?
        @articles = Article.where("title ILIKE ? OR body ILIKE ?", "%#{searched_articles}%", "%#{searched_articles}%")
      else
        @articles = Article.all
      end

      @articles = @articles.joins(:article_module).order('article_modules.priority ASC').group_by(&:article_module)

      @modules = ArticleModule.all.order(priority: :asc)
      @categories = ArticleCategory.all
    end

    def show
    end

    def new
      @article = Article.new
      authorize @article
    end

    def edit
      authorize @article
    end

    def delete
      authorize @article
    end

    def create
      @article = Article.new(article_params)
      authorize @article

      respond_to do |format|
        if @article.save
          format.html { redirect_to articles_url, notice: "Article was successfully created." }
          format.json { render :show, status: :created, location: @article }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @article.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize @article

      respond_to do |format|
        if @article.update(article_params)
          format.html { redirect_to @article, notice: "Article was successfully updated." }
          format.json { render :show, status: :ok, location: @article }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @article.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @article

      @article.destroy
      respond_to do |format|
        format.html { redirect_to articles_url, notice: "Article was successfully deleted." }
        format.json { head :no_content }
      end
    end

    private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
        params.require(:article).permit(:title, :body, :article_module_id, :article_category_id)
    end
end
