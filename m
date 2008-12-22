From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:47:47 -0800
Subject: [Ocfs2-devel] [PATCH 06/56] ext3: Use sb_any_quota_loaded() instead
	of sb_any_quota_enabled()
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-7-git-send-email-mfasheh@suse.com>
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
 fs/ext3/super.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index f6c94f2..250ec53 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1035,8 +1035,7 @@ static int parse_options (char *options, struct super_block *sb,
 		case Opt_grpjquota:
 			qtype = GRPQUOTA;
 set_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    !sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR
 					"EXT3-fs: Cannot change journaled "
@@ -1075,8 +1074,7 @@ set_qf_name:
 		case Opt_offgrpjquota:
 			qtype = GRPQUOTA;
 clear_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR "EXT3-fs: Cannot change "
 					"journaled quota options when "
@@ -1095,8 +1093,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsv0:
 			qfmt = QFMT_VFS_V0;
 set_qf_format:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
 				printk(KERN_ERR "EXT3-fs: Cannot change "
 					"journaled quota options when "
@@ -1115,8 +1112,7 @@ set_qf_format:
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
1.5.6
