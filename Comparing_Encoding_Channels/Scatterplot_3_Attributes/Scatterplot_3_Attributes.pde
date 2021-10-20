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

String[] xAxes, yAxes;


void settings(){
  final int width = displayWidth/6*5;
  final int height = displayHeight/6*5;
  size(width, height);
}

void setup(){ 
  sectionXs = new int[]{0, width/2, width/4};
  sectionYs = new int[]{0, 0, height/2};
  sectionHeight = height/2;
  sectionWidth = width/2;
  paddingTop = paddingBottom = height/20;
  paddingLeft = paddingRight = width/20;
  originXs = new int[3];
  originYs = new int[3];
  xAxes = new String[]{"Income", "Income", "Heatlh"};
  yAxes = new String[]{"Health", "Pop.", "Pop."};

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
  for(int i = 0; i < 3; i++){
     rect(sectionXs[i], sectionYs[i], width/2, height/2); 

     line(originXs[i], originYs[i], originXs[i]+xWidth, originYs[i]);
     line(originXs[i], originYs[i], originXs[i], originYs[i]-yHeight);
     
     fill(0,0,0);
     text(xAxes[i], originXs[i] + xWidth/2, originYs[i] + paddingBottom/2);
     text(yAxes[i], originXs[i] - paddingLeft/2, originYs[i] - yHeight/2);
     fill(255,255,255);
     

     
     if(i==0){
       for(int j=0; j<N; j++){
         colorMode(HSB, 360, 100, 100);
         fill(j*360/N, 100, 100); 
         float xC = originXs[i] + ((float)income[j]/maxIncome)*xWidth;
         float yC = originYs[i] - (health[j]/maxHealth)*yHeight;
        circle(xC, yC, 5); 
        colorMode(RGB, 255, 255, 255);
       }
     } else if (i==1) {
       for(int j=0; j<N; j++){
         colorMode(HSB, 360, 100, 100);

         fill(120, j*100/N, 60); 
         float xC = originXs[i] + ((float)income[j]/maxIncome)*xWidth;
         float yC = originYs[i] - ((float)population[j]/maxPopulation)*yHeight;
         circle(xC, yC, 5); 
         colorMode(RGB, 255, 255, 255);
       }
     }
       else if (i==2) {
       for(int j=0; j<N; j++){
         colorMode(HSB, 360, 100, 100);
         fill(120, 100, j*100/N); 
         float xC = originXs[i] + (health[j]/maxHealth)*xWidth;
         float yC = originYs[i] - ((float)population[j]/maxPopulation)*yHeight;
         circle(xC, yC, 5); 
         colorMode(RGB, 255, 255, 255);

       }  
     }
      fill(255,255,255);



}
  
  
}
