class ChangeDependenciaToNivelInSecciones < ActiveRecord::Migration[8.0]
  def change
    # 1. Remove the old column
    remove_column :seccions, :dependencia, :string

    # 2. Add the reference but allow NULL for a moment
    add_reference :seccions, :nivel, null: true, foreign_key: true

    # 3. Create a default Nivel and link existing sections to it
    reversible do |dir|
      dir.up do
        # Create a "General" level if none exist so the migration doesn't crash
        default_nivel = Nivel.find_or_create_by!(nombre_nivel: "Nivel por Definir")
        
        # Update all existing sections to point to this new ID
        execute "UPDATE seccions SET nivel_id = #{default_nivel.id}"
      end
    end

    # 4. Now that every row has a value, we can safely enforce NOT NULL
    change_column_null :seccions, :nivel_id, false
  end
end