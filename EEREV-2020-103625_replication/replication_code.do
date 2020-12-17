*Replication code for EEREV-D-20-00462R2
*Online Platform Price Parity Clauses: Evidence from the EU Booking.com case
***********************************************************************************************
******DIRECTORY DEFINITION 
***************
***IMPORTANT***
***************
*change the directory path to match the where the main folder "EEREV-D-20-00462R2_replication" is saved 
global input "C:\Users\msasscr7\Google Drive\OFT_FINAL\Much_ado_new\EEREV-D-20-00462R2_replication_material"
*then run
cd "$input"
set more off
*************************************************************************************************

*************************************************************************************************
**********FILE STRUCTURE - SEARCHABLE**************
****Weekly price of a double room******************
****Hotel availability by town*********************
****Monthly airport arrivals by region*************
**Google trends for hotels in Corsica and Sardinia*
****MACRON LAW: SHORT-RUN EVIDENCE*****************
****MACRON LAW: POTENTIAL ANTICIPATION*************
****MACRON LAW: SYNTHETIC CONTROL******************
****MACRON LAW: MEDIUM-RUN*************************
****MACRON LAW: MEDIUM-RUN PLACBO******************
****ITALY LIBERALIZATION LAW***********************
***************************************************
**************************************************************************************************

******************
**FIGURE 2a*******
******************
*Weekly price of a double room*
preserve

use data_prices_2015, clear

graph drop _all
twoway (line meanP week if region==1, sort lcolor(black) lpattern(solid) lwidth(medthick)) ///
(line meanP week if region==2, sort lcolor(black) lpattern(dash) lwidth(medthick)), ///
legend(order(1 "Corsica" 2 "Sardinia") row(1)) ///
ytitle("2015 Mean weekly price") ///
xtitle("Weeks") name(hotel_prices_2015) ///
xline(28, lcolor(black) lpattern(dash) lwidth(medthick)) ///
xline(32, lcolor(black) lwidth(medthick)) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)

restore
****************************

*****************
**FIGURE 2b******
*****************
*Monthly airport arrivals by region*
************************************
preserve

use data_airports, clear

graph drop _all

twoway (line Corsica Month, yaxis(1) lcolor(black) lpattern(solid) lwidth(medthick)) ///
(line Sardinia Month, yaxis(1) lcolor(black) lpattern(dash) lwidth(medthick)), ///
legend(order(1 "Corsica" 2 "Sardinia") row(1)) ///
ytitle("Monthly airport arrivals") ///
xtitle("Months") ///
name(airport_arrivals) tline(10jul2015, lcolor(black) lpattern(dash) lwidth(medthick)) tline(06aug2015, lcolor(black) lwidth(medthick)) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white) 

restore
*****************
**FIGURE 3a******
*****************
*Google trends for hotels in Corsica and Sardinia*
preserve

use data_google_trends, clear

graph drop _all

local y 2017

