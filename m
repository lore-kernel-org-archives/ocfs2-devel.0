From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Aug 12 14:58:00 2004
Subject: [Ocfs2-devel] results of inode performance 
Message-ID: <3ACA40606221794F80A5670F0AF15F8405292201@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have some test for the inode operation, below is the results. 
1-mkdir 2-rmdir 3-rename 4-mknod for regular file 5-unlink for regular
file.
--------------------------------------------------------------------
Just after mount:
[root@ocfs1 src] ./bend -1
total:100, rate:664.5 dir/sec
[root@ocfs1 src]# ./bend -2
total:100, rate:11217.0 dir/sec
[root@ocfs1 src]# ./bend -1
total:100, rate:2442.3 dir/sec
[root@ocfs1 src]# ./bend -3
total:100, rate:1487.2 dir/sec
[root@ocfs1 src]# ./bend -4
total:100, rate:2452.6 dir/sec
[root@ocfs1 src]# ./bend -5
total:100, rate:18066.8 dir/sec
-------------------------------------------------------------------
another try after a while

[root@ocfs1 src]./bend -1
total:100, rate:2404.3 dir/sec
[root@ocfs1 src]# ./bend -2
total:100, rate:16186.5 dir/sec
[root@ocfs1 src]# ./bend -1
total:100, rate:2391.4 dir/sec
[root@ocfs1 src]# ./bend -3
total:100, rate:1992.4 dir/sec
[root@ocfs1 src]# ./bend -4
total:100, rate:2402.5 dir/sec
[root@ocfs1 src]# ./bend -5
total:100, rate:13383.3 dir/sec

=====================
another try for 1000 subdir or file
[root@ocfs1 src]# ./bend -1 -p 1000
total:1000, rate:1161.0 dir/sec
[root@ocfs1 src]# ./bend -2 -p 1000
total:1000, rate:4869.9 dir/sec
[root@ocfs1 src]# ./bend -1 -p 1000
total:1000, rate:1124.3 dir/sec
[root@ocfs1 src]# ./bend -3 -p 1000
total:1000, rate:1096.3 dir/sec
[root@ocfs1 src]# ./bend -4 -p 1000
total:1000, rate:452.1 dir/sec
[root@ocfs1 src]# ./bend -5 -p 1000
total:1000, rate:7009.4 dir/sec


-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)
503-712-6740(Temp)

xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
