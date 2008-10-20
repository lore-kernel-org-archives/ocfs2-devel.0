From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:23:54 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Let inode be really deleted when
	ocfs2_mknod_locked() fails
In-Reply-To: y
References: y
Message-ID: <1224523443843-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We forgot to set i_nlink to 0 when returning due to error from ocfs2_mknod_locked()
and thus inode was not properly released via ocfs2_delete_inode() (e.g. claimed
space was not released). Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/namei.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 0372ef0..ff1a56d 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -495,8 +495,10 @@ leave:
 			brelse(*new_fe_bh);
 			*new_fe_bh = NULL;
 		}
-		if (inode)
+		if (inode) {
+			clear_nlink(inode);
 			iput(inode);
+		}
 	}
 
 	mlog_exit(status);
-- 
1.5.2.4
