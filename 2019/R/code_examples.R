require(caret)
require(dplyr)
require(ggplot2)
set.seed(1234)
ggplot2::theme_set(theme_bw())

#get data to use later
dat <- read.table("http://www.emersonstatistics.com/Datasets/fev.txt", header = TRUE) %>% 
  mutate(smoke = smoke - 1,
         sex = sex - 1)
  

train_index_regression <- createDataPartition(dat$fev, p = .8, 
                                  list = FALSE, 
                                  times = 1)

train_index_classification <- createDataPartition(dat$smoke, p = .8, 
                                    list = FALSE, 
                                    times = 1)

train_reg <- dat[train_index_regression,]
test_reg  <- dat[-train_index_regression,]

train_class <- dat[train_index_classification,]
test_class  <- dat[-train_index_classification,]

#linear regression
#fit the model and check assumptions
ggplot(dat, aes(x = age, y = fev)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = F) + 
  labs(x = "Age", y = "FEV", title = "Lung Strength by Age", subtitle = "FEV dataset")
lin_reg <- lm(fev ~ age, data = train_reg)
summary(lin_reg)
plot(lin_reg)

#make a prediction
pred_lm <- predict(lin_reg, test_reg)
mse_lm <- mean((test_reg$fev - pred_lm)^2)
mse_lm

#logistic regression
ggplot(dat, aes(x = factor(smoke), y = fev)) + 
  geom_boxplot() + 
  labs(x = "Smoker?", y = "FEV", title = "Lung Strength by Smoking Status", subtitle = "FEV dataset")

log_reg <- glm(smoke~fev + age, data = train_class, family=binomial(link="logit"))
summary(log_reg)
exp(log_reg$coefficients)

#make a prediction
pred_glm <- predict(log_reg, test_class, type = "response")
pred_glm

pred_glm <- ifelse(pred_glm > .5, 1, 0)
conf_mat_glm <- confusionMatrix(factor(test_class$smoke), factor(pred_glm), positive = "1")
conf_mat_glm

require(pROC)
plot.roc(test_class$smoke, pred_glm)

#using random forest
require(randomForest)
rf_reg <- randomForest(fev ~ age, data = train_reg)
pred_rf <- predict(rf_reg, test_reg)
mse_rf <- mean((test_reg$fev - pred_rf)^2)
mse_rf

rf_class <- randomForest(factor(smoke) ~ age + fev, data = train_class)
pred_rf <- predict(rf_class, test_class, type = "response")
pred_rf

conf_mat_rf <- confusionMatrix(factor(test_class$smoke), factor(pred_rf), positive = "1")
conf_mat_rf

###code for exercise 
library(tidyr)
setwd("/Users/mm06832/Documents/Projects/datafest/2019/data/")

#read data and turn from wide to long format for ease of modeling 
cities <- read.csv("city_attributes.csv") 
humidity <- read.csv("humidity.csv") %>% gather(2:37, key = "city", value = "humidity")
pressure <- read.csv("pressure.csv") %>% gather(2:37, key = "city", value = "pressure")
temperature <- read.csv("temperature.csv") %>% gather(2:37, key = "city", value = "temperature")
weather <- read.csv("weather_description.csv") %>% gather(2:37, key = "city", value = "weather")
wind_direction <- read.csv("wind_direction.csv") %>% gather(2:37, key = "city", value = "wind_direction")
wind_speed <- read.csv("wind_speed.csv") %>% gather(2:37, key = "city", value = "wind_speed")

#join tables into single dataset 
dat <- humidity %>% 
  inner_join(pressure, by = c("datetime", "city")) %>% 
  inner_join(temperature,  by = c("datetime", "city")) %>% 
  inner_join(weather, by = c("datetime", "city")) %>% 
  inner_join(wind_direction, by = c("datetime", "city")) %>% 
  inner_join(wind_speed, by = c("datetime", "city")) %>%
  left_join(cities, by = c("city" = "City"))

#binary classification - turn weather into "good" or "bad"
dat <- dat %>% 
  mutate("weather_binary" = ifelse(weather %in% c("sky is clear", "broken clouds", "few clouds", "scattered clouds", "overcast clouds"), 
                                  "good", 
                                  "bad"))

#multiclass classification - predict weather
#bin into 5-8 categories
dat <- dat %>% 
  mutate("weather_broad" = case_when(
                                  weather %in% c("drizzle", "freezing_rain", "heavy intensity drizzle", "heavy intensity rain", "heavy intensity shower rain",
                                                 "light intensity drizzle", "light intensity drizzle rain", "light intensity shower rain", "light rain",
                                                 "light shower rain", "moderate rain", "proximity moderate rain", "ragged shower rain", "shower drizzle",
                                                 "very heavy rain", "proximity shower rain", "heavy snow", "light rain and snow", "light shower sleet", 
                                                 "light snow", "rain and snow", "shower snow",
                                                 "sleet", "snow", "heavy shower snow", "thunderstorm with drizzle", "thunderstorm with heavy drizzle", 
                                                 "thunderstorm with light drizzle", "thunderstorm", "ragged thunderstorm"
                                                 "thunderstorm with rain", "thunderstorm with light rain", "heavy thunderstorm", "proximity thunderstorm",
                                                 "proximity thunderstorm with drizzle", "proximity thunderstorm with rain", "proximity thunderstorm") ~ "precipitation",
                                  weather %in% c("broken clouds", "overcast clouds", "scattered clouds", "few clouds") ~ "cloudy",
                                  weather %in% c("sky is clear") ~ "clear",
                                  TRUE ~ "other"
                            )
  )

#regression 1 - find a variable you want to predict and fit single LR using best variable (how to judge?) 

#regression 2 - try that same response variable with more vars, then try a different modeling method (see how results change)

dat %>% 
  mutate(day = ymd(datetime)) %>% 
  ggplot(aes(x = day, y = pressure)) + geom_line(group = 1) + facet_grid(~Country)
  