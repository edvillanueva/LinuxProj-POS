BEGIN { FS=OFS=":"; min=max=1 }
NR==1 { print; next }
{
    uid = $2+0
    uid2user[uid] = $1
    min = (min > uid ? uid : min)
    max = (max < uid ? uid : max)
}
END {
    fmt = "%s" OFS "%04d\n"
    for (uid=min; uid<=max; uid++) {
        if (uid in uid2user) {
            printf fmt, uid2user[uid], uid
        }
        else if (newUser != "") {
            printf fmt, newUser, uid
            newUser = ""
        }
    }
    if (newUser != "") {
        printf fmt, newUser, uid
    }
}
