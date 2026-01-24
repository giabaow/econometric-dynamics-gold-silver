Sys.setlocale("LC_TIME", "English")

library(quantmod)
#gold vs silver price

start_date <- as.Date("2007-01-02")
end_date <- as.Date("2025-12-05")

# Download Gold Prices (Futures)
getSymbols("GC=F", src = "yahoo",from=start_date, to = end_date)
Gold <- `GC=F`

# Download Silver Prices (Futures)
getSymbols("SI=F", src = "yahoo", from = start_date, to = end_date)
Silver <- `SI=F`

# Look at the first rows
head(Gold)
head(Silver)

plot(Cl(Gold), main = "Gold Prices", col = "gold")
plot(Cl(Silver), main = "Silver Prices", col = "grey")

#will only look at the day's closing price
gold <- Gold$`GC=F.Close`
silver <- Silver$`SI=F.Close`

#check for missing values
summary(gold)#8 missing values for Gold

gold_na <- gold[is.na(gold)]
gold_na_date <- index(gold_na)
gold[gold_na_date]

#use linear interpolation to replace missing values
gold <- na.approx(gold)
summary(gold)
gold[gold_na_date]
plot(gold)


# do the same thing to silver
silver <- na.approx(silver)
summary(silver)
plot(silver)


#lets see them in same pitcure
gold_z   <- scale(Cl(gold))
silver_z <- scale(Cl(silver))

plot(gold_z, type = "l", col = "gold", 
     main = "Gold and Silver (Standardized)",
     ylab = "Standardized Value")
lines(silver_z, col = "grey")
legend("topleft", legend = c("Gold", "Silver"),
       col = c("gold", "grey"), lty = 1)







#the gold/silver prices seems it's expoential, so prabably log it is a good idea
lgold <- log(gold)
plot(lgold)
lsilver <- log(silver)
plot(lsilver)
#check for stationarity
library(tseries)

#Adf test
#H0: The time series is not stationary, unit root process
#H1: It is stationary
adf.test(lgold) #p-value = 0.99
#fail to reject H0 -> not stationary

#KPSS test
#H0: The time series is stationary, not unit root process
#H1: It is not stationary
kpss.test(lgold) #p-value = 0.01
#reject H0 -> not stationary

#with urca library
#will use critical value at 5% significance level
library(urca)
summary(ur.df(lgold, type = "trend", lags = 10, selectlags = "BIC"))
#Cr= -3.12, test-statistic=-0.689
#fail to reject H0 -> not stationary

summary(urca::ur.kpss(lgold, type = "tau"))
#Cr= 0.216, test-statistic = 4.8966 
#reject H0 -> not stationary
library(aTSA)
aTSA::adf.test(lgold)
#fail to reject H0 -> not stationary


#make it stationary: try first order integration I(1)
dlgold <- diff(lgold, k = 1)[-1] #less one data due to diff
plot(dlgold)

#check for stationarity again
tseries::adf.test(dlgold) #reject H0 -> stationary
tseries::kpss.test(dlgold) #fail to reject H0 -> stationary
summary(ur.df(dlgold, type = "trend", lags = 10, selectlags = "BIC"))#reject H0 -> stationary
summary(ur.df(dlgold, type = "drift", lags = 10, selectlags = "BIC"))#reject H0 -> stationary
summary(ur.df(dlgold, type = "none", lags = 10, selectlags = "BIC"))#reject H0 -> stationary

summary(urca::ur.kpss(dlgold, type = "mu"))
#Cr= 0.347, test-statistic = 0.2305
#fail to reject H0 -> stationary
#now it is stationary


acf(dlgold)
pacf(dlgold)
plot(decompose(ts(lgold, frequency=4), type = "multiplicative"))
#If there were strong and stable seasonality in returns, it would likely be exploited by traders, 
#so in practice such seasonality tends to be weak or unstable.

#do the same thing to silver
summary(ur.df(lsilver, type = "trend", lags = 10, selectlags = "BIC"))
summary(ur.df(lsilver, type = "drift", lags = 10, selectlags = "BIC"))
summary(ur.df(lsilver, type = "none", lags = 10, selectlags = "BIC"))
summary(urca::ur.kpss(lsilver, type = "mu"))
#non-statioanry

