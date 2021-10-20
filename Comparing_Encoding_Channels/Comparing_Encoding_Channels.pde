String[] country;
String[] region;
int[] income;
float[] health;
int[] population;

int[] sectionXs, sectionYs;
int sectionHeight, sectionWidth, paddingTop, paddingLeft, paddingBottom, paddingRight;
int[] originXs, originYs;
int xWidth, yHeight;

int maxIncome, maxPopulation;
float maxHealth;
int N;


void settings(){
  final int width = displayWidth/6*5;
  final int height = displayHeight/6*5;
  size(width, height);
}

void setup(){ 
  sectionXs = new int[]{0, width/2, 0, width/2};
  sectionYs = new int[]{0, 0, height/2, height/2};
  sectionHeight = height/2;
  sectionWidth = width/2;
  paddingTop = paddingBottom = height/20;
  paddingLeft = paddingRight = width/20;
  originXs = new int[4];
  originYs = new int[4];

  for(int i = 0; i < originXs.length; i++){
     originXs[i] = sectionXs[i] + paddingLeft;
     originYs[i] = sectionYs[i] + sectionHeight - paddingBottom;
  }

  xWidth = sectionWidth - paddingLeft - paddingRight;
  yHeight = sectionHeight - paddingTop - paddingBottom;
  
  
  Table table;
  table = loadTable("health-income-withregions.csv", "header");
  N = table.getRowCount();
  initArrays(N, table);
  
  for(int i=0; i<N; i++){
     System.out.println("" + country[i] + " " + region[i] + " " + income[i] + " " + health[i] + " " + population[i]);
  }
  
  System.out.println("" + paddingLeft);
  System.out.println("" + paddingTop);
  
  
}

void initArrays(int N, Table table){
  country = new String[N];
  region = new String[N];
  income = new int[N];
  health = new float[N];
  population = new int[N];
  
  for(int i=0; i<N; i++){
     TableRow row = table.getRow(i);
     country[i] = row.getString("country");
     region[i] = row.getString("region");
     income[i] = row.getInt("income");
     health[i] = row.getFloat("health");
     population[i] = row.getInt("population");
  }
  
  maxIncome = max(income);
  maxHealth = max(health);
  maxPopulation = max(population);
}

void draw(){
  for(int i = 0; i < 4; i++){
     rect(sectionXs[i], sectionYs[i], width/2, height/2); 

     line(originXs[i], originYs[i], originXs[i]+xWidth, originYs[i]);
     line(originXs[i], originYs[i], originXs[i], originYs[i]-yHeight);
     
     fill(0,0,0);
     text("X", originXs[i] + xWidth/2, originYs[i] + paddingBottom/2);
     text("Y", originXs[i] - paddingLeft/2, originYs[i] - yHeight/2);
     fill(255,255,255);
     
     if(i==0){
       for(int j=0; j<N; j++){
         float xC = originXs[i] + (health[j]/maxHealth)*xWidth;
         float yC = originYs[i] - ((float)income[j]/maxIncome)*yHeight;
        circle(xC, yC, 5); 
       }
     } else if (i==1) {
       for(int j=0; j<N; j++){
         float xC = originXs[i] + (health[j]/maxHealth)*xWidth;
         float yC = originYs[i] - ((float)population[j]/maxPopulation)*yHeight;
         System.out.println("x: " + xC + " y: " + yC);
        circle(xC, yC, 5); 
       }
     }
       else if (i==2) {
       for(int j=0; j<N; j++){
         float xC = originXs[i] + ((float)income[j]/maxIncome)*xWidth;
         float yC = originYs[i] - ((float)population[j]/maxPopulation)*yHeight;
         System.out.println("x: " + xC + " y: " + yC);
        circle(xC, yC, 5); 
       }  
     }


}
  
  
}
