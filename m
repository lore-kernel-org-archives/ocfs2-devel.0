From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:31:33 +0100
Subject: [Ocfs2-devel] [PATCH 08/10] reiserfs: Add default allocation
	routines for quota structures
In-Reply-To: <1227623495-16708-7-git-send-email-jack@suse.cz>
References: <y> <1227623495-16708-1-git-send-email-jack@suse.cz>
	<1227623495-16708-2-git-send-email-jack@suse.cz>
	<1227623495-16708-3-git-send-email-jack@suse.cz>
	<1227623495-16708-4-git-send-email-jack@suse.cz>
	<1227623495-16708-5-git-send-email-jack@suse.cz>
	<1227623495-16708-6-git-send-email-jack@suse.cz>
	<1227623495-16708-7-git-send-email-jack@suse.cz>
Message-ID: <1227623495-16708-8-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
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
1.6.0.4
