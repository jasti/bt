class CreateCategories
  def up
    create_table :categories do |t|
      t.string :category_name
    end

    CreateCategories.create   :category_name => "Skin"
    CreateCategories.create   :category_name => "Hair"
    CreateCategories.create   :category_name => "Makeup"
    CreateCategories.create   :category_name => "Body"
    CreateCategories.create   :category_name => "Face"
    CreateCategories.create   :category_name => "Legs"
  end

  def down
    drop_table :categories
  end
end