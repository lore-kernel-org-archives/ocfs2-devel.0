From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  5 Sep 2008 11:29:14 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add xattr mount option in
	ocfs2_show_options()
Message-ID: <1220639354-32211-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch adds check for [no]user_xattr in ocfs2_show_options() that compiles
the list of all mount options.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/super.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2173169..d789c53 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -991,6 +991,11 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
 			   osb->osb_cluster_stack);
 
+	if (opts & OCFS2_MOUNT_NOUSERXATTR)
+		seq_printf(s, ",nouser_xattr");
+	else
+		seq_printf(s, ",user_xattr");
+
 	return 0;
 }
 
-- 
1.5.4.3
