From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:15:07 -0700
Subject: [Ocfs2-devel] [PATCH 57/62] fs/ocfs2/aops.c: test for IS_ERR rather
	than 0
In-Reply-To: <12071674361985-git-send-email-mfasheh@suse.com>
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
Message-ID: <12071674382558-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Julia Lawall <julia@diku.dk>

From: Julia Lawall <julia@diku.dk>

The function ocfs2_start_trans always returns either a valid pointer or a
value made with ERR_PTR, so its result should be tested with IS_ERR, not
with a test for 0.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/aops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 90383ed..17964c0 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -467,11 +467,11 @@ handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
 							 unsigned to)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	handle_t *handle = NULL;
+	handle_t *handle;
 	int ret = 0;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (!handle) {
+	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
@@ -487,7 +487,7 @@ handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
 	}
 out:
 	if (ret) {
-		if (handle)
+		if (!IS_ERR(handle))
 			ocfs2_commit_trans(osb, handle);
 		handle = ERR_PTR(ret);
 	}
-- 
1.5.4.1
