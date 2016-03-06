data playerstats;
 input name$ point rebounds assists fouls bonus; 
 cards;
 Zhaorui 15 5 7 3 1000 
 Qifeng 0 5 2 5 100
 Chengchi 28 15 6 2 4000
 Guokai 18 9 2 4 1500
 Wangzeqi 8 8 8 4 1200
 Zhangmeng 10 2 3 3 800
 run;
 
 proc print data=playerstats;
 var name bonus;
 sum bonus;
 format bonus dollar8.2;
 run;
 
 proc means data=playerstats;
 var name$ bonus;
 run;