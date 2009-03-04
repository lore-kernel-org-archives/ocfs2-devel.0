From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed,  4 Mar 2009 11:21:38 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix check condition of max inline
	data
In-Reply-To: <49ADF2FB.6060503@oracle.com>
References: <49ADF2FB.6060503@oracle.com>
Message-ID: <1236136898-3999-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We should consider the inline xattr when
we try to write inline data.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/aops.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index a067a6c..dc6d734 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1555,6 +1555,7 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
 	int ret, written = 0;
 	loff_t end = pos + len;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_dinode *di = NULL;
 
 	mlog(0, "Inode %llu, write of %u bytes at off %llu. features: 0x%x\n",
 	     (unsigned long long)oi->ip_blkno, len, (unsigned long long)pos,
@@ -1587,7 +1588,9 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
 	/*
 	 * Check whether the write can fit.
 	 */
-	if (mmap_page || end > ocfs2_max_inline_data(inode->i_sb))
+	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
+	if (mmap_page ||
+	    end > ocfs2_max_inline_data_with_xattr(inode->i_sb, di))
 		return 0;
 
 do_inline_write:
-- 
1.5.4.1
