From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:11 2008
Subject: [Ocfs2-devel] [PATCH 08/20] ocfs2: Reset journal parameters after
	s_mount_opt update
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e001e796e47d29c470de6c2cd36400e03c66118b
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 7 Nov 2007 14:21:45 -0800

Right now we're just setting them from the existing parameters, not the
new ones that a remount specified.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 43147c0..39cc000 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -442,14 +442,14 @@ unlock_osb:
 	}
 
 	if (!ret) {
-		if (!ocfs2_is_hard_readonly(osb))
-			ocfs2_set_journal_params(osb);
-
 		/* Only save off the new mount options in case of a successful
 		 * remount. */
 		osb->s_mount_opt = parsed_options.mount_opt;
 		osb->s_atime_quantum = parsed_options.atime_quantum;
 		osb->preferred_slot = parsed_options.slot;
+
+		if (!ocfs2_is_hard_readonly(osb))
+			ocfs2_set_journal_params(osb);
 	}
 out:
 	return ret;
-- 
1.5.3.4
