From: Sage Weil <sage@newdream.net>
Date: Mon,  9 May 2011 21:43:34 -0700
Subject: [Ocfs2-devel] [PATCH 16/18] ocfs2: remove unnecessary dentry_unhash
	on rmdir/rename_dir
In-Reply-To: <1305002616-16782-1-git-send-email-sage@newdream.net>
References: <1305002616-16782-1-git-send-email-sage@newdream.net>
Message-ID: <1305002616-16782-17-git-send-email-sage@newdream.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro@ZenIV.linux.org.uk, hch@lst.de, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Ocfs2 has no issues with lingering references to unlinked directory inodes.

CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel at oss.oracle.com
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ocfs2/namei.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f3582a6..e5d738c 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -810,9 +810,6 @@ static int ocfs2_unlink(struct inode *dir,
 			   (unsigned long long)OCFS2_I(dir)->ip_blkno,
 			   (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	if (S_ISDIR(inode->i_mode))
-		dentry_unhash(dentry);
-
 	dquot_initialize(dir);
 
 	BUG_ON(dentry->d_parent->d_inode != dir);
@@ -1066,9 +1063,6 @@ static int ocfs2_rename(struct inode *old_dir,
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 	struct ocfs2_dir_lookup_result target_insert = { NULL, };
 
-	if (new_inode && S_ISDIR(new_inode->i_mode))
-		dentry_unhash(new_dentry);
-
 	/* At some point it might be nice to break this function up a
 	 * bit. */
 
-- 
1.7.1
