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
import java.text.NumberFormat;


void settings() {
  final int width = displayWidth/6*5;
  final int height = displayHeight/6*5;
  size(width, height);
}

void setup() {

  paddingTop = paddingBottom = height/10;
  paddingLeft = width/4;
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

  maxIncome = 150000;
  maxHealth = 90;
  maxPopulation = 1500000000;
  maxRegionPopulation = 1400000000;

  System.out.println(maxRegionPopulation);
}

void draw() {

  rect(0, 0, width, height);


  float[] topsOfStacks = new float[uniqueRegions.size()];

  line(originX, originY, originX+xWidth, originY);
  line(originX, originY, originX, originY-yHeight);

  fill(0, 0, 0);
  textSize(20);
  text("Population, Income, and Life Expectancy Per Country", 0+paddingLeft + xWidth/2, 0+paddingTop*0.5);
  textSize(12);

  triangle(originX-2, originY-yHeight, originX, originY-yHeight-5, originX+2, originY-yHeight);
  triangle(originX+xWidth, originY-2, originX+xWidth, originY+2, originX+xWidth+5, originY);
  textAlign(CENTER);

  for (int k=0; k<uniqueRegions.size(); k++) {
    textAlign(CENTER);
    float x1 = originX + ((float)k/uniqueRegions.size())*xWidth;
    float x2 = originX + ((float)(k+1)/uniqueRegions.size())*xWidth;
    line(x1, originY, x1, originY+5);
    line(x2, originY, x2, originY+5);
    textLeading(15);
    text(uniqueRegions.get(k).trim().replace(" ", "\n"), x1 + (x2-x1)/2, originY+paddingBottom*0.3);
  }
  textAlign(RIGHT);
  fill(0, 0, 0);

  for (int l=0; l<=maxRegionPopulation; l+=100000000)
  {
    float value = originY - ((float)l/maxRegionPopulation)*yHeight;
    stroke(210,210,210);
    line(originX, value, originX+xWidth, value);
    stroke(0,0,0);
    line(originX-5, value, originX, value);
    String pop = NumberFormat.getInstance().format(l);
    text(pop, originX-8, value+3);
    
  }
  text("Population", originX-8, originY - yHeight*(maxRegionPopulation+50000000)/maxRegionPopulation);
  text("Regions", originX, originY+paddingBottom*0.3);

  fill(0, 0, 0);
  textAlign(CENTER);
  
  
  for (int i = 0; i < country.length; i++) {
    String thisRegion = countryRegions.get(country[i]);
    int regionIndex = 0;
    for (regionIndex=0; !thisRegion.equals(uniqueRegions.get(regionIndex)); regionIndex++);

    float regionX =  originX + ((float)regionIndex/uniqueRegions.size())*xWidth;
    float regionWidth = (originX + ((float)(regionIndex+1)/uniqueRegions.size())*xWidth)-regionX;

    float regionY = topsOfStacks[regionIndex];
    float regionHeight = yHeight * ((float)population[i]/maxRegionPopulation);

    topsOfStacks[regionIndex] = regionY+regionHeight;

    colorMode(HSB, 360, 100, 100);
    color bivariateColor1 = color(227, (100 * (income[i])/maxIncome), 100);
    color bivariateColor2 = color(44, (100 * (health[i])/maxHealth), 100);
    color blendedColor = blendColor(bivariateColor1, bivariateColor2, MULTIPLY);
    fill(blendedColor);

    rect(regionX, originY-topsOfStacks[regionIndex], regionWidth, regionHeight);
    colorMode(RGB, 255, 255, 255);
  }

  fill(0,0,0);
  
  float gridX = keyX + keyWidth/4;
  float gridY = keyY + 3*keyWidth/10;
  float gridWidth = keyWidth - 2*keyWidth/10;
  float gridHeight = keyWidth - 2*keyWidth/10;
  rect(gridX, gridY, gridWidth, gridHeight);
  
  text("BIVARIATE KEY", gridX + gridWidth/2, gridY - 20);
  
  colorMode(HSB, 360, 100, 100);
  color fullBlue = color(227, 100, 100);
  fill(fullBlue);
  rect(gridX, gridY, gridWidth/3, gridHeight/3);
  color halfBlue = color(227, 50, 100);
  fill(halfBlue);
  rect(gridX, gridY+gridHeight/3, gridWidth/3, gridHeight/3);
  color white = color(227, 0, 100);
  fill(white);
  rect(gridX, gridY+2*gridHeight/3, gridWidth/3, gridHeight/3);
  
  color halfOrange = color (44, 50, 100);
  fill(halfOrange);
  rect(gridX+gridWidth/3, gridY+2*gridHeight/3, gridWidth/3, gridHeight/3);
  color fullOrange = color(44, 100, 100);
  fill(fullOrange);
  rect(gridX+2*gridWidth/3, gridY+2*gridHeight/3, gridWidth/3, gridHeight/3);
  
  color halfBlend = blendColor(halfOrange, halfBlue, MULTIPLY);
  fill(halfBlend);
  rect(gridX+gridWidth/3, gridY+gridHeight/3, gridWidth/3, gridHeight/3);
  
  color fullBlend = blendColor(fullOrange, fullBlue, MULTIPLY);
  fill(fullBlend);
  rect(gridX+2*gridWidth/3, gridY, gridWidth/3, gridHeight/3);
  
  color mostOrange = blendColor(fullOrange, halfBlue, MULTIPLY);
  fill(mostOrange);
  rect(gridX+2*gridWidth/3, gridY+gridHeight/3, gridWidth/3, gridHeight/3);
  
  color mostBlue = blendColor(halfOrange, fullBlue, MULTIPLY);
  fill(mostBlue);
  rect(gridX+gridWidth/3, gridY, gridWidth/3, gridHeight/3);
  
  fill(0,0,0);
  
  textAlign(CENTER);
  text(0, gridX+gridWidth/6, gridY+gridHeight+15);
  text((int)maxHealth/2, gridX+gridWidth/2, gridY+gridHeight+15);
  text((int)maxHealth, gridX+gridWidth*5/6, gridY+gridHeight+15);
  
  text("Life\nExpectancy\n(Years)", gridX+gridWidth/2, gridY+gridHeight+35);

  textAlign(RIGHT);
  text(0, gridX-5, gridY+gridHeight/6);
  text((int)maxIncome/2, gridX-5, gridY+gridHeight/2);
  text((int)maxIncome, gridX-5, gridY+gridHeight*5/6);
  
  text("Income", gridX-gridWidth/4, gridY+gridHeight/2);
  
  textAlign(CENTER);
  colorMode(RGB, 255, 255, 255);
  fill(255, 255, 255);
}
