From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Jul 29 16:57:41 2004
Subject: [Ocfs2-devel] 
	[Patch] Fix bug 109, delete subdir does not decrease the link on
	parent.
Message-ID: <3ACA40606221794F80A5670F0AF15F840504359B@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Index: namei.c
===================================================================
--- namei.c     (revision 1312)
+++ namei.c     (working copy)
@@ -813,7 +813,7 @@
                }
                dirfe = (ocfs2_dinode *) parent_node_bh->b_data;
                dirfe->i_links_count--;
-               status = ocfs_journal_dirty(handle, fe_bh);
+               status = ocfs_journal_dirty(handle, parent_node_bh);
                if (status < 0) {
                        LOG_ERROR_STATUS(status);
                        goto leave;
