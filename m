From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:47:48 -0800
Subject: [Ocfs2-devel] [PATCH 07/56] ext4: Use sb_any_quota_loaded() instead
	of sb_any_quota_enabled()
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-8-git-send-email-mfasheh@suse.com>
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
 fs/ext4/super.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e4a241c..9e5a717 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1142,8 +1142,7 @@ static int parse_options(char *options, struct super_block *sb,
 		case Opt_grpjquota:
 			qtype = GRPQUOTA;
 set_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    !sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR
 				       "EXT4-fs: Cannot change journaled "
@@ -1182,8 +1181,7 @@ set_qf_name:
 		case Opt_offgrpjquota:
 			qtype = GRPQUOTA;
 clear_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR "EXT4-fs: Cannot change "
 					"journaled quota options when "
@@ -1202,8 +1200,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsv0:
 			qfmt = QFMT_VFS_V0;
 set_qf_format:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
 				printk(KERN_ERR "EXT4-fs: Cannot change "
 					"journaled quota options when "
@@ -1222,7 +1219,7 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt, GRPQUOTA);
 			break;
 		case Opt_noquota:
-			if (sb_any_quota_enabled(sb)) {
+			if (sb_any_quota_loaded(sb)) {
 				printk(KERN_ERR "EXT4-fs: Cannot change quota "
 					"options when quota turned on.\n");
 				return 0;
-- 
1.5.6
