From: Jan Kara <jack@suse.cz>
Date: Thu, 15 Oct 2009 14:54:05 +0200
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Set MS_POSIXACL on remount
In-Reply-To: <1255611245-27340-1-git-send-email-jack@suse.cz>
References: <1255611245-27340-1-git-send-email-jack@suse.cz>
Message-ID: <1255611245-27340-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have to set MS_POSIXACL on remount as well. Otherwise VFS
would not know we started supporting ACLs after remount and
thus ACLs would not work.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index d6a0d6a..8118043 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -703,6 +703,10 @@ unlock_osb:
 
 		if (!ocfs2_is_hard_readonly(osb))
 			ocfs2_set_journal_params(osb);
+
+		sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+			((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) ?
+							MS_POSIXACL : 0);
 	}
 out:
 	unlock_kernel();
-- 
1.6.0.2
