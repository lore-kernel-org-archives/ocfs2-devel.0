From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:36:46 2008
Subject: [Ocfs2-devel] [PATCH 04/30] ocfs2: Add data downconvert worker to
	inode lock
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-5-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

In order to extend inode lock coverage to inode data, we use the same data
downconvert worker with only a small modification to only do work for
regular files.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 64d6ff4..840aeda 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -228,6 +228,7 @@ static struct ocfs2_lock_res_ops ocfs2_inode_meta_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.check_downconvert = ocfs2_check_meta_downconvert,
 	.set_lvb	= ocfs2_set_meta_lvb,
+	.downconvert_worker = ocfs2_data_convert_worker,
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
@@ -2851,6 +2852,9 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
        	inode = ocfs2_lock_res_inode(lockres);
 	mapping = inode->i_mapping;
 
+	if (S_ISREG(inode->i_mode))
+		goto out;
+
 	/*
 	 * We need this before the filemap_fdatawrite() so that it can
 	 * transfer the dirty bit from the PTE to the
@@ -2876,6 +2880,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		filemap_fdatawait(mapping);
 	}
 
+out:
 	return UNBLOCK_CONTINUE;
 }
 
-- 
1.5.3.6
