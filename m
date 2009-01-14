From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Jan 2009 17:47:09 -0800
Subject: [Ocfs2-devel] [PATCH 04/15] ocfs2: Let inode be really deleted when
	ocfs2_mknod_locked() fails
In-Reply-To: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
References: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1231897640-31410-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jan Kara <jack@suse.cz>

Mainline commit b99835c1684918b9975851d71455c5c007d1715b

We forgot to set i_nlink to 0 when returning due to error from ocfs2_mknod_locked()
and thus inode was not properly released via ocfs2_delete_inode() (e.g. claimed
space was not released). Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/namei.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 0391f6e..c8206f9 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -490,8 +490,10 @@ leave:
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
1.5.6.3
