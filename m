From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:31:34 +0100
Subject: [Ocfs2-devel] [PATCH 09/10] ext3: Add default allocation routines
	for quota structures
In-Reply-To: <1227623495-16708-8-git-send-email-jack@suse.cz>
References: <y> <1227623495-16708-1-git-send-email-jack@suse.cz>
	<1227623495-16708-2-git-send-email-jack@suse.cz>
	<1227623495-16708-3-git-send-email-jack@suse.cz>
	<1227623495-16708-4-git-send-email-jack@suse.cz>
	<1227623495-16708-5-git-send-email-jack@suse.cz>
	<1227623495-16708-6-git-send-email-jack@suse.cz>
	<1227623495-16708-7-git-send-email-jack@suse.cz>
	<1227623495-16708-8-git-send-email-jack@suse.cz>
Message-ID: <1227623495-16708-9-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fee8705..abed9f9 100644
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
1.6.0.4
