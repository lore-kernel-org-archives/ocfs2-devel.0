From: Jan Kara <jack@suse.cz>
Date: Mon, 12 Jan 2009 23:20:33 +0100
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Remove bogus link count decrement
In-Reply-To: <1231798833-6850-5-git-send-email-jack@suse.cz>
References: <y> <1231798833-6850-1-git-send-email-jack@suse.cz>
	<1231798833-6850-2-git-send-email-jack@suse.cz>
	<1231798833-6850-3-git-send-email-jack@suse.cz>
	<1231798833-6850-4-git-send-email-jack@suse.cz>
	<1231798833-6850-5-git-send-email-jack@suse.cz>
Message-ID: <1231798833-6850-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_unlink() we decremented i_nlink three times for directories (instead
of just two times). This actually did not matter because we have
ocfs2_drop_inode() which decides whether the inode should be deleted based on a
flag but it's at least surprising for a link count to wrap...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/namei.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 084aba8..892d5e7 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -888,8 +888,6 @@ static int ocfs2_unlink(struct inode *dir,
 	}
 
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	if (S_ISDIR(inode->i_mode))
-		drop_nlink(dir);
 
 	status = ocfs2_mark_inode_dirty(handle, dir, parent_node_bh);
 	if (status < 0) {
-- 
1.6.0.2
