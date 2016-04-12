ActiveAdmin.register Tournament do
  menu :parent => "Tournament Data"
  permit_params :name, :year, :date
end

ActiveAdmin.register Conference do
  menu :parent => "Tournament Data"
  permit_params :name, :kp_name, :bmat_name, :short_name
end

ActiveAdmin.register Region do
  menu :parent => "Tournament Data"
  permit_params :name
end

ActiveAdmin.register Round do
  menu :parent => "Tournament Data"
  permit_params :name, :number
end