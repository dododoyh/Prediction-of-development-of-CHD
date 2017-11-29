/*This is the SAS code for Coronary Heart Disease Prediction project */

libname s5238 "/courses/d0f434e5ba27fe300/sta5238";

/* Describe the orginal data*/
proc contents data=s5238.lipid5238;
run;

/*change data name to a simple one*/
data lipid;
set s5238.lipid5238;
run;

/*get missing data*/
proc means data=lipid n nmiss mean min max;
run;

/*Examine the effect of unknown values.*/
data lipidem;
  set lipid;
  nobmi=(bmi=.);
  nochol=(chol=.);
  nocurrsmok=(currsmok=.);
  nodbp=(dbp=.);
  noeversmok=(eversmok=.);
  nohdl=(hdl=.);
  noheight=(height=.);
  noldl=(ldl=.);
  nosbp=(sbp=.);
  noweight=(weight=.);
run;

proc freq data=lipidem;
  tables (nobmi nochol nocurrsmok nodbp noeversmok nohdl noheight noldl nosbp noweight)*chd10yr/nocol nopercent exact;
run;

/*Remove missing data and create a complete case dataset*/
data completelipid;
  set lipid;
  where bmi ne . and chol ne . and currsmok ne . and dbp ne . and eversmok ne .
        and hdl ne . and ldl ne . and sbp ne . and weight ne . and height ne .;
run;

proc means data=completelipid n nmiss mean min max;
run;

/*Examine relationships of continuous variables.*/
proc corr data=completelipid;
var age bmi chol dbp hdl height ldl sbp weight ;
run;

/*check Multi-colinearity*/
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=bmi;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=weight;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=bmi weight;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=chol;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=ldl;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=chol ldl;
run;ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=dbp;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=sbp;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=dbp sbp;
run;ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=height;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=weight;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=height weight;
run;

/*A quick look on whether relationships exist for categorical Variables*/
proc freq data=completelipid;
tables (currsmok diab eversmok male)*chd10yr/nocol nopercent chisq;
run;

/*A quick look on whether relationships exist for candidate Variables*/
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=age;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=bmi;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=chol;
run;
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=hdl;
run; 
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=sbp;
run; 
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=currsmok;
run; 
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=diab;
run; 
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=eversmok;
run; 
ods select parameterestimates;
proc logistic data=completelipid;
model chd10yr(event="1")=male;
run; 

/*contents of analytic dataset*/
data analyticlipid;
 set completelipid (drop=dbp height weight ldl);
run;
proc contents data=analyticlipid;
run;
proc means data=analyticlipid;
run;

/*Preliminary Multivariate Model*/
proc logistic data=analyticlipid plots=none;
model chd10yr(event="1")=age bmi chol currsmok diab eversmok hdl male sbp 
/clparm=both clodds=both;
run;

/*Likelihood ratio test for bmi*/
ods select globaltests;
proc logistic data=analyticlipid plots=none;
model chd10yr(event="1")=age bmi chol currsmok diab eversmok hdl male sbp;
run;
ods select globaltests;
proc logistic data=analyticlipid plots=none;
model chd10yr(event="1")=age chol currsmok diab eversmok hdl male sbp;
run;

/*Likelihood ratio test for eversmok*/
ods select globaltests;
proc logistic data=analyticlipid plots=none;
model chd10yr(event="1")=age bmi chol currsmok diab eversmok hdl male sbp;
run;
ods select globaltests;
proc logistic data=analyticlipid plots=none;
model chd10yr(event="1")=age bmi chol currsmok diab hdl male sbp;
run;
