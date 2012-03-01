From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  1 Mar 2012 11:34:22 -0800
Subject: [Ocfs2-devel] [PATCH 8/9] ocfs2: Replace nlink_t with unsigned int
In-Reply-To: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
References: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1330630463-30305-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

nlink_t was replaced as per the suggestion in the following link.
https://lkml.org/lkml/2012/2/2/577

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-of-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/namei.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index be24469..cfbe68e 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1053,7 +1053,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	handle_t *handle = NULL;
 	struct buffer_head *old_dir_bh = NULL;
 	struct buffer_head *new_dir_bh = NULL;
-	nlink_t old_dir_nlink = old_dir->i_nlink;
+	unsigned int old_dir_nlink = old_dir->i_nlink;
 	struct ocfs2_dinode *old_di;
 	struct ocfs2_dir_lookup_result old_inode_dot_dot_res = { NULL, };
 	struct ocfs2_dir_lookup_result target_lookup_res = { NULL, };
@@ -1414,9 +1414,9 @@ static int ocfs2_rename(struct inode *old_dir,
 	if (old_dir_nlink != old_dir->i_nlink) {
 		if (!old_dir_bh) {
 			mlog(ML_ERROR, "need to change nlink for old dir "
-			     "%llu from %d to %d but bh is NULL!\n",
+			     "%llu from %u to %u but bh is NULL!\n",
 			     (unsigned long long)OCFS2_I(old_dir)->ip_blkno,
-			     (int)old_dir_nlink, old_dir->i_nlink);
+			     old_dir_nlink, old_dir->i_nlink);
 		} else {
 			struct ocfs2_dinode *fe;
 			status = ocfs2_journal_access_di(handle,
-- 
1.7.7.6
