# Project Flow :

SQL files - 
  Landing Layer : LND Table Creation --> LND Load Data
  Staging Layer : STG Table Creation --> STG load Data 
  DW Layer      : DW Table Creation --> DW Load Data --> DW Fact Load 
  
  Truncating Landing layer  : LND Truncate 
  Every Procedure execution : MAIN

Python file - 
  Dashboard : Northwind.py
