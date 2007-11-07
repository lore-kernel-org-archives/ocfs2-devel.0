From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Nov  7 14:42:50 2007
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Reset journal parameters after
	s_mount_opt update
Message-ID: <20071107224248.GE28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Right now we're just setting them from the existing parameters, not the
new ones that a remount specified.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index be562ac..5ee7754 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -438,14 +438,14 @@ unlock_osb:
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
1.5.0.6
