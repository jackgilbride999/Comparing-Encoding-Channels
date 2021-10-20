String[] countries;
String[] regions;
long[] income;
double[] health;
long[] population;

void settings(){
  final int width = displayWidth/6*5;
  final int height = displayHeight/6*5;
  size(width, height);
}

void setup(){
  
  Table table;
  table = loadTable("health-income-withregions.csv", "header");
  int N = table.getRowCount();
  initArrays(N);
  
  for(int i=0; i<N; i++){
     System.out.println("" + countries[N] + " " + regions[N] + " " + income[N] + " " + health[N] + " " + population[N]);
  }
  
}

void initArrays(int N){
  countries = new String[N];
  regions = new String[N];
  income = new long[N];
  health = new double[N];
  population = new long[N];
}
