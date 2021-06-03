#!/bin/sh


if [ ! -d KodExplorer ]; then
    git clone https://github.com/kalcaddle/KodExplorer.git
fi

chmod -Rf 777 ./KodExplorer/*

# check work directory
#The work directory of kodexplorer defined in KodExplorer/config/define.php file
#below:
#<?php define ('DATA_PATH', '/opt/kodexplorer-data/');
cat KodExplorer/config/define.php 
#keDaoYun

