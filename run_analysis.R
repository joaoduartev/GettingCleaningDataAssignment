library(dplyr)

setwd('./Getting and Cleaning Data/UCI HAR Dataset')
nomes <- read.table('features.txt')[,2]

setwd('./test')
test <- read.table('X_test.txt')
subject_test <- read.table('subject_test.txt')
colnames(test) <- nomes
test <- test[grep('.mean.|.std.', nomes, ignore.case = TRUE, value = TRUE)]
test <- cbind(read.table('y_test.txt'), test)
test[,'subject'] <- subject_test

setwd('../')
setwd('./train')
train <- read.table('X_train.txt')
subject_train <- read.table('subject_train.txt')
colnames(train) <- nomes
train <- train[grep('.mean.|.std.', nomes, ignore.case = TRUE, value = TRUE)]
train <- cbind(read.table('y_train.txt'), train)
train[,'subject'] <- subject_train

dados <- rbind(test, train)
setwd('../')
activity <- read.table('activity_labels.txt')

dados[1] <- left_join(dados, activity)[ncol(left_join(dados, activity))]
names(dados)[1] = 'activity'

resumo <- dados %>% group_by(subject, activity) %>% summarise_all(mean)

write.table(resumo, file = "tidy_data.txt", sep = "\t", row.names = FALSE, col.names = TRUE)
