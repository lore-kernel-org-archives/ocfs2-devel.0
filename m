From: dann frazier <dann.frazier@canonical.com>
Date: Thu, 18 Nov 2010 15:03:09 -0700
Subject: [Ocfs2-devel] [PATCH] [OCFS2] ocfs2_connection_find() returns
	pointer to bad structure
Message-ID: <1290117789-3915-1-git-send-email-dann.frazier@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org

If ocfs2_live_connection_list is empty, ocfs2_connection_find() will return
a pointer to the LIST_HEAD, cast as a ocfs2_live_connection. This can cause
an oops when ocfs2_control_send_down() dereferences c->oc_conn:

Call Trace:
  [<ffffffffa00c2a3c>] ocfs2_control_message+0x28c/0x2b0 [ocfs2_stack_user]
  [<ffffffffa00c2a95>] ocfs2_control_write+0x35/0xb0 [ocfs2_stack_user]
  [<ffffffff81143a88>] vfs_write+0xb8/0x1a0
  [<ffffffff8155cc13>] ? do_page_fault+0x153/0x3b0
  [<ffffffff811442f1>] sys_write+0x51/0x80
  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b

Fix by explicitly returning NULL if no match is found.

Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 fs/ocfs2/stack_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 252e7c8..a5ebe42 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -190,7 +190,7 @@ static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
 			return c;
 	}
 
-	return c;
+	return NULL;
 }
 
 /*
-- 
1.7.2.3
