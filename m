From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:31:35 +0100
Subject: [Ocfs2-devel] [PATCH 10/10] ext4: Add default allocation routines
	for quota structures
In-Reply-To: <1227623495-16708-9-git-send-email-jack@suse.cz>
References: <y> <1227623495-16708-1-git-send-email-jack@suse.cz>
	<1227623495-16708-2-git-send-email-jack@suse.cz>
	<1227623495-16708-3-git-send-email-jack@suse.cz>
	<1227623495-16708-4-git-send-email-jack@suse.cz>
	<1227623495-16708-5-git-send-email-jack@suse.cz>
	<1227623495-16708-6-git-send-email-jack@suse.cz>
	<1227623495-16708-7-git-send-email-jack@suse.cz>
	<1227623495-16708-8-git-send-email-jack@suse.cz>
	<1227623495-16708-9-git-send-email-jack@suse.cz>
Message-ID: <1227623495-16708-10-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
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
1.6.0.4
