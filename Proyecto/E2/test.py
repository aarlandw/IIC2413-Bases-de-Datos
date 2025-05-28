import pandas as pd

df = pd.read_csv('csv/agenda_reserva.csv')
df2 = pd.read_csv('csv/review_seguro.csv')

def print_unique_values(df, df_cols):   
    for column in df_cols:
        if column in df.columns:
            print(f"Unique values in '{column}': {df[column].unique()}")
        else:
            print(f"Column '{column}' not found in DataFrame.")

def print_value_counts(df, column):
    if column in df.columns:
        value_counts = df[column].value_counts()
        print(f"Value counts for '{column}':")
        print(value_counts)
    else:
        print(f"Column '{column}' not found in DataFrame.")

# print number of rows where multiple columns meet a condition
def print_rows_with_conditions(df, conditions):
    filtered_df = df
    for column, value in conditions.items():
        if column in df.columns:
            filtered_df = filtered_df[filtered_df[column] == value]
        else:
            print(f"Column '{column}' not found in DataFrame.")
            return
    print(f"Number of rows where {conditions}: {len(filtered_df)}")


print_rows_with_conditions(df, {
    'estado_disponibilidad': 'Disponible',
    'agenda_id': ''
})

# print_value_counts(df, 'estado_disponibilidad')


print_unique_values(df, [
    'etiqueta',
    'nombre_panorama'
    'clase',
    'duracion'
])
    
# print_unique_values(df2, [
#     'tiempo_estimado'
# ])
