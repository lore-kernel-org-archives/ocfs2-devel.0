From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Jul 28 13:20:45 2004
Subject: [Ocfs2-devel] [Patch] how about remove the sync in ocfs_file_open?
Message-ID: <3ACA40606221794F80A5670F0AF15F8404FFE3CD@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From the data below, this sync cause the performance of writting from
second time downgrade(13M compare to 544M for 128K file).
and the sync has no use here.

Index: file.c
===================================================================
--- file.c      (revision 1308)
+++ file.c      (working copy)
@@ -300,7 +301,6 @@
                have_oin_sem = 0;
        }

-       status = ocfs_sync_inode(inode);

 leave:
        if (have_oin_sem) {


before remove
-----------------------------------------------------------------
 ./ben -0 -p10 -a
create file /ocfs/ocfs_test25032 of size 128K successfully
total:128.000K Time:0.562 Rate:227758KB
total:128.000K Time:9.795 Rate:13068KB
total:128.000K Time:9.687 Rate:13214KB
total:128.000K Time:8.999 Rate:14224KB
total:128.000K Time:9.817 Rate:13039KB
total:128.000K Time:9.802 Rate:13059KB
total:128.000K Time:9.146 Rate:13995KB
total:128.000K Time:9.646 Rate:13270KB
total:128.000K Time:9.655 Rate:13257KB
total:128.000K Time:9.028 Rate:14178KB
total:1280.000K Time:87.329 Rate:14657KB

after remove
------------------------------------------------------------------------
------------------
./ben -0 -p10 -a
create file /ocfs/ocfs_test24613 of size 128K successfully
total:128.000K Time:0.292 Rate:438356KB
total:128.000K Time:0.235 Rate:544681KB
total:128.000K Time:0.209 Rate:612440KB
total:128.000K Time:0.225 Rate:568889KB
total:128.000K Time:0.207 Rate:618357KB
total:128.000K Time:0.219 Rate:584475KB
total:128.000K Time:0.205 Rate:624390KB
total:128.000K Time:0.207 Rate:618357KB
total:128.000K Time:0.204 Rate:627451KB
total:128.000K Time:0.204 Rate:627451KB
total:1280.000K Time:3.083 Rate:415180KB
-------------------


Index: file.c
===================================================================
--- file.c      (revision 1308)
+++ file.c      (working copy)
@@ -300,7 +301,6 @@
                have_oin_sem = 0;
        }

-       status = ocfs_sync_inode(inode);

 leave:
        if (have_oin_sem) {




Intel China Software Lab.
iNet: 8-752-1243
021-52574545-1243(O)
xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
