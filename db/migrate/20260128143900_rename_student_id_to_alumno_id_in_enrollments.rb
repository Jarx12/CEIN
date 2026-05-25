class RenameStudentIdToAlumnoIdInEnrollments < ActiveRecord::Migration[8.0]
def change
    # 1. Eliminamos la referencia incorrecta a 'student'
    # Solo si existe el índice/columna student_id
    remove_reference :enrollments, :student, foreign_key: true if column_exists?(:enrollments, :student_id)

    # 2. Creamos la referencia correcta a 'alumno'
    # Esto creará automáticamente la columna alumno_id con su índice y llave foránea
    add_reference :enrollments, :alumno, null: false, foreign_key: true
  end
end