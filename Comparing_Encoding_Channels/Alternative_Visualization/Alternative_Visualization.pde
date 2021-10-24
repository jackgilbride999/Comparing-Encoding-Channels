String[] country;
String[] region;
int[] income;
float[] health;
int[] population;
List<String> uniqueRegions;
Map<String, String> countryRegions;
Map<String, Long> regionPopulations;

int sectionX, sectionY;
int paddingTop, paddingLeft, paddingBottom, paddingRight;
int originX, originY;
int xWidth, yHeight;
int keyX, keyY;
int keyWidth, keyHeight;

int maxIncome, maxPopulation;
float maxHealth;
long maxRegionPopulation;
int N;

PFont myFont;

import java.util.*;
import java.util.stream.Collectors;

void settings() {
  final int width = displayWidth/6*5;
  final int height = displayHeight/6*5;
  size(width, height);
}

void setup() {

  paddingTop = paddingBottom = height/10;
  paddingLeft = width/5;
  paddingRight = width/40;

  xWidth = width - paddingLeft - paddingRight;
  yHeight = height - paddingTop - paddingBottom;

  myFont = createFont("ArialMT", 12, true);
  textFont(myFont);

  textAlign(CENTER);
  color(0, 0, 0);

  originX = 0 + paddingLeft;
  originY = 0 + height - paddingBottom;
  keyX = 0 + paddingLeft/10;
  keyY = 0 + paddingTop;

  keyWidth = paddingLeft - 2*(paddingLeft/5);
  keyHeight = yHeight;

  Table table;
  table = loadTable("../health-income-withregions-altered.csv", "header");
  N = table.getRowCount();
  initArrays(N, table);

}

void initArrays(int N, Table table) {
  country = new String[N];
  region = new String[N];
  income = new int[N];
  health = new float[N];
  population = new int[N];
  countryRegions = new HashMap<String, String>();
  regionPopulations = new HashMap<String, Long>();


  for (int i=0; i<N; i++) {
    TableRow row = table.getRow(i);
    country[i] = row.getString("country");
    region[i] = row.getString("region");
    income[i] = row.getInt("income");
    health[i] = row.getFloat("health");
    population[i] = row.getInt("population");
    countryRegions.put(row.getString("country"), row.getString("region"));
    regionPopulations.put(row.getString("region"), regionPopulations.get(row.getString("region"))!=null ? regionPopulations.get(row.getString("region")) + row.getInt("population") : row.getInt("population"));
  }
  uniqueRegions = Arrays.asList(region).stream().distinct().collect(
    Collectors.toList());

  maxIncome = max(income);
  maxHealth = max(health);
  maxPopulation = 1500000000;
  maxRegionPopulation = 0;
  for(long regionPopulation : regionPopulations.values()){
      if(regionPopulation > maxRegionPopulation){
         maxRegionPopulation = regionPopulation; 
      }
  }
  
  System.out.println(maxRegionPopulation);
}

void draw() {

    rect(0, 0, width, height);
    
    
    float[] topsOfStacks = new float[uniqueRegions.size()];

    line(originX, originY, originX+xWidth, originY);
    line(originX, originY, originX, originY-yHeight);

    fill(0, 0, 0);
    textSize(16);
    text("Population, Income, and Health per country", 0+paddingLeft + xWidth/2, 0+paddingTop*0.75);
    textSize(12);

    triangle(originX-2, originY-yHeight, originX, originY-yHeight-5, originX+2, originY-yHeight);
    triangle(originX+xWidth, originY-2, originX+xWidth, originY+2, originX+xWidth+5, originY);
    textAlign(CENTER);

    for (int k=0; k<uniqueRegions.size(); k++){
          textAlign(CENTER);
        float x1 = originX + ((float)k/uniqueRegions.size())*xWidth;
        float x2 = originX + ((float)(k+1)/uniqueRegions.size())*xWidth;
        line(x1, originY, x1, originY+5);
        line(x2, originY, x2, originY+5);
        textLeading(15);
        text(uniqueRegions.get(k).trim().replace(" ", "\n"), x1 + (x2-x1)/2, originY+paddingBottom*0.3);
      }
    
    for(int i = 0; i < country.length; i++){
       String thisRegion = countryRegions.get(country[i]);
       int regionIndex = 0;
       for(regionIndex=0; !thisRegion.equals(uniqueRegions.get(regionIndex)); regionIndex++);

       float regionX =  originX + ((float)regionIndex/uniqueRegions.size())*xWidth;
       float regionWidth = (originX + ((float)(regionIndex+1)/uniqueRegions.size())*xWidth)-regionX;
              
       float regionY = topsOfStacks[regionIndex];
       float regionHeight = yHeight * ((float)population[i]/maxRegionPopulation);
       
       topsOfStacks[regionIndex] = regionY+regionHeight;
       
       colorMode(HSB, 360, 100, 100);
       color bivariateColor1 = color(199, (100 * (income[i])/maxIncome), 100);
       color bivariateColor2 = color(44, (100 * (health[i])/maxHealth), 100);
       color blendedColor = blendColor(bivariateColor1, bivariateColor2, MULTIPLY);       
       fill(blendedColor);
       
       rect(regionX, originY-topsOfStacks[regionIndex], regionWidth, regionHeight);
       colorMode(RGB, 255, 255, 255);
       
    }
      
    fill(255, 255, 255);

}
