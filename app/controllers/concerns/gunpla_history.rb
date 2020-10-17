module GunplaHistory
  extend ActiveSupport::Concern
  included do
    def gunpla_history_save(gunpla)
      new_history = current_user.browsing_histories.build(gunpla_id: params[:id])

      if new_history.save
        histories = current_user.browsing_histories
        histories.first.destroy if histories.count > HISTORIES_STOCK_LIMIT
        return
      end

      current_user.browsing_histories.find_by(gunpla_id: params[:id]).destroy
      new_history.save
    end
  end
end
