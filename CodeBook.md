---
title: "CodeBook"
author: "João"
date: "09/09/2020"
output: html_document
---

## Extracting data

```
library(dplyr)
library(knitr)
```

nomes is the variable that stores the column names extracted from the features file.

```
nomes <- read.table('features.txt')[,2]
```

test is the variable that stores the main data, loaded from X_test.

```
test <- read.table('X_test.txt')
colnames(test) <- nomes
```

test is transformed by getting only the subset that has "mean" and "std" on the column name.

```
test <- test[grep('.mean.|.std.', nomes, ignore.case = TRUE, value = TRUE)]
```

test is again transformed by adding a new column with the activies number.

```
test <- cbind(read.table('y_test.txt'), test)
```

train is the variable that stores the main data, loaded from X_train.

```
train <- read.table('X_train.txt')
colnames(train) <- nomes
```

train is transformed by getting only the subset that has "mean" and "std" on the column name.

```
train <- train[grep('.mean.|.std.', nomes, ignore.case = TRUE, value = TRUE)]
```

train is again transformed by adding a new column with the activies number.

```
train <- cbind(read.table('y_train.txt'), train)
```

dados the variable that stores the merging of both train and test data.

```
dados <- rbind(test, train)
```

activity is the variable that store the activities labels.

```
activity <- read.table('activity_labels.txt')
```

dados is transformed by changing the activities number to activities labels.

```
dados[1] <- left_join(dados, activity)[ncol(left_join(dados, activity))]
names(dados)[1] = 'activity'
```

resumo is the variable that stores the tidy data with the summarized data.

```
resumo <- dados %>% group_by(activity) %>% summarise_all(mean)
```