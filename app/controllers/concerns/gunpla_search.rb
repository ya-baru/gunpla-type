module GunplaSearch
  extend ActiveSupport::Concern
  included do
    def gunpla_search(content)
      @search = Gunpla.ransack(content)
      if @category.id.nil?
        @gunplas = @search.result.page(params[:page]).per(9).decorate.includes([:reviews, :category])
        return
      end
      @gunplas = Kaminari.paginate_array(@gunpla_list).page(params[:page]).per(9)
    end
  end
end
