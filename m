From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Jun 18 02:23:46 2004
Subject: [Ocfs2-devel] some intersting result for ocfs2 performance
Message-ID: <3ACA40606221794F80A5670F0AF15F8404AE1150@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I made simple C program to test for the reading performance. see attach.
The result are interesting.
The program will open the file and repeat read(-p specified), each time
the throughput is print out.

The first time read, the performance is low,it's reasonable, but after
sleep 6 seconds, the next read 
performance will also drop, and if only sleep 5 seconds, it won't.
So, it looks like after 5 seconds, the cache will be thrown out, it that
ture?

but compare with ext3 (the last data, 100 times), seems the cache in
ocfs2 doesn't take effective at all.

run on svn 1122.
=======================================================
./ben -f /ocfs/ttt -s 128 -a -p 10 --create

create file /ocfs/ttt of size 128K successfully
total:128.000K Time:22.010 Rate:5816KB
total:128.000K Time:11.952 Rate:10710KB
total:128.000K Time:11.997 Rate:10669KB
total:128.000K Time:12.055 Rate:10618KB
total:128.000K Time:11.891 Rate:10764KB
total:128.000K Time:11.996 Rate:10670KB
total:128.000K Time:12.023 Rate:10646KB
total:128.000K Time:11.907 Rate:10750KB
total:128.000K Time:12.071 Rate:10604KB
total:128.000K Time:12.000 Rate:10667KB
total:1280.000K Time:130.101 Rate:9839KB

./ben -f /ocfs/ttt -s 128 -a -p 10 --sleep 5

total:128.000K Time:20.667 Rate:6193KB
total:128.000K Time:11.903 Rate:10754KB
total:128.000K Time:12.011 Rate:10657KB
total:128.000K Time:11.917 Rate:10741KB
total:128.000K Time:8.272 Rate:15474KB
total:128.000K Time:8.287 Rate:15446KB
total:128.000K Time:12.124 Rate:10558KB
total:128.000K Time:12.014 Rate:10654KB
total:128.000K Time:11.953 Rate:10709KB
total:128.000K Time:11.990 Rate:10676KB
total:1280.000K Time:5121.921 Rate:250KB

./ben -f /ocfs/ttt -s 128 -a -p 10 --sleep 6

total:128.000K Time:12.325 Rate:10385KB
total:128.000K Time:11.925 Rate:10734KB
total:128.000K Time:11.928 Rate:10731KB
total:128.000K Time:11.966 Rate:10697KB
total:128.000K Time:11.990 Rate:10676KB
total:128.000K Time:12.065 Rate:10609KB
total:128.000K Time:20.131 Rate:6358KB
total:128.000K Time:11.980 Rate:10684KB
total:128.000K Time:12.032 Rate:10638KB
total:128.000K Time:11.907 Rate:10750KB
total:1280.000K Time:6129.400 Rate:209KB


--------------------------------
for ext3

./ben -f /ext3/ttt -s 128 -a -p 10 --create

create file /ocfs2/ttt of size 128K successfully
total:128.000K Time:0.114 Rate:1122807KB
total:128.000K Time:0.052 Rate:2461538KB
total:128.000K Time:0.050 Rate:2560000KB
total:128.000K Time:0.050 Rate:2560000KB
total:128.000K Time:0.050 Rate:2560000KB
total:128.000K Time:0.050 Rate:2560000KB
total:128.000K Time:0.050 Rate:2560000KB
total:128.000K Time:0.051 Rate:2509804KB
total:128.000K Time:0.050 Rate:2560000KB
total:128.000K Time:0.050 Rate:2560000KB
total:1280.000K Time:0.654 Rate:1957187KB
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ben.c
Type: application/octet-stream
Size: 4238 bytes
Desc: ben.c
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040618/1b16165f/ben.obj
