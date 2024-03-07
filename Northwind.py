import streamlit as st
import pyodbc
import pandas as pd
 
server = r'IN3539772W2\SQLEXPRESS'
database = 'NORTHWIND'
 
conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server}; \
                        SERVER=' + server + '; \
                        DATABASE=' + database + '; \
                        Trusted_Connection=yes')
 
cursor = conn.cursor()
print("Connected to the SQL Server.")
 
 
 
def view_tables():
    schema_names = ['dbo', 'NW_LANDING', 'NW_STAGING', 'NW_DW']
    layer_names = ['OLTP', 'Landing Layer', 'Staging Layer', 'Data Warehouse Layer']
   
    for schema, layer in zip(schema_names, layer_names):
        with st.expander(layer):  
            cursor.execute(f"SELECT [TABLE_NAME] FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '{schema}' AND TABLE_TYPE = 'BASE TABLE'")
            tables = [row.TABLE_NAME for row in cursor.fetchall()]
 
            selected_table = st.selectbox('Select a table', tables, key='select_'+schema)
 
            if st.button('View selected table', key='button_'+schema):
                query = f"SELECT * FROM {schema}.[{selected_table}]"
                df = pd.read_sql(query, conn)
                st.dataframe(df)
 
def warehouse_dashboard():
   
   
    if st.button('Create Tables'):
        cursor.execute("{CALL CREATE_ALL}")
        conn.commit()
        st.write("ALL Tables have been Created")
 
    procedures = ['DW_LoadData', 'LND_LoadData', 'STG_LoadData']
    selected_procedure = st.selectbox('Select a procedure', procedures)
 
    if st.button('Run selected procedure to load data to any of the layers '):
        cursor.execute("{CALL "+selected_procedure+"}")
        conn.commit()
        st.write(f"Procedure {selected_procedure} has been executed.")
 
    if st.button('Load Data to DW'):
        cursor.execute("{CALL LOAD_ALL}")
        conn.commit()
        st.write("Data has been loaded to the Datawarehouse")
   
    if st.button('DELETE all Tables'):
        cursor.execute("{CALL DROP_ALL}")
        conn.commit()
        st.write("All tables have been deleted !")
 
def oltp_update():
    st.write("SQL Commands Execute")
    sql_command = st.text_area('Enter your SQL command here:', value='', key='sql_command', height=200)
    run_query = st.button('Execute')
 
    if run_query:
        try:
            cursor.execute(sql_command)
   
            if sql_command.lower().startswith('select'):
                rows = cursor.fetchall()
                # pandas to print the rows
                data = pd.DataFrame.from_records(rows)
                st.dataframe(data)
            else:
                # if the command is not a SELECT statement
                conn.commit()
                st.success("SQL executed successfully.")
        except Exception as e:
            st.error(f'An error occurred: {e}')
 
pages = {
    'View Tables': view_tables,
    'Warehouse Dashboard': warehouse_dashboard,
    'EXECUTE SQL COMMANDS ' : oltp_update
}
 
page = st.sidebar.radio("Select your page", tuple(pages.keys()))
 
st.write(pages[page]())