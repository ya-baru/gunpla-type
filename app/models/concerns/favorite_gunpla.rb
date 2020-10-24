module FavoriteGunpla
  extend ActiveSupport::Concern
  included do
    def favorite(gunpla)
      favorite_gunplas << gunpla
    end

    def unfavorite(gunpla)
      Favorite.find_by(gunpla_id: gunpla.id).destroy
    end

    def favorite?(gunpla)
      favorite_gunplas.include?(gunpla)
    end
  end
end
