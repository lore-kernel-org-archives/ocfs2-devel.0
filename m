From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Aug 19 02:27:15 2004
Subject: [Ocfs2-devel] 
	[Patch] fix bug 132 "link for directory does not change after mv
	subdir to another"
Message-ID: <3ACA40606221794F80A5670F0AF15F84053D91FD@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I guess new_dir_nlink & old_dir_nlink are orignally designed to record
the link number after changing.
But in fact, new_dir->i_nlink & old_dir->i_nlink is used directly. 
So either of the two patches below can work.

patch1
------------------------------------------------------------------------
---
Index: namei.c
===================================================================
--- namei.c (revision 1361)
+++ namei.c (working copy)
@@ -1252,8 +1257,7 @@
                ocfs2_dinode *fe;
                status = ocfs_journal_access(handle, new_dir_bh,
OCFS_JOURNAL_ACCESS_WRITE);
                fe = (ocfs2_dinode *) new_dir_bh->b_data;
-               fe->i_links_count = new_dir_nlink;
-               new_dir->i_nlink = new_dir_nlink;
+               fe->i_links_count = new_dir->i_nlink;
                status = ocfs_journal_dirty(handle, new_dir_bh);
            }
        }
@@ -1267,8 +1271,7 @@
            ocfs2_dinode *fe;
            status = ocfs_journal_access(handle, old_dir_bh,
OCFS_JOURNAL_ACCESS_WRITE);
            fe = (ocfs2_dinode *) old_dir_bh->b_data;
-           fe->i_links_count = old_dir_nlink;
-           old_dir->i_nlink = old_dir_nlink;
+           fe->i_links_count = old_dir->i_nlink;
            status = ocfs_journal_dirty(handle, old_dir_bh);
        }
    }

patch2
------------------------------------------------------------------------
---------------------------
Index: namei.c
===================================================================
--- namei.c (revision 1361)
+++ namei.c (working copy)
@@ -1230,11 +1235,11 @@
            // BAD
            goto bail;
        }
-       old_dir->i_nlink--;
+       old_dir_nlink--;
        if (new_inode) {
            new_inode->i_nlink--;
        } else {
-           new_dir->i_nlink++;
+           new_dir_nlink++;
            mark_inode_dirty(new_dir);
        }
    }
-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)


xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
