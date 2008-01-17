From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:36:43 2008
Subject: [Ocfs2-devel] [PATCH 15/30] ocfs2: build warnings fix
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-16-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

Fix these types of warnings:

fs/ocfs2/resize.c: In function ?ocfs2_group_extend?:
fs/ocfs2/resize.c:358: warning: format ?%llu? expects type ?long long
unsigned int?, but argument 6 has type ?long unsigned int?

u64 needs to be casted to unsigned long long when printing as %llu

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/resize.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index ba305c1..84e06b6 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -356,7 +356,7 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	}
 
 	mlog(0, "extend the last group at %llu, new clusters = %d\n",
-	     le64_to_cpu(group->bg_blkno), new_clusters);
+	     (unsigned long long)le64_to_cpu(group->bg_blkno), new_clusters);
 
 	handle = ocfs2_start_trans(osb, OCFS2_GROUP_EXTEND_CREDITS);
 	if (IS_ERR(handle)) {
@@ -547,7 +547,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	ret = ocfs2_read_block(osb, input->group, &group_bh, 0, NULL);
 	if (ret < 0) {
 		mlog(ML_ERROR, "Can't read the group descriptor # %llu "
-		     "from the device.", input->group);
+		     "from the device.", (unsigned long long)input->group);
 		goto out;
 	}
 
@@ -560,7 +560,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	}
 
 	mlog(0, "Add a new group  %llu in chain = %u, length = %u\n",
-	     input->group, input->chain, input->clusters);
+	     (unsigned long long)input->group, input->chain, input->clusters);
 
 	handle = ocfs2_start_trans(osb, OCFS2_GROUP_ADD_CREDITS);
 	if (IS_ERR(handle)) {
-- 
1.5.3.6
