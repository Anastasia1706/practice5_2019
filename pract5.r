---
title: "Untitled"
author: "Lukyanova A.S."
date: '10 апреля 2019 г '
output:
  html_document:
    self_contained: yes
---

```{r setup, warning = F, message = F}
# загрузка пакетов
library('data.table')
library('WDI')
library('leaflet')
# devtools::install_github('mages/googleVis')
suppressPackageStartupMessages(library('googleVis'))

# для загрузки свежей версии pandoc:
#  https://github.com/pandoc-extras/pandoc-nightly/releases/tag/hash-7c20fab3
#  архив pandoc-windows-7c20fab3.zip распаковать в RStudio/bin/pandoc
```

```{r Интерактивная картограмма, results = 'asis', cashe = T}
# данные по ВВП по ППП
indicator.code = 'EN.ATM.CO2E.PC'
DT <- data.table(WDI(indicator = indicator.code, start = 2013, end = 2013))

# все коды стран iso2
fileURL <- 'https://pkgstore.datahub.io/core/country-list/data_csv/data/d7c9d7cfb42cb69f4422dec222dbbaa8/data_csv.csv'
all.iso2.country.codes <- read.csv(fileURL, stringsAsFactors = F, 
                                   na.strings = '.')

# убираем макрорегионы
DT <- na.omit(DT[iso2c %in% all.iso2.country.codes$Code, ]) 

# объект: таблица исходных данных
g.tbl <- gvisTable(data = DT[, -'year'],  
                   options = list(width = 300, height = 400))
# объект: интерактивная карта
g.chart <- gvisGeoChart(data = DT, 
                        locationvar = 'iso2c', 
                        hovervar = 'country' ,
                        colorvar = indicator.code, 
                        options = list(width = 500, 
                                       height = 400, 
                                       dataMode = 'regions'))
# размещаем таблицу и карту на одной панели (слева направо)
TG <- gvisMerge(g.tbl, g.chart,
                horizontal = TRUE, 
                tableOptions = 'bgcolor=\"#CCCCCC\" cellspacing=10')

# вставляем результат в html-документ
TG
```
