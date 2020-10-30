options nocenter validvarname=any;

*---Read in space-delimited ascii file;

data new_data;


infile 'nls_30_35_updated.dat' lrecl=98 missover DSD DLM=' ' print;
input
  R0000100
  R0536300
  R0536402
  R1235800
  R1482600
  U1845600
  U1846000
  U1852300
  U1852500
  U1852600
  U1853200
  U2857200
  U2857300
  U2857500
  U2857600
  Z9083900
  Z9122200
  Z9122300
  Z9122500
  Z9141700
  Z9141800
  Z9142000
;
array nvarlist _numeric_;


*---Recode missing values to SAS custom system missing. See SAS
      documentation for use of MISSING option in procedures, e.g. PROC FREQ;

do over nvarlist;
  if nvarlist = -1 then nvarlist = .R;  /* Refused */
  if nvarlist = -2 then nvarlist = .D;  /* Dont know */
  if nvarlist = -3 then nvarlist = .I;  /* Invalid missing */
  if nvarlist = -4 then nvarlist = .V;  /* Valid missing */
  if nvarlist = -5 then nvarlist = .N;  /* Non-interview */
end;

  label R0000100 = "PUBID - YTH ID CODE 1997";
  label R0536300 = "KEY!SEX (SYMBOL) 1997";
  label R0536402 = "KEY!BDATE M/Y (SYMBOL) 1997";
  label R1235800 = "CV_SAMPLE_TYPE 1997";
  label R1482600 = "KEY!RACE_ETHNICITY (SYMBOL) 1997";
  label U1845600 = "CV_HH_POV_RATIO 2017";
  label U1846000 = "CV_HIGHEST_DEGREE_EVER 2017";
  label U1852300 = "CV_MARSTAT 2017";
  label U1852500 = "CV_MSA 2017";
  label U1852600 = "CV_BIO_CHILD_HH 2017";
  label U1853200 = "CV_URBAN-RURAL 2017";
  label U2857200 = "TTL INC WAGES, SALARY PAST YR 2017";
  label U2857300 = "EST INC WAGES, TIPS PAST YR 2017";
  label U2857500 = "TTL INC BUS/FARM PAST YR 2017";
  label U2857600 = "EST INC BUS/FARM PAST YR 2017";
  label Z9083900 = "CVC_HIGHEST_DEGREE_EVER";
  label Z9122200 = "CVC_HOUSE_TYPE_30";
  label Z9122300 = "CVC_ASSETS_FINANCIAL_30";
  label Z9122500 = "CVC_ASSETS_DEBT_30";
  label Z9141700 = "CVC_HOUSE_TYPE_35";
  label Z9141800 = "CVC_ASSETS_FINANCIAL_35";
  label Z9142000 = "CVC_ASSETS_DEBT_35";

/*---------------------------------------------------------------------*
 *  Crosswalk for Reference number & Question name                     *
 *---------------------------------------------------------------------*
 * Uncomment and edit this RENAME statement to rename variables
 * for ease of use.  You may need to use  name literal strings
 * e.g.  'variable-name'n   to create valid SAS variable names, or 
 * alter variables similarly named across years.
 * This command does not guarantee uniqueness

 * See SAS documentation for use of name literals and use of the
 * VALIDVARNAME=ANY option.     
 *---------------------------------------------------------------------*/
  /* *start* */

* RENAME
  R0000100 = 'PUBID_1997'n
  R0536300 = 'KEY!SEX_1997'n
  R0536402 = 'KEY!BDATE_Y_1997'n
  R1235800 = 'CV_SAMPLE_TYPE_1997'n
  R1482600 = 'KEY!RACE_ETHNICITY_1997'n
  U1845600 = 'CV_HH_POV_RATIO_2017'n
  U1846000 = 'CV_HIGHEST_DEGREE_EVER_EDT_2017'n
  U1852300 = 'CV_MARSTAT_2017'n
  U1852500 = 'CV_MSA_2017'n
  U1852600 = 'CV_BIO_CHILD_HH_2017'n
  U1853200 = 'CV_URBAN-RURAL_2017'n
  U2857200 = 'YINC-1700_2017'n
  U2857300 = 'YINC-1800_2017'n
  U2857500 = 'YINC-2100_2017'n
  U2857600 = 'YINC-2200_2017'n
  Z9083900 = 'CVC_HIGHEST_DEGREE_EVER_XRND'n
  Z9122200 = 'CVC_HOUSE_TYPE_30_XRND'n
  Z9122300 = 'CVC_ASSETS_FINANCIAL_30_XRND'n
  Z9122500 = 'CVC_ASSETS_DEBTS_30_XRND'n
  Z9141700 = 'CVC_HOUSE_TYPE_35_XRND'n
  Z9141800 = 'CVC_ASSETS_FINANCIAL_35_XRND'n
  Z9142000 = 'CVC_ASSETS_DEBTS_35_XRND'n
