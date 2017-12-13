#!/bin/bash

WDIR=/usr/local/shellscripts/airquality

stty -F /dev/ttyUSB0 9600 raw

INPUT=$(od --endian=big -x -N10 < /dev/ttyUSB0|head -n 1|cut -f2-10 -d" ");


FIRST4BYTES=$(echo $INPUT|cut -b1-4);

if [ "$FIRST4BYTES" = "aac0" ]; then
    logger "check for correct intro characters: ok"
else
    logger "incorrect sequence, exiting"
    exit;
fi

PPM25LOW=$(echo $INPUT|cut -f2 -d " "|cut -b1-2);
PPM25HIGH=$(echo $INPUT|cut -f2 -d " "|cut -b3-4);

PPM10LOW=$(echo $INPUT|cut -f3 -d " "|cut -b1-2);
PPM10HIGH=$(echo $INPUT|cut -f3 -d " "|cut -b3-4);

#Conversione decimale
PPM25LOWDEC=$( echo $((0x$PPM25LOW)) );
PPM25HIGHDEC=$( echo $((0x$PPM25HIGH)) );

PPM10LOWDEC=$( echo $((0x$PPM10LOW)) );
PPM10HIGHDEC=$( echo $((0x$PPM10HIGH)) );

PPM25=$(echo "scale=1;((( $PPM25HIGHDEC * 256 ) + $PPM25LOWDEC ) / 10 ) "|bc -l );
PPM10=$(echo "scale=1;((( $PPM10HIGHDEC * 256 ) + $PPM10LOWDEC ) / 10 ) "|bc -l );

logger "Concentrazione PPM25: $PPM25"
logger "Concentrazione PPM10: $PPM10"

echo "pm25 $PPM25"
echo "pm10 $PPM10"
