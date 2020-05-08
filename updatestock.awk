NR==FNR { a[$1] = $(NF-2); next }
FNR==1 { FS=OFS=":"; $0=$0 }
{ $3 -= a[$1]; print }
