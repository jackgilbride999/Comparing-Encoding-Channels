String[] country;
String[] region;
int[] income;
float[] health;
int[] population;
Map<String, String> countryRegions;
Map<String, Integer> regionHues;
List<String> uniqueRegions;

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
import java.text.NumberFormat;

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
  yAxes = new String[]{"Health", "Health", "Health"};
  titles = new String[]{"Income vs Health", "Income vs Health", "Income vs Health"};
  keyXs= new int[3];
  keyYs = new int[3];

  for (int i = 0; i < originXs.length; i++) {
    originXs[i] = sectionXs[i] + paddingLeft;
    originYs[i] = sectionYs[i] + sectionHeight - paddingBottom;
    keyXs[i] = sectionXs[i] + paddingLeft/10;
    keyYs[i] = sectionYs[i] + paddingTop;
  }

  xWidth = sectionWidth - paddingLeft - paddingRight;
  yHeight = sectionHeight - paddingTop - paddingBottom;

  keyWidth = paddingLeft - 2*(paddingLeft/5);
  keyHeight = yHeight;

  myFont = createFont("ArialMT", 12, true);
  textFont(myFont);

  Table table;
  table = loadTable("../health-income-withregions.csv", "header");
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
  regionHues = new HashMap<String, Integer>();

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

    fill(0, 0, 0);
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
        // stroke(0, 0);
        translate(xC, yC);
        float angle = PI*((float)sqrt(population[j])/sqrt(maxPopulation));
        rotate(angle);
        triangle(-2, 5, 2, 5, 0, -5);
        //rect(0, 0, 5, 2);
        rotate(-angle);
        translate(-xC, -yC);
        stroke(0, 255);
        colorMode(RGB, 255, 255, 255);
        fill(0, 0, 0);
      }
    } else if (i==1) {
      for (int j=0; j<N; j++) {
        colorMode(HSB, 360, 100, 100);
        fill(0, 0, 100-100*((float)sqrt(population[j])/sqrt(maxPopulation)));

        float xC = originXs[i] + ((float)income[j]/maxIncome)*xWidth;
        float yC = originYs[i] - (health[j]/maxHealth)*yHeight;
        circle(xC, yC, 10);
        fill(regionHues.get(countryRegions.get(country[j])), 100, 100);
        circle(xC, yC, 5);

        colorMode(RGB, 255, 255, 255);
        fill(0, 0, 0);
      }
    } else if (i==2) {
      for (int j=0; j<N; j++) {
        colorMode(HSB, 360, 100, 100);
        fill(regionHues.get(countryRegions.get(country[j])), 100, 100);
        float xC = originXs[i] + ((float)income[j]/maxIncome)*xWidth;
        float yC = originYs[i] - (health[j]/maxHealth)*yHeight;
        float rC = (sqrt(population[j])/(5*sqrt(min(population))));
        circle(xC, yC, rC);
        colorMode(RGB, 255, 255, 255);
        fill(0, 0, 0);
      }
    }


    for (int k=0; k<=maxIncome; k+=(maxIncome/10)) {
      float value = originXs[i] + ((float)k/maxIncome)*xWidth;
      line(value, originYs[i], value, originYs[i]+5);
      text(k, value, originYs[i]+paddingBottom*0.4);
    }
    textAlign(RIGHT);
    for (int l=0; l<=maxPopulation; l+=(maxPopulation/10))
    {
      float value = originYs[i] - ((float)l/maxPopulation)*yHeight;
      line(originXs[i]-5, value, originXs[i], value);
      text(l/1000000, originXs[i]-8, value+3);
    }
    textAlign(CENTER);
    fill(255, 255, 255);

    rect(keyXs[i], keyYs[i], keyWidth, keyHeight);
    fill(0, 0, 0);
    text("POPULATION KEY", keyXs[i] + keyWidth/2, keyYs[i] + keyHeight/20);
    fill(255, 255, 255);
  }


  textAlign(LEFT);
  int keyNumRotations = 5;
  for (int c=0; c<=keyNumRotations; c++) {
    colorMode(HSB, 360, 100, 100);
    fill(100, 100, 100);
    float xC = keyXs[0] + keyWidth/8;
    float yC = keyYs[0] + keyHeight/8 + c*((keyHeight*8/10)/keyNumRotations);
    // stroke(0, 0);
    translate(xC, yC);

    float angle = c * ((PI)/keyNumRotations);

    // = 2*PI*((float)population[j]/maxPopulation);
    rotate(angle);
    triangle(-2, 5, 2, 5, 0, -5);
    //rect(0, 0, 5, 2);
    rotate(-angle);
    translate(-xC, -yC);
    stroke(0, 255);
    colorMode(RGB, 255, 255, 255);
    fill(0, 0, 0);
    float population = pow((c * (sqrt(maxPopulation)/keyNumRotations)), 2);
    String pop = NumberFormat.getInstance().format(population);

    text(pop, xC + 20, yC + 2);
  }
  textAlign(CENTER);


  textAlign(LEFT);
  int keyNumBrightnesses = 5;
  for (int c=0; c<=keyNumBrightnesses; c++) {

    colorMode(HSB, 360, 100, 100);

    int brightness =  c * 100/keyNumBrightnesses;
    fill(100, 0, 100-brightness);

    circle(keyXs[1] + keyWidth/10, keyYs[1] + keyHeight/10 + c*((keyHeight*8/10)/keyNumBrightnesses), 5);
    fill(360, 100, 0);

    float population = pow((c * (sqrt(maxPopulation)/keyNumBrightnesses)), 2);
    String pop = NumberFormat.getInstance().format(population);

    text(pop, keyXs[1] + keyWidth/5, keyYs[1] + keyHeight/10 + c*((keyHeight*8/10)/keyNumBrightnesses) + 5);
    colorMode(RGB, 255, 255, 255);
    fill(0, 0, 0);
  }
  textAlign(CENTER);


  textAlign(LEFT);
  int keyNumSizes = 5;
  for (int c=0; c<=keyNumSizes; c++) {

    colorMode(HSB, 360, 100, 100);

    float size =  c * maxPopulation/keyNumSizes;
    size = (sqrt((maxPopulation/keyNumSizes)*c)/(5*sqrt(min(population))));

    fill(100, 100, 100);

    circle(keyXs[2] + keyWidth/8, keyYs[2] + keyHeight/10 + c*((keyHeight*8/10)/keyNumSizes), size+1);
    fill(360, 100, 0);

    float population = pow((c * (sqrt(maxPopulation)/keyNumSizes)), 2);
    String pop = NumberFormat.getInstance().format(population);

    text(pop, keyXs[2] + keyWidth/4, keyYs[2] + keyHeight/10 + c*((keyHeight*8/10)/keyNumSizes) + 5);
    colorMode(RGB, 255, 255, 255);
    fill(0, 0, 0);
  }
  textAlign(CENTER);

  fill(255, 255, 255);
  rect(keyXs[0], keyYs[2], keyWidth, keyHeight);
  fill(0, 0, 0);
  text("REGION KEY", keyXs[0] + keyWidth/2, keyYs[2] + keyHeight/20);
  fill(255, 255, 255);

  textAlign(LEFT);
  colorMode(HSB, 360, 100, 100);
  for (int c = 0; c<uniqueRegions.size(); c++) {
    String region = uniqueRegions.get(c);
    int regionEncoding;
    regionEncoding = regionHues.get(region);
    fill(regionEncoding, 100, 100);

    circle(keyXs[0] + keyWidth/10, keyYs[2] + keyHeight/10 + c*((keyHeight*9/10)/uniqueRegions.size()), 10);
    fill(360, 100, 0);
    text(region, keyXs[0] + keyWidth/5, keyYs[2] + keyHeight/10 + c*((keyHeight*9/10)/uniqueRegions.size()) + 5);
  }
  colorMode(RGB, 255, 255, 255);
  textAlign(CENTER);
  fill(255, 255, 255);
}
