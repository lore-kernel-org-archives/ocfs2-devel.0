From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Jan 2009 17:47:07 -0800
Subject: [Ocfs2-devel] [PATCH 02/15] ocfs2: Fix checking of return value of
	new_inode()
In-Reply-To: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
References: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1231897640-31410-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jan Kara <jack@suse.cz>

Mainline commit 87cfa004321c62aec681713ea48e0b846336d9f4

new_inode() does not return ERR_PTR() but NULL in case of failure. Correct
checking of the return value.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 7d8bed4..0391f6e 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -377,8 +377,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	}
 
 	inode = new_inode(dir->i_sb);
-	if (IS_ERR(inode)) {
-		status = PTR_ERR(inode);
+	if (!inode) {
+		status = -ENOMEM;
 		mlog(ML_ERROR, "new_inode failed!\n");
 		goto leave;
 	}
-- 
1.5.6.3
