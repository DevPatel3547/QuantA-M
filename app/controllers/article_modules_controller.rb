class ArticleModulesController < ApplicationController
    before_action :set_module, only: %i[edit update destroy delete show increase_priority decrease_priority]

    def index
      @article_modules = ArticleModule.order(priority: :asc)
      authorize @article_modules
    end

    def new
      @article_module = ArticleModule.new
      authorize @article_module
    end

    def edit
      authorize @article_module
    end

    def delete
      authorize @article_module
    end

    def create
      @article_module = ArticleModule.new(article_module_params)
      authorize @article_module

      @article_module.priority = ArticleModule.maximum(:priority).to_i + 1

      respond_to do |format|
        if @article_module.save
          format.html { redirect_to article_modules_url, notice: "Article module was successfully created." }
          format.json { render :show, status: :created, location: @article_module }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @article_module.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize @article_module
      respond_to do |format|
        if @article_module.update(article_module_params)
          format.html { redirect_to article_modules_url, notice: "Article module was successfully updated." }
          format.json { render :show, status: :ok, location: @article_module }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @article_module.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @article_module
      @article_module.destroy
      respond_to do |format|
        format.html { redirect_to article_modules_url, notice: "Article module was successfully deleted." }
        format.json { head :no_content }
      end
    end

    def increase_priority
      authorize @article_module, :update?
      @article_module_above = ArticleModule.where("priority < ?", @article_module.priority).order(priority: :desc).first

      if @article_module_above
        @article_module_above.update(priority: @article_module.priority)
        @article_module.update(priority: @article_module.priority - 1)
      end

      flash[:notice] = "Priority updated"
      redirect_to article_modules_url
    end

    def decrease_priority
      authorize @article_module, :update?
      @article_module_below = ArticleModule.where("priority > ?", @article_module.priority).order(priority: :asc).first

      if @article_module_below
        @article_module_below.update(priority: @article_module.priority)
        @article_module.update(priority: @article_module.priority + 1)
      end

      flash[:notice] = "Priority updated"
      redirect_to article_modules_url
    end

    private

    def set_module
      @article_module = ArticleModule.find(params[:id])
    end

    def article_module_params
        params.require(:article_module).permit(:name)
    end
end
