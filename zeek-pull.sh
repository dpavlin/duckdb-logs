rsync -rav --include 'conn.*' --exclude '*.log.gz' enesej:/opt/zeek/logs/$( date +%Y-%m )* zeek/
