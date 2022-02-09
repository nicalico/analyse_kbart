#!/bin/awk -f

BEGIN {
fulltext=0;
ebook=0; 
video=0; 
abstracts=0; 
image=0;
selectedarticles=0; 
autres=0; 
audio=0;
FS="\t"; 
OFS=FS; 
IGNORECASE=1
}

{if ($14 ~ /ebook/) then ebook++
else if ($14 ~ /fulltext/) then fulltext++
else if ($14 ~ /video/) then video++
else if ($14 ~ /abstracts/) then abstracts++
else if ($14 ~ /audio/) then audio++
else if ($14 ~ /selected/) then selectedarticles++
else if ($14 ~ /image/) then image++
else autres++}

END {
print "    Ebooks: " ebook;
print "    Fulltext: " fulltext;
print "    Video: " video;
print "    Abstracts: " abstracts;
print "    Audio: " audio;
print "    Selected articles: " selectedarticles;
print "    Images: " image;
print "    Autre: " autres-1;
print "\nTotal: " ebook + fulltext + video + abstracts + audio + selectedarticles + image + autres - 1
}

