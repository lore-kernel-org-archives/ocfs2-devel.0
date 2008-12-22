From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:18 -0800
Subject: [Ocfs2-devel] [PATCH 37/56] reiserfs: Add default allocation
	routines for quota structures
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-38-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/reiserfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index a9b393a..c55651f 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -649,6 +649,8 @@ static struct dquot_operations reiserfs_quota_operations = {
 	.release_dquot = reiserfs_release_dquot,
 	.mark_dirty = reiserfs_mark_dquot_dirty,
 	.write_info = reiserfs_write_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static struct quotactl_ops reiserfs_qctl_operations = {
-- 
1.5.6
