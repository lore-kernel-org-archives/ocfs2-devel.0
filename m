From: Tristan Ye <tristan.ye@oracle.com>
Date: Wed,  1 Jun 2011 16:15:18 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add readonly check in
	ocfs2_quota_on().
Message-ID: <1306916118-27081-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Enabling quota on a readonly ocfs2 fs caused a 'NULL pointer dereference' in
dquot_enable(), a very straightforward fix is to check readonly at the very
beginning of ocfs2_quota_on(), which calls dquot_enable().

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 029c4cd..3cade2a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -995,6 +995,10 @@ static int ocfs2_quota_on(struct super_block *sb, int type, int format_id)
 	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
 		return -EINVAL;
 
+	if (ocfs2_is_hard_readonly(OCFS2_SB(sb))) {
+		return -EROFS;
+	}
+
 	return dquot_enable(sb_dqopt(sb)->files[type], type,
 			    format_id, DQUOT_LIMITS_ENABLED);
 }
-- 
1.5.5
