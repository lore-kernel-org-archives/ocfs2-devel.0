From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:19 -0800
Subject: [Ocfs2-devel] [PATCH 38/56] ext3: Add default allocation routines
	for quota structures
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-39-git-send-email-mfasheh@suse.com>
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
 fs/ext3/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 250ec53..c22d014 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -713,7 +713,9 @@ static struct dquot_operations ext3_quota_operations = {
 	.acquire_dquot	= ext3_acquire_dquot,
 	.release_dquot	= ext3_release_dquot,
 	.mark_dirty	= ext3_mark_dquot_dirty,
-	.write_info	= ext3_write_info
+	.write_info	= ext3_write_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static struct quotactl_ops ext3_qctl_operations = {
-- 
1.5.6
