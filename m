From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:23:53 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix checking of return value of
	new_inode()
In-Reply-To: y
References: y
Message-ID: <12245234434014-git-send-email-jack@suse.cz>
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
index d5d808f..0372ef0 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -382,8 +382,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
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