#diff
dlsilver<- diff(lsilver, k = 1)[-1]










###################################################################################
#Cointegration
#we are interested in whether the two time series share a common long-term trajectory(cointegrated)


























###################################################################################
#check autocorrelation
#H0: there is no autocorrelation up to 36 lags
#H1: autocorrelation exists
library(lmtest)
bgtest(dlgold ~ 1, order=36)
#p-value = 0.02238
#if at 1%, we fail to reject
#but if at 5%, we reject,
#it's a bit too low, let as fit ARMA model

#potential model
library(forecast)
dlgold_arima <- auto.arima(dlgold,
                           seasonal = FALSE,
                           stepwise = TRUE,
                           approximation = FALSE,
                           trace = TRUE,
                           ic = "aic",
                           stationary = TRUE)  # Force stationarity
summary(dlgold_arima)
#potential models
#ARIMA(0,0,0), MA(6), MA(7) MA(18), MA(28), AR(6), AR(7), AR(18),
#AR(28)

#AR(28)
ar28 <- arima(dlgold, order=c(28,0,0))
bgtest(resid(ar28)~1, order=36)
#fail to reject H0, possible model

#AR(18)
ar18 <- arima(dlgold, order=c(18,0,0))
bgtest(resid(ar18)~1, order=36)
#fail to reject H0, possible model

#AR(7)
ar7 <- arima(dlgold, order=c(7,0,0))
bgtest(resid(ar7)~1, order=36)
#fail to reject H0, possible model

#AR(6)
ar6 <- arima(dlgold, order=c(6,0,0))
bgtest(resid(ar6)~1, order=36)
#fail to reject H0, possible model

#MA(28)
ma28 <- arima(dlgold, order=c(0,0,28))
bgtest(resid(ma28)~1, order=36)
#fail to reject H0, possible mode

#MA(18)
ma18 <- arima(dlgold, order=c(0,0,18))
bgtest(resid(ma18)~1, order=36)
#fail to reject H0, possible model

#MA(7)
ma7 <- arima(dlgold, order=c(0,0,7))
bgtest(resid(ma7)~1, order=36)
#fail to reject H0, possible model

#MA(6)
ma6 <- arima(dlgold, order=c(0,0,6))
bgtest(resid(ma6)~1, order=36)
#fail to reject H0, possible model

#ARIMA(28,0,28)
arima2828 <- arima(dlgold, order=c(28,0,28))
bgtest(resid(arima2828)~1, order=36)
#fail to reject H0, possible model

#ARIMA(28,0, 18)
arima2818 <- arima(dlgold, order=c(28,0, 18))
bgtest(resid(arima2828)~1, order=36)
#fail to reject H0, possible model

#simplify code
library(lmtest)

# Test models and find best
test_model <- function(p,d,q) {
  fit <- arima(dlgold, order = c(p,d,q))
  c(AIC = AIC(fit), BIC = BIC(fit), BG_p = bgtest(resid(fit) ~ 1, order = 36)$p.value)
}

# Test your models
results <- rbind(
  AR28 = test_model(28,0,0),
  AR18 = test_model(18,0,0),
  AR7 = test_model(7,0,0),
  AR6 = test_model(6,0,0),
  MA28 = test_model(0,0,28),
  MA18 = test_model(0,0,18),
  MA7 = test_model(0,0,7),
  MA6 = test_model(0,0,6),
  ARIMA2828 = test_model(28,0,28),
  ARIMA2818 = test_model(28,0,18),
  ARIMA287 = test_model(28,0,7),
  ARIMA286 = test_model(28,0,6),
  ARIMA1828 = test_model(18,0,28),
  ARIMA1818 = test_model(18,0,18),
  ARIMA187 = test_model(18,0,7),
  ARIMA186 = test_model(18,0,6),
  ARIMA728 = test_model(7,0,28),
  ARIMA718 = test_model(7,0,18),
  ARIMA77 = test_model(7,0,7),
  ARIMA76 = test_model(7,0,6),
  ARIMA628 = test_model(6,0,28),
  ARIMA618 = test_model(6,0,18),
  ARIMA67 = test_model(6,0,7),
  ARIMA66 = test_model(18,0,6),
)

# Show best model
results[which.min(results[, "AIC"]), ]
results[which.min(results[, "BIC"]), ]
