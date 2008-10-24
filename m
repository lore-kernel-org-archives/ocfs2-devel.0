From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:08:14 +0200
Subject: [Ocfs2-devel] [PATCH 21/29] ocfs2: Fix checking of return value of
	new_inode()
In-Reply-To: <122488610212-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
Message-ID: <12248861041207-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

new_inode() does not return ERR_PTR() but NULL in case of failure. Correct
checking of the return value.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 485a6aa..f594f30 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -378,8 +378,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
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
1.5.2.4
