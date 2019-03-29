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
  