;
  /* *finish* */

run;

proc means data=new_data n mean min max;
run;


/*---------------------------------------------------------------------*
 *  FORMATTED TABULATIONS                                              *
 *---------------------------------------------------------------------*
 * You can uncomment and edit the PROC FORMAT and PROC FREQ statements 
 * provided below to obtain formatted tabulations. The tabulations 
 * should reflect codebook values.
 * 
 * Please edit the formats below reflect any renaming of the variables
 * you may have done in the first data step. 
 *---------------------------------------------------------------------*/

/*
proc format; 
value vx0f
  0='0'
  1-999='1 TO 999'
  1000-1999='1000 TO 1999'
  2000-2999='2000 TO 2999'
  3000-3999='3000 TO 3999'
  4000-4999='4000 TO 4999'
  5000-5999='5000 TO 5999'
  6000-6999='6000 TO 6999'
  7000-7999='7000 TO 7999'
  8000-8999='8000 TO 8999'
  9000-9999='9000 TO 9999'
;
value vx1f
  0='No Information'
  1='Male'
  2='Female'
;
value vx3f
  0='Oversample'
  1='Cross-sectional'
;
value vx4f
  1='Black'
  2='Hispanic'
  3='Mixed Race (Non-Hispanic)'
  4='Non-Black / Non-Hispanic'
;
value vx5f
  0='0'
  1-99='1 TO 99: .01-.99'
  100-199='100 TO 199: 1.00-1.99'
  200-299='200 TO 299: 2.00-2.99'
  300-399='300 TO 399: 3.00-3.99'
  400-499='400 TO 499: 4.00-4.99'
  500-599='500 TO 599: 5.00-5.99'
  600-699='600 TO 699: 6.00-6.99'
  700-799='700 TO 799: 7.00-7.99'
  800-899='800 TO 899: 8.00-8.99'
  900-999='900 TO 999: 9.00-9.99'
  1000-1099='1000 TO 1099: 10.00-10.99'
  1100-1199='1100 TO 1199: 11.00-11.99'
  1200-1299='1200 TO 1299: 12.00-12.99'
  1300-1399='1300 TO 1399: 13.00-13.99'
  1400-1499='1400 TO 1499: 14.00-14.99'
  1500-1599='1500 TO 1599: 15.00-15.99'
  1600-1699='1600 TO 1699: 16.00-16.99'
  1700-1799='1700 TO 1799: 17.00-17.99'
  1800-1899='1800 TO 1899: 18.00-18.99'
  1900-1999='1900 TO 1999: 19.00-19.99'
  2000-2999='2000 TO 2999: 20.00-29.99'
  3000-9999='3000 TO 9999: 30.00+'
;
value vx6f
  0='None'
  1='GED'
  2='High school diploma (Regular 12 year program)'
  3='Associate/Junior college (AA)'
  4='Bachelor''s degree (BA, BS)'
  5='Master''s degree (MA, MS)'
  6='PhD'
  7='Professional degree (DDS, JD, MD)'
;
value vx7f
  1='Never married, cohabiting'
  2='Never married, not cohabiting'
  3='Married, spouse present'
  4='Married, spouse absent'
  5='Separated, cohabiting'
  6='Separated, not cohabiting'
  7='Divorced, cohabiting'
  8='Divorced, not cohabiting'
  9='Widowed, cohabiting'
  10='Widowed, not cohabiting'
;
value vx8f
  1='Not in CBSA'
  2='In CBSA, not in central city'
  3='In CBSA, in central city'
  4='In CBSA, not known'
  5='Not in country'
;
value vx9f
  0='0'
  1='1'
  2='2'
  3='3'
  4='4'
  5='5'
  6='6'
  7='7'
  8='8'
  9='9'
  10-999='10 TO 999: 10+'
;
value vx10f
  0='Rural'
  1='Urban'
  2='Unknown'
;
value vx11f
  0='0'
  1-999='1 TO 999'
  1000-1999='1000 TO 1999'
  2000-2999='2000 TO 2999'
  3000-3999='3000 TO 3999'
  4000-4999='4000 TO 4999'
  5000-5999='5000 TO 5999'
  6000-6999='6000 TO 6999'
  7000-7999='7000 TO 7999'
  8000-8999='8000 TO 8999'
  9000-9999='9000 TO 9999'
  10000-14999='10000 TO 14999'
  15000-19999='15000 TO 19999'
  20000-24999='20000 TO 24999'
  25000-49999='25000 TO 49999'
  50000-99999999='50000 TO 99999999: 50000+'
;
value vx12f
  1='A. $1 - $5,000'
  2='B. $5,001 - $10,000'
  3='C. $10,001 - $25,000'
  4='D. $25,001 - $50,000'
  5='E. $50,001 - $100,000'
  6='F. $100,001 - $250,000'
  7='G. More than $250,000'
;
value vx13f
  -999999--3000='-999999 TO -3000: < -2999'
  -2999--2000='-2999 TO -2000'
  -1999--1000='-1999 TO -1000'
  -999--1='-999 TO -1'
  0='0'
  1-1000='1 TO 1000'
  1001-2000='1001 TO 2000'
  2001-3000='2001 TO 3000'
  3001-5000='3001 TO 5000'
  5001-10000='5001 TO 10000'
  10001-20000='10001 TO 20000'
  20001-30000='20001 TO 30000'
  30001-40000='30001 TO 40000'
  40001-50000='40001 TO 50000'
  50001-65000='50001 TO 65000'
  65001-80000='65001 TO 80000'
  80001-100000='80001 TO 100000'
  100001-150000='100001 TO 150000'
  150001-200000='150001 TO 200000'
  200001-99999999='200001 TO 99999999: 200001+'
;
value vx14f
  1='A.   LOST/WOULD LOSE MONEY'
  2='B.   $1              -        $5,000'
  3='C.   $5,001       -        $10,000'
  4='D.   $10,001     -        $25,000'
  5='E.    $25,001     -        $50,000'
  6='F.    $50,001     -        $100,000'
  7='G.    $100,001   -        $250,000'
  8='H.    More than  $250,000'
;
value vx15f
  0='None'
  1='GED'
  2='High school diploma (Regular 12 year program)'
  3='Associate/Junior college (AA)'
  4='Bachelor''s degree (BA, BS)'
  5='Master''s degree (MA, MS)'
  6='PhD'
  7='Professional degree (DDS, JD, MD)'
;
value vx16f
  1='House'
  2='Ranch/Farm'
  3='Mobile Home'
  6='R does not own'
  9='Owns other residence type'
;
value vx17f
  -9999999--3000='-9999999 TO -3000: < -2999'
  -2999--2000='-2999 TO -2000'
  -1999--1000='-1999 TO -1000'
  -999--1='-999 TO -1'
  0='0'
  1-1000='1 TO 1000'
  1001-2000='1001 TO 2000'
  2001-3000='2001 TO 3000'
  3001-5000='3001 TO 5000'
  5001-10000='5001 TO 10000'
  10001-20000='10001 TO 20000'
  20001-30000='20001 TO 30000'
  30001-40000='30001 TO 40000'
  40001-50000='40001 TO 50000'
  50001-65000='50001 TO 65000'
  65001-80000='65001 TO 80000'
  80001-100000='80001 TO 100000'
  100001-150000='100001 TO 150000'
  150001-200000='150001 TO 200000'
  200001-999999999='200001 TO 999999999: 200001+'
;
value vx18f
  -9999999--3000='-9999999 TO -3000: < -2999'
  -2999--2000='-2999 TO -2000'
  -1999--1000='-1999 TO -1000'
  -999--1='-999 TO -1'
  0='0'
  1-1000='1 TO 1000'
  1001-2000='1001 TO 2000'
  2001-3000='2001 TO 3000'
  3001-5000='3001 TO 5000'
  5001-10000='5001 TO 10000'
  10001-20000='10001 TO 20000'
  20001-30000='20001 TO 30000'
  30001-40000='30001 TO 40000'
  40001-50000='40001 TO 50000'
  50001-65000='50001 TO 65000'
  65001-80000='65001 TO 80000'
  80001-100000='80001 TO 100000'
  100001-150000='100001 TO 150000'
  150001-200000='150001 TO 200000'
  200001-999999999='200001 TO 999999999: 200001+'
;
value vx19f
  1='House'
  2='Ranch/Farm'
  3='Mobile Home'
  6='R does not own'
  9='Owns other residence type'
;
value vx20f
  -9999999--3000='-9999999 TO -3000: < -2999'
  -2999--2000='-2999 TO -2000'
  -1999--1000='-1999 TO -1000'
  -999--1='-999 TO -1'
  0='0'
  1-1000='1 TO 1000'
  1001-2000='1001 TO 2000'
  2001-3000='2001 TO 3000'
  3001-5000='3001 TO 5000'
  5001-10000='5001 TO 10000'
  10001-20000='10001 TO 20000'
  20001-30000='20001 TO 30000'
  30001-40000='30001 TO 40000'
  40001-50000='40001 TO 50000'
  50001-65000='50001 TO 65000'
  65001-80000='65001 TO 80000'
  80001-100000='80001 TO 100000'
  100001-150000='100001 TO 150000'
  150001-200000='150001 TO 200000'
  200001-999999999='200001 TO 999999999: 200001+'
;
value vx21f
  -9999999--3000='-9999999 TO -3000: < -2999'
  -2999--2000='-2999 TO -2000'
  -1999--1000='-1999 TO -1000'
  -999--1='-999 TO -1'
  0='0'
  1-1000='1 TO 1000'
  1001-2000='1001 TO 2000'
  2001-3000='2001 TO 3000'
  3001-5000='3001 TO 5000'
  5001-10000='5001 TO 10000'
  10001-20000='10001 TO 20000'
  20001-30000='20001 TO 30000'
  30001-40000='30001 TO 40000'
  40001-50000='40001 TO 50000'
  50001-65000='50001 TO 65000'
  65001-80000='65001 TO 80000'
  80001-100000='80001 TO 100000'
  100001-150000='100001 TO 150000'
  150001-200000='150001 TO 200000'
  200001-999999999='200001 TO 999999999: 200001+'
;
*/

