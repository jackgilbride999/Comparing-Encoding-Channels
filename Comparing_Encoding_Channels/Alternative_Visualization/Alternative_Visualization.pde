String[] country;
String[] region;
int[] income;
float[] health;
int[] population;
List<String> uniqueRegions;
Map<String, String> countryRegions;
Map<String, Integer> regionHues;
Map<String, Integer> regionSaturations;
Map<String, Integer> regionBrightnesses;


int sectionX, sectionY;
int paddingTop, paddingLeft, paddingBottom, paddingRight;
int originX, originY;
int xWidth, yHeight;
int keyX, keyY;
int keyWidth, keyHeight;

int maxIncome, maxPopulation;
float maxHealth;
int N;

String[] xAxes, yAxes, titles;

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

  xAxes = new String[]{"Income", "Income", "Income"};
  yAxes = new String[]{"Health", "Heath", "Health"};
  titles = new String[]{"Income vs Health", "Income vs Health", "Income vs Health"};


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
  table = loadTable("../health-income-withregions.csv", "header");
  N = table.getRowCount();
  initArrays(N, table);

  for (int i=0; i<N; i++) {
    System.out.println("" + country[i] + " " + region[i] + " " + income[i] + " " + health[i] + " " + population[i]);
  }

  System.out.println("" + paddingLeft);
  System.out.println("" + paddingTop);

  System.out.println(maxIncome + " " + maxHealth + " " + maxPopulation);
}

void initArrays(int N, Table table) {
  country = new String[N];
  region = new String[N];
  income = new int[N];
  health = new float[N];
  population = new int[N];
  countryRegions = new HashMap<String, String>();
  regionHues = new HashMap<String, Integer>();
  regionSaturations = new HashMap<String, Integer>();
  regionBrightnesses = new HashMap<String, Integer>();

  for (int i=0; i<N; i++) {
    TableRow row = table.getRow(i);
    country[i] = row.getString("country");
    region[i] = row.getString("region");
    income[i] = row.getInt("income");
    health[i] = row.getFloat("health");
    population[i] = row.getInt("population");
    countryRegions.put(row.getString("country"), row.getString("region"));
  }
  uniqueRegions = Arrays.asList(region).stream().distinct().collect(
    Collectors.toList());
  for (int i=0; i < uniqueRegions.size(); i++)
  {
    regionHues.put(uniqueRegions.get(i), i* 360/uniqueRegions.size());
    regionSaturations.put(uniqueRegions.get(i), i * 100/uniqueRegions.size());
    regionBrightnesses.put(uniqueRegions.get(i), i* 100/uniqueRegions.size());
  }
  maxIncome = 150000;
  maxHealth = 90;
  maxPopulation = 1500000000;
}

void draw() {

    rect(0, 0, width, height);

    line(originX, originY, originX+xWidth, originY);
    line(originX, originY, originX, originY-yHeight);


    fill(0, 0, 0);
    textSize(16);
    text("title", 0+paddingLeft + xWidth/2, 0+paddingTop*0.75);
    textSize(12);

    triangle(originX-2, originY-yHeight, originX, originY-yHeight-5, originX+2, originY-yHeight);
    triangle(originX+xWidth, originY-2, originX+xWidth, originY+2, originX+xWidth+5, originY);
    textAlign(RIGHT);
    text("Y", originX - paddingLeft/8, originY - yHeight/2);
    textAlign(CENTER);
    text("x", originX + xWidth/2, originY + paddingBottom*0.75);

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
       
       
       
       rect(regionX, originY-100, regionWidth, 100);
    }
      
    fill(255, 255, 255);

}
