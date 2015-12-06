#!/bin/bash
find /var/www/storage/cache/images/* -atime +10 -exec rm {} \;