/* 
 *--- Tabulations using reference number variables;
proc freq data=new_data;
tables _ALL_ /MISSING;
  format R0000100 vx0f.;
  format R0536300 vx1f.;
  format R1235800 vx3f.;
  format R1482600 vx4f.;
  format U1845600 vx5f.;
  format U1846000 vx6f.;
  format U1852300 vx7f.;
  format U1852500 vx8f.;
  format U1852600 vx9f.;
  format U1853200 vx10f.;
  format U2857200 vx11f.;
  format U2857300 vx12f.;
  format U2857500 vx13f.;
  format U2857600 vx14f.;
  format Z9083900 vx15f.;
  format Z9122200 vx16f.;
  format Z9122300 vx17f.;
  format Z9122500 vx18f.;
  format Z9141700 vx19f.;
  format Z9141800 vx20f.;
  format Z9142000 vx21f.;
run;
*/

/*
*--- Tabulations using default named variables;
proc freq data=new_data;
tables _ALL_ /MISSING;
  format 'PUBID_1997'n vx0f.;
  format 'KEY!SEX_1997'n vx1f.;
  format 'CV_SAMPLE_TYPE_1997'n vx3f.;
  format 'KEY!RACE_ETHNICITY_1997'n vx4f.;
  format 'CV_HH_POV_RATIO_2017'n vx5f.;
  format 'CV_HIGHEST_DEGREE_EVER_EDT_2017'n vx6f.;
  format 'CV_MARSTAT_2017'n vx7f.;
  format 'CV_MSA_2017'n vx8f.;
  format 'CV_BIO_CHILD_HH_2017'n vx9f.;
  format 'CV_URBAN-RURAL_2017'n vx10f.;
  format 'YINC-1700_2017'n vx11f.;
  format 'YINC-1800_2017'n vx12f.;
  format 'YINC-2100_2017'n vx13f.;
  format 'YINC-2200_2017'n vx14f.;
  format 'CVC_HIGHEST_DEGREE_EVER_XRND'n vx15f.;
  format 'CVC_HOUSE_TYPE_30_XRND'n vx16f.;
  format 'CVC_ASSETS_FINANCIAL_30_XRND'n vx17f.;
  format 'CVC_ASSETS_DEBTS_30_XRND'n vx18f.;
  format 'CVC_HOUSE_TYPE_35_XRND'n vx19f.;
  format 'CVC_ASSETS_FINANCIAL_35_XRND'n vx20f.;
  format 'CVC_ASSETS_DEBTS_35_XRND'n vx21f.;
run;
*/