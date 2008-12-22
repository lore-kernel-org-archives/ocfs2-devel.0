From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:20 -0800
Subject: [Ocfs2-devel] [PATCH 39/56] ext4: Add default allocation routines
	for quota structures
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-40-git-send-email-mfasheh@suse.com>
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
 fs/ext4/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9e5a717..e6a5d74 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -803,7 +803,9 @@ static struct dquot_operations ext4_quota_operations = {
 	.acquire_dquot	= ext4_acquire_dquot,
 	.release_dquot	= ext4_release_dquot,
 	.mark_dirty	= ext4_mark_dquot_dirty,
-	.write_info	= ext4_write_info
+	.write_info	= ext4_write_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static struct quotactl_ops ext4_qctl_operations = {
-- 
1.5.6
