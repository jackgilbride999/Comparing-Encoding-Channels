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


int[] sectionXs, sectionYs;
int sectionHeight, sectionWidth, paddingTop, paddingLeft, paddingBottom, paddingRight;
int[] originXs, originYs;
int xWidth, yHeight;
int[] keyXs, keyYs;
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
  sectionXs = new int[]{0, width/2, width/4};
  sectionYs = new int[]{0, 0, height/2};
  sectionHeight = height/2;
  sectionWidth = width/2;
  paddingTop = paddingBottom = height/20;
  paddingLeft = width/5;
  paddingRight = width/40;
  originXs = new int[3];
  originYs = new int[3];
  xAxes = new String[]{"Income", "Income", "Income"};
  yAxes = new String[]{"Health", "Heath", "Health"};
  titles = new String[]{"Income vs Health", "Income vs Health", "Income vs Health"};
  keyXs= new int[3];
  keyYs = new int[3];

  xWidth = sectionWidth - paddingLeft - paddingRight;
  yHeight = sectionHeight - paddingTop - paddingBottom;

  myFont = createFont("ArialMT", 12, true);
  textFont(myFont);

  textAlign(CENTER);
  color(0, 0, 0);

  for (int i = 0; i < originXs.length; i++) {
    originXs[i] = sectionXs[i] + paddingLeft;
    originYs[i] = sectionYs[i] + sectionHeight - paddingBottom;
    keyXs[i] = sectionXs[i] + paddingLeft/10;
    keyYs[i] = sectionYs[i] + paddingTop;
  }

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

  for (int i = 0; i < 3; i++) {
    rect(sectionXs[i], sectionYs[i], width/2, height/2);

    line(originXs[i], originYs[i], originXs[i]+xWidth, originYs[i]);
    line(originXs[i], originYs[i], originXs[i], originYs[i]-yHeight);


    fill(0, 0, 0);
    textSize(16);
    text(titles[i], sectionXs[i]+paddingLeft + xWidth/2, sectionYs[i]+paddingTop*0.75);
    textSize(12);

    triangle(originXs[i]-2, originYs[i]-yHeight, originXs[i], originYs[i]-yHeight-5, originXs[i]+2, originYs[i]-yHeight);
    triangle(originXs[i]+xWidth, originYs[i]-2, originXs[i]+xWidth, originYs[i]+2, originXs[i]+xWidth+5, originYs[i]);
    textAlign(RIGHT);
    text(yAxes[i], originXs[i] - paddingLeft/8, originYs[i] - yHeight/2);
    textAlign(CENTER);
    text(xAxes[i], originXs[i] + xWidth/2, originYs[i] + paddingBottom*0.75);
    fill(255, 255, 255);

    if (i==0) {
      for (int j=0; j<N; j++) {
        colorMode(HSB, 360, 100, 100);
        fill(regionHues.get(countryRegions.get(country[j])), 100, 100);
        float xC = originXs[i] + ((float)income[j]/maxIncome)*xWidth;
        float yC = originYs[i] - (health[j]/maxHealth)*yHeight;
        circle(xC, yC, 5);
        colorMode(RGB, 255, 255, 255);
        fill(0, 0, 0);
      }
    } else if (i==1) {
      for (int j=0; j<N; j++) {
        colorMode(HSB, 360, 100, 100);

        fill(120, regionSaturations.get(countryRegions.get(country[j])), 100);
        float xC = originXs[i] + ((float)income[j]/maxIncome)*xWidth;
        float yC = originYs[i] - (health[j]/maxHealth)*yHeight;
        circle(xC, yC, 5);
        colorMode(RGB, 255, 255, 255);
        fill(0, 0, 0);
      }
    } else if (i==2) {
      for (int j=0; j<N; j++) {
        colorMode(HSB, 360, 100, 100);
        fill(120, 100, regionBrightnesses.get(countryRegions.get(country[j])));
        float xC = originXs[i] + ((float)income[j]/maxIncome)*xWidth;
        float yC = originYs[i] - (health[j]/maxHealth)*yHeight;
        circle(xC, yC, 5);
        colorMode(RGB, 255, 255, 255);
        fill(0, 0, 0);
        textSize(12);
      }
    }

    for (int k=0; k<=maxIncome; k+=(maxIncome/10)) {
      float value = originXs[i] + ((float)k/maxIncome)*xWidth;
      line(value, originYs[i], value, originYs[i]+5);
      if (k!=0) {
        stroke(240, 240, 240);
      }
      line(value, originYs[i], value, originYs[i]-yHeight);
      stroke(0, 0, 0);
      text(k, value, originYs[i]+paddingBottom*0.4);
    }
    textAlign(RIGHT);
    for (int l=0; l<=maxHealth; l+=(maxHealth/9))
    {
      float value = originYs[i] - ((float)l/maxHealth)*yHeight;
      line(originXs[i]-5, value, originXs[i], value);
      if (l!=0) {
        stroke(240, 240, 240);
      }
      line(originXs[i], value, originXs[i]+xWidth, value);
      stroke(0, 0, 0);
      text(l, originXs[i]-8, value+3);
    }
    textAlign(CENTER);

    fill(255, 255, 255);
    rect(keyXs[i], keyYs[i], keyWidth, keyHeight);
    fill(0, 0, 0);
    text("KEY", keyXs[i] + keyWidth/2, keyYs[i] + keyHeight/20);
    fill(255, 255, 255);

    textAlign(LEFT);
    colorMode(HSB, 360, 100, 100);
    for (int c = 0; c<uniqueRegions.size(); c++) {
      String region = uniqueRegions.get(c);
      int regionEncoding;
      if (i==0) {
        regionEncoding = regionHues.get(region);
        fill(regionEncoding, 100, 100);
      } else if (i==1) {
        regionEncoding = regionSaturations.get(region);
        fill(120, regionEncoding, 100);
      } else {
        regionEncoding = regionBrightnesses.get(region);
        fill(120, 100, regionEncoding);
      }


      circle(keyXs[i] + keyWidth/10, keyYs[i] + keyHeight/10 + c*((keyHeight*9/10)/uniqueRegions.size()), 5);
      fill(360, 100, 0);
      text(region, keyXs[i] + keyWidth/5, keyYs[i] + keyHeight/10 + c*((keyHeight*9/10)/uniqueRegions.size()) + 5);
    }
    colorMode(RGB, 255, 255, 255);
    textAlign(CENTER);
    fill(255, 255, 255);
  }
}
