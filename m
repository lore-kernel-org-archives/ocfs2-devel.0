From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Aug  5 19:59:38 2004
Subject: [Ocfs2-devel] Error message shows when create and rmdir
Message-ID: <3ACA40606221794F80A5670F0AF15F84051672AF@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Try this on 2.6.6 for svn 1303, this also exist on prev version.

Two node with /ocfs mount to the same disk.
1.node 0: mkdir /ocfs/a
2.node 1: rmdir /ocfs/a
after a while, when the journal commited.
It shows:
(18503) commit_thread: flushed 1 transactions, releasing 3 locks
(18503) commit_thread: after optimization, 3 locks to release
(18503) ERROR at /home/xling/ocfs/ocfs2/src/bitmap.c, 408:
bitmap->validbits = 
0 but start = 277 and num = 1!

see bug 115

-------------------
Intel China Software Lab.
iNet: 8-752-1243
021-52574545-1243(O)
xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
