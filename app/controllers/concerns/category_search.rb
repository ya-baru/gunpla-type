module CategorySearch
  extend ActiveSupport::Concern
  included do
    def category_listup(category)
      return find_gunpla(category.indirect_ids) unless category.ancestry?
      return @gunpla_list = Gunpla.where(category_id: params[:id]).decorate if category.ancestry.include?("/")

      find_gunpla(category.child_ids)
    end

    protected

    def find_gunpla(category_ids)
      @gunpla_list = []
      category_ids.each do |id|
        gunpla_arry = Gunpla.where(category_id: id).decorate.reject(&:blank?)
        gunpla_arry.each do |gunpla|
          @gunpla_list.push(gunpla) if gunpla.present?
        end
      end
    end
  end
end
