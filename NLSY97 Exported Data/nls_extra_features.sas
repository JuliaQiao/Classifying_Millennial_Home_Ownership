options nocenter validvarname=any;

*---Read in space-delimited ascii file;

data new_data;


infile 'nls_extra_features.dat' lrecl=24 missover DSD DLM=' ' print;
input
  R0000100
  R0617900
  R1204900
  Z0397600
  Z0397700
  Z9085300
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
  label R0617900 = "PR OWN, RENT HOUSE/APT? 1997";
  label R1204900 = "CV_HH_POV_RATIO 1997";
  label Z0397600 = "R OWN, RENT HOUSE/APT?";
  label Z0397700 = "WHAT HOUSE/APT OWNER SITUATION?";
  label Z9085300 = "CV_TTL_RESIDENCES";

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
  R0617900 = 'P5-101_1997'n
  R1204900 = 'CV_HH_POV_RATIO_1997'n
  Z0397600 = 'YAST25-3310_COMB_XRND'n
  Z0397700 = 'YAST25-3320_COMB_XRND'n
  Z9085300 = 'CVC_TTL_RESIDENCES_XRND'n
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
  1='OWNS OR IS BUYING; LAND CONTRACT'
  2='PAYS RENT'
  3='NEITHER OWNS NOR RENTS'
;
value vx2f
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
value vx3f
  1='RESPONDENT OWNS'
  2='RESPONDENT AND SPOUSE/PARTNER JOINTLY OWN'
  3='SPOUSE/PARTNER OWNS SEPARATELY FROM RESPONDENT'
  4='RENTS'
  5='OTHER, NEITHER OWNS NOR RENTS'
;
value vx4f
  1='LIVE WITH PARENT(s)'
  2='LIVE WITH SPOUSE''S/PARTNER''S PARENT(s)'
  3='HOUSING IS PART OF JOB COMPENSATION; LIVE-IN SERVANT; HOUSEKEEPER; GARDENER; FARM LABORER'
  4='HOUSING IS A GIFT PAID FOR BY AN HU RESIDENT OTHER THAN R OR SPOUSE/PARTNER'
  5='HOUSING IS A GIFT PAID FOR BY A FRIEND OR RELATIVE OUTSIDE OF THE HU'
  6='HOUSING PAID FOR BY A GOVERNMENT AGENCY/WELFARE/CHARITABLE INSTITUTION'
  7='SOLD HOME, NOT MOVED OUT OF IT YET'
  8='LIVING IN HOUSE WHICH R WILL INHERIT; ESTATE IN PROGRESS'
  9='LIVING IN TEMPORARY QUARTERS (GARAGE, SHED) WHILE HOME IS UNDER CONSTRUCTION'
  10='LIVE HERE WITHOUT FORMAL ARRANGEMENTS; STAYING TEMPORARILY; SQUATTING'
  97='OTHER'
;
value vx5f
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
*/

/* 
 *--- Tabulations using reference number variables;
proc freq data=new_data;
tables _ALL_ /MISSING;
  format R0000100 vx0f.;
  format R0617900 vx1f.;
  format R1204900 vx2f.;
  format Z0397600 vx3f.;
  format Z0397700 vx4f.;
  format Z9085300 vx5f.;
run;
*/

/*
*--- Tabulations using default named variables;
proc freq data=new_data;
tables _ALL_ /MISSING;
  format 'PUBID_1997'n vx0f.;
  format 'P5-101_1997'n vx1f.;
  format 'CV_HH_POV_RATIO_1997'n vx2f.;
  format 'YAST25-3310_COMB_XRND'n vx3f.;
  format 'YAST25-3320_COMB_XRND'n vx4f.;
  format 'CVC_TTL_RESIDENCES_XRND'n vx5f.;
run;
*/