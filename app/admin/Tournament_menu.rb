ActiveAdmin.register Tournament do
  permit_params :year
  menu :parent => "Tournament Data"
end

ActiveAdmin.register Conference do
  permit_params :name, :kp_name, :bmat_name, :short_name
  menu :parent => "Tournament Data"
end

ActiveAdmin.register Region do
  permit_params :name
  menu :parent => "Tournament Data"
end

ActiveAdmin.register Round do
  permit_params :name
  menu :parent => "Tournament Data"
end

ActiveAdmin.register TournamentTeam do
  permit_params :tournament_id, :team_id
  menu :parent => "Tournament Data"
end

ActiveAdmin.register TournamentMatch do
  menu :parent => "Tournament Data"
end

