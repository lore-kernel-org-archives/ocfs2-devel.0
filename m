From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Sep 2008 15:01:20 -0700
Subject: [Ocfs2-devel] [PATCH 39/39] ocfs2: Add xattr mount option in
	ocfs2_show_options()
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Message-ID: <1222293680-15451-40-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

Patch adds check for [no]user_xattr in ocfs2_show_options() that completes
the list of all mount options.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/super.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 39f6238..6b4b86e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1010,6 +1010,11 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
 			   osb->osb_cluster_stack);
 
+	if (opts & OCFS2_MOUNT_NOUSERXATTR)
+		seq_printf(s, ",nouser_xattr");
+	else
+		seq_printf(s, ",user_xattr");
+
 	if (opts & OCFS2_MOUNT_INODE64)
 		seq_printf(s, ",inode64");
 
-- 
1.5.4.5
