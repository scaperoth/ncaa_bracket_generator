ActiveAdmin.register KenpomStats do
  permit_params :team_id, :tournament_id, :rank, :wl, :pyth,:adjo, :adjd , :adjt, :luck, :pyth_sched, :oppo_sched, :oppd_sched, :pyth_ncsos

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
