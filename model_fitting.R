#script that contains the function for fitting different models to a given feature set


###################################################################################################
#Random Forest - to use random_forest_evaluate(), you need a 
#   1) a training dataframe with:
#       -the first column is the  'grade'
#       -the second column is the 'essayset'
#       -the rest of features
#   2) a test dataframe with:
#       -the first column is the 'essayset'
#       -the rest of the features which are the same as the in the training dataframe
#this function will return
require(randomForest)

# for testing the random_forest_evaluate() function:
training_data<-training_tokens
test_data<-test_tokens
number_of_trees <-20
training_grades <- training$grade
#set <-1
random_forest_evaluate <- function(training_data,training_grades,test_data,number_of_trees){
    results <- NULL
    oob_error <- NULL
    comp <- NULL
    for (set in 1:5){
        print(paste("Now fitting model to essayset, ",set, sep=""))
        subset_training <- training_data[which(training_data$essayset==set),-1]
        subset_test <- test_data[which(test_data$essayset==set),-1]
        subset_training_grades <- training_grades[which(training_data$essayset==set)]
        #fitting the model:
        model_subset <-randomForest(x=subset_training, y=subset_training_grades, ntree=number_of_trees, type="Regression")
        assign(paste("pred_subset",set,sep=""),predict(model_subset, subset_test))
        pred_temp <- predict(model_subset, subset_test)
        set_label <- rep(x=set, times=dim(subset_test)[1])
        weight <- rep(x=1, times=dim(subset_test)[1])
        assign(paste("pred_subset",set,sep=""),cbind(test$id[which(test$set==set)],set_label, weight,round(pred_temp)))
        pred_int <- round(model_subset$predicted)
        oob_error[[set]] <- subset_training_grades-pred_int
        comp[[set]] <-cbind(subset_training_grades, pred_int, pred_int - subset_training_grades)
    }
    #now create the submission document:
    submission <- rbind(pred_subset1,pred_subset2,pred_subset3,pred_subset4,pred_subset5)
    rm(pred_subset1,pred_subset2,pred_subset3,pred_subset4,pred_subset5)
    colnames(submission) <- c("id","set","weight","grade")
    #write.csv(submission, file="submission.csv")
    results[[1]] <- submission
    #calculate error metrics, absolute mean error
    errors <- c(oob_error[[1]], oob_error[[2]], oob_error[[3]], oob_error[[4]], oob_error[[5]])
    results[[2]] <- mean(abs(errors))
    comparison <- rbind(comp[[1]], comp[[2]], comp[[3]], comp[[4]], comp[[5]])
    results[[3]] <- comparison
    results[[4]] <- count(results[[3]][,3]==0)[2,2]/(count(results[[3]][,3]==0)[1,2]+count(results[[3]][,3]==0)[2,2])
    #plot(density(errors))
    
    
    return (results)
}






#######################################################################################################
#Function for fitting glmnet
#the following variable assignments are for debugging the fucntion below
require(nnet)

training_data <- rf_training 
training_response <- training$grade 
rf_test <- test_data
set=1
fit_glmnet <- function(training_data, training_response, test_data){
    results <- NULL
    oob_error <- NULL
    comp <- NULL
    for (set in 1:5){
        print(paste("Now fitting model to essayset, ",set, sep=""))
        subset_training <- training_data[which(training_data$essayset==set),-1]
        subset_test <- test_data[which(test_data$essayset==set),-1]
        subset_training_grades <- training_response[which(training_data$essayset==set)]
        input_data <- cbind(subset_training_grades,subset_training)
        #featureWordCount+featureAvgWordLength+featureAvgSentenceLength+featureCommas + featureDash + featureSemiColon
        model_subset <- lm(subset_training_grades~featureWordCount+featureAvgWordLength+featureAvgSentenceLength+featureCommas + featureDash + featureSemiColon, data=input_data)
        model_subset <- lm(subset_training_grades~featureWordCount+featureAvgWordLength +, data=input_data)
    }}   
       
        
        
        
library(e1071)
library(rpart)     
       
training_data <- rf_training 
training_response <- training$grade 
rf_test <- test_data        
    
set <- 1
results <- NULL
oob_error <- NULL
comp <- NULL
for (set in 1:5){
    print(paste("Now fitting model to essayset, ",set, sep=""))
    subset_training <- training_data[which(training_data$essayset==set),-1]
    subset_test <- test_data[which(test_data$essayset==set),-1]
    subset_training_grades <- training_response[which(training_data$essayset==set)]
    input_data <- cbind(subset_training_grades,subset_training)
    colnames(input_data)[1] <- "grades"

svm.model <- boosting(grades ~ ., data = input_data)
svm.pred <- predict(svm.model, subset_test)       
        
        
        
        
        
        
        
        model_subset <-glmnet(x=subset_training, y=subset_training_grades)
        
input_data$subset_training_grades

        assign(paste("pred_subset",set,sep=""),predict(model_subset, subset_test))
        pred_temp <- predict(model_subset, subset_test)
        set_label <- rep(x=set, times=dim(subset_test)[1])
        weight <- rep(x=1, times=dim(subset_test)[1])
        assign(paste("pred_subset",set,sep=""),cbind(test$id[which(test$set==set)],set_label, weight,round(pred_temp)))
        pred_int <- round(model_subset$predicted)
        oob_error[[set]] <- pred_int - subset_training_grades
        comp[[set]] <-cbind(subset_training_grades, pred_int, abs(pred_int - subset_training_grades))
    }
    #now create the submission document:
    submission <- rbind(pred_subset1,pred_subset2,pred_subset3,pred_subset4,pred_subset5)
    rm(pred_subset1,pred_subset2,pred_subset3,pred_subset4,pred_subset5)
    colnames(submission) <- c("id","set","weight","grade")
    #write.csv(submission, file="submission.csv")
    results[[1]] <- submission
    #calculate error metrics, absolute mean error
    errors <- c(oob_error[[1]], oob_error[[2]], oob_error[[3]], oob_error[[4]], oob_error[[5]])
    results[[2]] <- mean(abs(errors))
    comparison <- rbind(comp[[1]], comp[[2]], comp[[3]], comp[[4]], comp[[5]])
    results[[3]] <- comparison
    #plot(density(errors))
    
}