twoway (line src_cor_hot time if year<`y', sort lcolor(black) lpattern(solid) lwidth(medthick)) ///
(line src_sar_hot time if year<`y', sort lcolor(black) lpattern(dash) lwidth(medthick)) ///
(lfit src_cor_hot time if year<`y', lcolor(black) lpattern(longdash) lwidth(medthick)) ///
(lfit src_sar_hot time if year<`y', lcolor(black) lpattern(shortdash) lwidth(medthick)), ///
legend(order(1 "Search for Corsica" 2 "Search for Sardinia" 3 "Trend Corsica" 4 "Trend Sardinia") row(2) ) ///
ytitle("Google Trends") tline(10jul2015, lcolor(black) lpattern(dash) lwidth(medthick)) tline(06aug2015, lcolor(black) lwidth(medthick)) ///
xtitle("Time") name(google_trends_cor_sar) ///
graphregion(color(white)) bgcolor(white)

restore
***************************
****************
**FIGURE 3b*****
****************
*Hotel availability by town*
preserve

use data_town_avail, clear

graph drop _all

twoway (line town_avail bweek if region==1, yaxis(1) lcolor(black) lpattern(dash) lwidth(medthick)) ///
(line town_avail bweek if region==2, yaxis(1) lcolor(black) lpattern(solid) lwidth(medthick)) ///
(lfit town_avail bweek if region==1, yaxis(1) lcolor(black) lpattern(shortdash) lwidth(medthick)) ////
(lfit town_avail bweek if region==2, yaxis(1) lcolor(black) lpattern(longdash_dot) lwidth(medthick)), ////
legend(order(1 "Corsica" 2 "Sardinia" 3 "Trend Corsica" 4 "Trend Sardinia") row(2)) ///
ytitle("Hotel availability") ///
xtitle("Weeks") name(hotel_avail_cor_sar)  tline(28, lcolor(black) lpattern(dash) lwidth(medthick)) tline(32, lcolor(black) lwidth(medthick)) ///
xlabel(10(5)44) /// 
graphregion(color(white)) plotregion(color(white)) bgcolor(white)

restore
****************************

******************************************
*********MACRON LAW: SHORT-RUN EVIDENCE***
******************************************
use data_mac_sr,clear

***************************
************TABLE 3********
************TABLE C.1******
***************************
preserve
keep if sample_mac_sr==1

*D-in-D
areg lprice100 i.Post##i.Treated c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Chains
areg lprice100 i.Post##i.Treated##i.dchain c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Test for Table C.1
test (_b[1.Post#1.Treated#0.dchain] = _b[1.Post#1.Treated#1.dchain])

*Heterogeneous effects: Stars
areg lprice100 i.Post##i.Treated##i.stars c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Tests for Table C.1
test (_b[1.Post#1.Treated#1.stars] = _b[1.Post#1.Treated#2.stars])
test (_b[1.Post#1.Treated#1.stars] = _b[1.Post#1.Treated#3.stars])
test (_b[1.Post#1.Treated#1.stars] = _b[1.Post#1.Treated#4.stars])
test (_b[1.Post#1.Treated#1.stars] = _b[1.Post#1.Treated#5.stars])

test (_b[1.Post#1.Treated#2.stars] = _b[1.Post#1.Treated#3.stars])
test (_b[1.Post#1.Treated#2.stars] = _b[1.Post#1.Treated#4.stars])
test (_b[1.Post#1.Treated#2.stars] = _b[1.Post#1.Treated#5.stars])

test (_b[1.Post#1.Treated#3.stars] = _b[1.Post#1.Treated#4.stars])
test (_b[1.Post#1.Treated#3.stars] = _b[1.Post#1.Treated#5.stars])

test (_b[1.Post#1.Treated#4.stars] = _b[1.Post#1.Treated#5.stars])

*Heterogeneous effects: Size
areg lprice100 i.Post##i.Treated##i.hot_size c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Tests for Table C.1
test (_b[1.Post#1.Treated#0.hot_size] = _b[1.Post#1.Treated#1.hot_size])
test (_b[1.Post#1.Treated#0.hot_size] = _b[1.Post#1.Treated#2.hot_size])

test (_b[1.Post#1.Treated#1.hot_size] = _b[1.Post#1.Treated#2.hot_size])
restore
*****************************
**FIGURE 4*******************
*****************************
capture graph drop _all
preserve
keep if sample_mac_sr==1

areg lprice100 i.Treated##i.date_src c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

margins, dydx(Treated) over(r.Post) noestimcheck 

margins, at(Treated) over(bweek Treated) 

marginsplot, plot1opts(lpattern(dash) lcolor(black) mcolor(black) ) plot2opts(lpattern(full) lcolor(black) mcolor(black)) ///
ci1opts(lcolor(black)) ci2opts(lcolor(black)) /// 
xdimension(bweek) ytitle("Log price x 100") ///
xtitle("Week of price posting") name(event_mac_margins) ///
xline(32, lcolor(black) lwidth(medthick)) ///
xline(28, lcolor(black) lwidth(medthick) lpattern(dash)) ///
legend(lab(1 "Sardinia") lab(2 "Corsica")) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)

restore
******************
**FIGURE A.1******
******************
preserve
keep if sample_mac_sr==1
areg lprice100 i.Treated##i.date_src##i.stars c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)
margins, dydx(Treated) over(r.Post r.stars) noestimcheck

margins, at(stars==2) over(bweek Treated stars) 

marginsplot, plot1opts(lpattern(dash) lcolor(black) mcolor(black) ) plot2opts(lpattern(full) lcolor(black) mcolor(black)) ///
ci1opts(lcolor(black)) ci2opts(lcolor(black)) /// 
xdimension(bweek) ytitle("Log price x 100") ///
xtitle("Week of price posting") name(event_mac_2stars_margins) ///
xline(32, lcolor(black) lwidth(medthick)) ///
xline(28, lcolor(black) lwidth(medthick) lpattern(dash)) ///
legend(lab(1 "Sardinia 2 Stars") lab(2 "Corsica 2 Stars")) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)

margins, at(stars==3) over(bweek Treated stars) 

marginsplot, plot1opts(lpattern(dash) lcolor(black) mcolor(black) ) plot2opts(lpattern(full) lcolor(black) mcolor(black)) ///
ci1opts(lcolor(black)) ci2opts(lcolor(black)) /// 
xdimension(bweek) ytitle("Log price x 100") ///
xtitle("Week of price posting") name(event_mac_3stars_margins) ///
xline(32, lcolor(black) lwidth(medthick)) ///
xline(28, lcolor(black) lwidth(medthick) lpattern(dash)) ///
legend(lab(1 "Sardinia 3 Stars") lab(2 "Corsica 3 Stars")) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)


******************
**FIGURE A.2******
******************

margins, at(stars==4) over(bweek Treated stars) 

marginsplot, plot1opts(lpattern(dash) lcolor(black) mcolor(black) ) plot2opts(lpattern(full) lcolor(black) mcolor(black)) ///
ci1opts(lcolor(black)) ci2opts(lcolor(black)) /// 
xdimension(bweek) ytitle("Log price x 100") ///
xtitle("Week of price posting") name(event_mac_4stars_margins) ///
xline(32, lcolor(black) lwidth(medthick)) ///
xline(28, lcolor(black) lwidth(medthick) lpattern(dash)) ///
legend(lab(1 "Sardinia 4 Stars") lab(2 "Corsica 4 Stars")) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)

margins, at(stars==5) over(bweek Treated stars) 

marginsplot, plot1opts(lpattern(dash) lcolor(black) mcolor(black) ) plot2opts(lpattern(full) lcolor(black) mcolor(black)) ///
ci1opts(lcolor(black)) ci2opts(lcolor(black)) /// 
xdimension(bweek) ytitle("Log price x 100") ///
xtitle("Week of price posting") name(event_mac_5stars_margins) ///
xline(32, lcolor(black) lwidth(medthick)) ///
xline(28, lcolor(black) lwidth(medthick) lpattern(dash)) ///
legend(lab(1 "Sardinia 5 Stars") lab(2 "Corsica 5 Stars")) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)
restore

******************
**FIGURE A.3******
******************
preserve
keep if sample_mac_sr==1
areg lprice100 i.Treated##i.date_src##i.hot_size c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)
margins, dydx(Treated) over(r.Post r.hot_size) noestimcheck

margins, at(hot_size==0) over(bweek Treated hot_size) 

marginsplot, plot1opts(lpattern(dash) lcolor(black) mcolor(black) ) plot2opts(lpattern(full) lcolor(black) mcolor(black)) ///
ci1opts(lcolor(black)) ci2opts(lcolor(black)) /// 
xdimension(bweek) ytitle("Log price x 100") ///
xtitle("Week of price posting") name(event_mac_small_margins) ///
xline(32, lcolor(black) lwidth(medthick)) ///
xline(28, lcolor(black) lwidth(medthick) lpattern(dash)) ///
legend(lab(1 "Sardinia Small") lab(2 "Corsica Small")) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)


margins, at(hot_size==1) over(bweek Treated hot_size) 

marginsplot, plot1opts(lpattern(dash) lcolor(black) mcolor(black) ) plot2opts(lpattern(full) lcolor(black) mcolor(black)) ///
ci1opts(lcolor(black)) ci2opts(lcolor(black)) /// 
xdimension(bweek) ytitle("Log price x 100") ///
xtitle("Week of price posting") name(event_mac_medium_margins) ///
xline(32, lcolor(black) lwidth(medthick)) ///
xline(28, lcolor(black) lwidth(medthick) lpattern(dash)) ///
legend(lab(1 "Sardinia Medium") lab(2 "Corsica Medium")) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)


******************
**FIGURE A.4******
******************

margins, at(hot_size==2) over(bweek Treated hot_size) 

marginsplot, plot1opts(lpattern(dash) lcolor(black) mcolor(black) ) plot2opts(lpattern(full) lcolor(black) mcolor(black)) ///
ci1opts(lcolor(black)) ci2opts(lcolor(black)) /// 
xdimension(bweek) ytitle("Log price x 100") ///
xtitle("Week of price posting") name(event_mac_large_margins) ///
xline(32, lcolor(black) lwidth(medthick)) ///
xline(28, lcolor(black) lwidth(medthick) lpattern(dash)) ///
legend(lab(1 "Sardinia Large") lab(2 "Corsica Large")) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)
restore
preserve
areg lprice100 i.Treated##i.date_src##i.dchain c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)
margins, dydx(Treated) over(r.Post r.dchain) noestimcheck

margins, at(dchain==1) over(bweek Treated dchain) 

marginsplot, plot1opts(lpattern(dash) lcolor(black) mcolor(black) ) plot2opts(lpattern(full) lcolor(black) mcolor(black)) ///
ci1opts(lcolor(black)) ci2opts(lcolor(black)) /// 
xdimension(bweek) ytitle("Log price x 100") ///
xtitle("Week of price posting") name(event_mac_chain_margins) ///
xline(32, lcolor(black) lwidth(medthick)) ///
xline(28, lcolor(black) lwidth(medthick) lpattern(dash)) ///
legend(lab(1 "Sardinia Chains") lab(2 "Corsica Chains")) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)

restore
******************
**TABLE B.1*******
******************
preserve

gen dist_event=date_src-d(6aug2015)
sum dist_event, det

restore
******************
**TABLE E.1*******
******************
preserve
*D-in-D
areg lprice100 i.Post##i.Treated c.bdays##i.region google_src, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Chains
areg lprice100 i.Post##i.Treated##i.dchain c.bdays##i.region google_src, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Stars
areg lprice100 i.Post##i.Treated##i.stars c.bdays##i.region google_src, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Size
areg lprice100 i.Post##i.Treated##i.hot_size c.bdays##i.region google_src, absorb(panelid1415) vce(cluster urlnum)
restore
***********************
******************
**TABLE 2***********
******************
*Hotel characterics*
preserve
replace stars=. if stars==0
capture drop counter
bysort urlnum: gen counter=_n

label variable rating "Users' rating"
label variable Nreviewers "Number of reviewers"
label variable stars "Star rating"
label variable capacity "Number of rooms"
label variable dchain "Chain affiliation"
label variable date_start_booking "On Booking.com since"

estpost sum capacity stars dchain rating Nreviewers date_start_booking if counter==1&region==1    

estpost sum capacity stars dchain rating Nreviewers date_start_booking if counter==1&region==2    

***********************
restore

******************
**TABLE E.2*******
******************
***Specification with lags 
preserve

keep if sample_mac_sr_lag==1

tsset panelid1415 date_src 

*D-in-D
areg lprice100 laglprice100 i.Post##i.Treated c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Chains
areg lprice100 laglprice100 i.Post##i.Treated##i.dchain c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Stars
areg lprice100 laglprice100 i.Post##i.Treated##i.stars c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Size
areg lprice100 laglprice100 i.Post##i.Treated##i.hot_size c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

restore
*************************************************************************************************

******************************************
****MACRON LAW: POTENTIAL ANTICIPATION****
******************************************

******************
**TABLE D.1*******
******************
use data_mac_antic, clear

*D-in-D
areg lprice100 i.Post##i.Treated c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Chains
areg lprice100 i.Post##i.Treated##i.dchain c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Stars
areg lprice100 i.Post##i.Treated##i.stars c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Size
areg lprice100 i.Post##i.Treated##i.hot_size c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

******************
**TABLE 4*********
******************
use data_mac_antic_all, clear

*Heterogeneous effects: Chains
areg lprice100 i.Post##i.Treated##i.dchain c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Stars
areg lprice100 i.Post##i.Treated##i.stars c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

*Heterogeneous effects: Size
areg lprice100 i.Post##i.Treated##i.hot_size c.bdays##i.region google_src town_avail, absorb(panelid1415) vce(cluster urlnum)

******************************************
****MACRON LAW: SYNTHETIC CONTROL*********
******************************************

******************
**FIGURE 5a*******
******************
*All hotels
use data_mac_synth, clear

capture graph drop _all

preserve

keep if synth_mac==1

tsset classification week_src

synth lprice100 lprice100 bdays stars hot_size capacity punteggio date_start_booking ///
google_src ,trunit(1) trperiod(32) nested fig
restore

******************
**FIGURE 5b*******
******************
*Chains only
preserve
keep if synth_chain==1

tsset classification week_src

synth lprice100 lprice100 bdays stars hot_size capacity punteggio date_start_booking ///
google_src ,trunit(1) trperiod(32) nested fig  

restore
*************************************************************************************************

******************************************
****MACRON LAW: MEDIUM-RUN****************
******************************************
use data_mac_mr, clear

******************
**TABLE 6*********
******************
*D-in-D
areg lprice100 i.Post##i.Treated c.bdays##i.region google_src town_avail, absorb(room_id_dow) vce(cluster urlnum)

*Heterogeneous effects: Chains
areg lprice100 i.Post##i.Treated##i.dchain c.bdays##i.region google_src town_avail, absorb(room_id_dow) vce(cluster urlnum)

test (_b[1.Post#1.Treated#0.dchain] = _b[1.Post#1.Treated#1.dchain])

*Heterogeneous effects: Stars
areg lprice100 i.Post##i.Treated##i.stars c.bdays##i.region google_src town_avail, absorb(room_id_dow) vce(cluster urlnum)

test (_b[1.Post#1.Treated#1.stars] = _b[1.Post#1.Treated#2.stars])
test (_b[1.Post#1.Treated#1.stars] = _b[1.Post#1.Treated#3.stars])
test (_b[1.Post#1.Treated#1.stars] = _b[1.Post#1.Treated#4.stars])
test (_b[1.Post#1.Treated#1.stars] = _b[1.Post#1.Treated#5.stars])

test (_b[1.Post#1.Treated#2.stars] = _b[1.Post#1.Treated#3.stars])
test (_b[1.Post#1.Treated#2.stars] = _b[1.Post#1.Treated#4.stars])
test (_b[1.Post#1.Treated#2.stars] = _b[1.Post#1.Treated#5.stars])

test (_b[1.Post#1.Treated#3.stars] = _b[1.Post#1.Treated#4.stars])
test (_b[1.Post#1.Treated#3.stars] = _b[1.Post#1.Treated#5.stars])

test (_b[1.Post#1.Treated#4.stars] = _b[1.Post#1.Treated#5.stars])

*Heterogeneous effects: Size
areg lprice100 i.Post##i.Treated##i.hot_size c.bdays##i.region google_src town_avail, absorb(room_id_dow) vce(cluster urlnum)

test (_b[1.Post#1.Treated#0.hot_size] = _b[1.Post#1.Treated#1.hot_size])
test (_b[1.Post#1.Treated#0.hot_size] = _b[1.Post#1.Treated#2.hot_size])

test (_b[1.Post#1.Treated#1.hot_size] = _b[1.Post#1.Treated#2.hot_size])
 
******************
**FIGURE G.1******
******************
preserve

areg lprice100 i.bdays##i.Treated c.bdays##i.region google_src town_avail, absorb(room_id_dow) vce(cluster urlnum)

predict lnp_hat, xb
predict se_lnp_hat, stdp

collapse (mean) lprice100 region room_id_dow google_src town_avail lnp_hat se_lnp_hat bweek year, by (Treated event_week)

gen ci_low = lnp_hat - 1.96*se_lnp_hat
gen ci_high = lnp_hat + 1.96*se_lnp_hat

capture graph drop _all  

twoway (sc lnp_hat event_week if region == 1, mcolor(black) lcolor(black) connect(direct)) ///
        (rcap ci_low ci_high event_week if region == 1, lcolor(black) ) ///
    (sc lnp_hat event_week if region == 2, mcolor(black) lcolor(black) lpattern(dash) connect(direct)) ///
        (rcap ci_low ci_high event_week if region == 2, lcolor(black) ), ///	
  ytitle("Log price x 100") ///
xtitle("Week of price posting relative to the event (with one year gap)") name(event_mr_all) ///
xline(0, lcolor(black) lwidth(medthick)) ///
legend( rows(1) order( 1 "Corsica"  3 "Sardinia"  ) ) ///
graphregion(color(white)) plotregion(color(white)) bgcolor(white)

restore 
 
******************************************
****MACRON LAW: MEDIUM-RUN PLACBO*********
******************************************
**All observations before the Macron Law**
******************
**TABLE 7*********
******************
use data_mr_placebo, clear

*D-in-D
areg lprice100 i.year##i.Treated c.bdays##i.region google_src, absorb(room_id_dow) vce(cluster urlnum)

*Heterogeneous effects: Chain
areg lprice100 i.year##i.Treated##i.dchain c.bdays##i.region google_src, absorb(room_id_dow) vce(cluster urlnum)

*Heterogeneous effects: Stars
areg lprice100 i.year##i.Treated##i.stars c.bdays##i.region google_src, absorb(room_id_dow) vce(cluster urlnum)

*Heterogeneous effects: Size
areg lprice100 i.year##i.Treated##i.hot_size c.bdays##i.region google_src, absorb(room_id_dow) vce(cluster urlnum)
 

******************************************
****ITALY LIBERALIZATION LAW**************
******************************************
use data_sr_ita, clear

******************
**TABLE F.1*******
******************

*D-in-D
areg lprice100 i.Post##i.Treated c.bdays##i.region google_src town_avail, absorb(panelid2017) vce(cluster urlnum)

*Heterogeneous effects: Chain
areg lprice100 i.Post##i.Treated##i.dchain c.bdays##i.region google_src town_avail, absorb(panelid2017) vce(cluster urlnum)

*Heterogeneous effects: Stars
areg lprice100 i.Post##i.Treated##i.stars c.bdays##i.region google_src town_avail, absorb(panelid2017) vce(cluster urlnum)

*Heterogeneous effects: Size
areg lprice100 i.Post##i.Treated##i.hot_size c.bdays##i.region google_src town_avail, absorb(panelid2017) vce(cluster urlnum)

*************************************************************************************************




