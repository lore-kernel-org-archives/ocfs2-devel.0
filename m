From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Aug 10 19:11:21 2004
Subject: [Ocfs2-devel] [bug] dead lock when truncate file
Message-ID: <3ACA40606221794F80A5670F0AF15F840520BDAB@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


svn 1343 kernel 2.6.6
Step:
On node A, call truncate(filename, size) in loop and at the same time,
call stat
to filename at node B
Result
On node A, the process went into "D" status
On node B, the process exit regular.

The call stack on Node A for truncate
schedule
ocfs_lookup_file_allocation
ocfs_get_block
ocfs2_zero_extend
ocfs_setattr
sys_truncate

It is in some down fail.
Not sure whether it fails in down_read(&OCFS_I(inode)->ip_io_sem);
or
down(&OCFS_I(inode)->ip_sem)

-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)
503-712-6740(Temp)

xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
