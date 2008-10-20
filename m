From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:23:39 +0200
Subject: [Ocfs2-devel] [PATCH] ext3: Use sb_any_quota_loaded() instead of
	sb_any_quota_enabled()
In-Reply-To: y
References: y
Message-ID: <12245234411771-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index f38a5af..ff5b789 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1018,8 +1018,7 @@ static int parse_options (char *options, struct super_block *sb,
 		case Opt_grpjquota:
 			qtype = GRPQUOTA;
 set_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    !sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR
 					"EXT3-fs: Cannot change journaled "
@@ -1058,8 +1057,7 @@ set_qf_name:
 		case Opt_offgrpjquota:
 			qtype = GRPQUOTA;
 clear_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR "EXT3-fs: Cannot change "
 					"journaled quota options when "
@@ -1078,8 +1076,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsv0:
 			qfmt = QFMT_VFS_V0;
 set_qf_format:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
 				printk(KERN_ERR "EXT3-fs: Cannot change "
 					"journaled quota options when "
@@ -1098,8 +1095,7 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt, GRPQUOTA);
 			break;
 		case Opt_noquota:
-			if (sb_any_quota_enabled(sb) ||
-			    sb_any_quota_suspended(sb)) {
+			if (sb_any_quota_loaded(sb)) {
 				printk(KERN_ERR "EXT3-fs: Cannot change quota "
 					"options when quota turned on.\n");
 				return 0;
-- 
1.5.2.4
