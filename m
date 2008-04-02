From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:15:08 -0700
Subject: [Ocfs2-devel] [PATCH 58/62] ocfs2: Improve rename locking
In-Reply-To: <12071674382558-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
	<12071674103432-git-send-email-mfasheh@suse.com>
	<1207167413855-git-send-email-mfasheh@suse.com>
	<12071674151752-git-send-email-mfasheh@suse.com>
	<12071674171596-git-send-email-mfasheh@suse.com>
	<12071674193441-git-send-email-mfasheh@suse.com>
	<12071674213882-git-send-email-mfasheh@suse.com>
	<12071674242631-git-send-email-mfasheh@suse.com>
	<1207167425415-git-send-email-mfasheh@suse.com>
	<1207167427753-git-send-email-mfasheh@suse.com>
	<12071674291040-git-send-email-mfasheh@suse.com>
	<12071674312495-git-send-email-mfasheh@suse.com>
	<12071674333467-git-send-email-mfasheh@suse.com>
	<12071674361985-git-send-email-mfasheh@suse.com>
	<12071674382558-git-send-email-mfasheh@suse.com>
Message-ID: <12071674402193-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>

From: Jan Kara <jack@suse.cz>

ocfs2_rename() was being too aggressive with the rename lock - we only need
it for certain forms of directory rename.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index ab5a227..d5d808f 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -997,7 +997,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	 *
 	 * And that's why, just like the VFS, we need a file system
 	 * rename lock. */
-	if (old_dentry != new_dentry) {
+	if (old_dir != new_dir && S_ISDIR(old_inode->i_mode)) {
 		status = ocfs2_rename_lock(osb);
 		if (status < 0) {
 			mlog_errno(status);
-- 
1.5.4.1
