class Admin::ProductsController < Admin::BaseController
  authorize_resource

  before_action :find_product, only: %i(edit update destroy)

  def index
    @products = @q.result(distinct: true)
                  .page(params[:page])
                  .per(Settings.page.per_8)
  end

  def new
    @admin_product = Product.new
    @image = @admin_product.images.build
    @new = true
  end

  def create
    @admin_product = Product.new product_params
    ActiveRecord::Base.transaction do
      @admin_product.save!
      if params[:images]
        params[:images]["image_url"].each do |a|
          @image = @admin_product.images.create!(image_url: a)
        end
      end
      flash[:success] = t "admin.product.add_success"
      redirect_to admin_products_path
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = t "admin.product.add_fail"
    render :new
  end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @admin_product.update! product_params
      flash[:success] = t "admin.product.edit_success"
      redirect_to admin_products_path
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = t "admin.product.edit_fail"
    render :edit
  end

  def destroy
    if @admin_product.destroy
      flash[:success] = t "admin.product.delete_success"
    else
      flash[:danger] = t "admin.product.delete_fail"
    end
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit :name, :category_id,
                                    :price, :quantity,
                                    :information,
                                    images_attributes: [:id, :image_url]
  end

  def find_product
    @admin_product = Product.find_by id: params[:id]
    return if @admin_product

    flash[:danger] = t "admin.product.not_found"
    redirect_to admin_products_path
  end
end
