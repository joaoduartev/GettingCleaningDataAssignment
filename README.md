---
title: "README"
author: "João"
date: "06/11/2020"
output: html_document
---

## Extracting data

```
library(dplyr)
library(knitr)
```

Firstly, the code get the column names from the features file directly into a character vector.

```
setwd('./Getting and Cleaning Data/UCI HAR Dataset')
nomes <- read.table('features.txt')[,2]
```

## Test data

Then, R extracts the main test data from X_test.txt and loads it into a data frame. Also, we set the column names from the vector nomes.

```
setwd('./test')
test <- read.table('X_test.txt')
colnames(test) <- nomes
```

Using regex, we look for columns that have the strings "mean" e "std" on the column names. 

```
test <- test[grep('.mean.|.std.', nomes, ignore.case = TRUE, value = TRUE)]
```

Finally, we add a column using with the activities number for every record.

```
test <- cbind(read.table('y_test.txt'), test)
```
We add a column using to the subjects as well.

```
test[,'subject'] <- subject_test
```

## Train data

And so we repeat the same process to the train file. So, we start extracting the data from X_train.txt and set the column names from the vector nomes.


```
setwd('../')
setwd('./train')
train <- read.table('X_train.txt')
subject_train <- read.table('subject_train.txt')
colnames(train) <- nomes
```

Now, getting the column names with "mean" e "std".

```
train <- train[grep('.mean.|.std.', nomes, ignore.case = TRUE, value = TRUE)]
```

Putting the activities number and the subjects column.

```
train <- cbind(read.table('y_train.txt'), train)
train[,'subject'] <- subject_train
```

## Merging and summarizing the data

First, we merge the data using rbind (i.e. putting the records together by adding the lines)

```
dados <- rbind(test, train)
```

Now, R loads the activity labels into a table.

```
setwd('../')
activity <- read.table('activity_labels.txt')
```

So, we set the first column, until now activity number, to activity label. To match the number with the labels, it's used a left join and only extracted the desired column from the resulting data. The name of the column is also changed.

```
dados[1] <- left_join(dados, activity)[ncol(left_join(dados, activity))]
names(dados)[1] = 'activity'
```

Finally, to get the tidy data with the mean of every activity on every column, we use the summarise_all function. The resulting dataframe is stored into a variable called resumo.

```
resumo <- dados %>% group_by(activity) %>% summarise_all(mean)
```

The resulting data is the tidy data requested and is exported to a txt file.

```
write.table(resumo, file = "tidy_data.txt", sep = "\t", row.names = FALSE, col.names = TRUE)
```