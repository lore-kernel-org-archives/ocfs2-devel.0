From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Aug  6 20:29:50 2004
Subject: [Ocfs2-devel] [BUG] system hang when copying with reading
Message-ID: <3ACA40606221794F80A5670F0AF15F8405167C14@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Step:
node A: copy a file "bb.txt" of 200M to ocfs root
node B: cd ocfs root, run "head bb.txt"
Result:
node B hangs.
by kdb, three process went into "D" status. head, ocfs2cmt, kjourand
in head, it is in ocfs_notify_truncate_on_wopen, 
in ocfs2cmt, it is in ocfs_commit_cache.

It's ok if head run on same node.
report it as bug 117
-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)
503-712-6740(Temp)

xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
