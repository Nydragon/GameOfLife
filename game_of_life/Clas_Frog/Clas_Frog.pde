Table table;

void setup() {  
  table = new Table();
  
  table.addColumn("id");
  table.addColumn("species");
  table.addColumn("name");
  
  TableRow newRow = table.addRow();
  newRow.setInt("id", table.lastRowIndex());
  newRow.setString("species", "Panthera leo");
  newRow.setString("name", "Lion");


  saveTable(table, "new.csv");
}
