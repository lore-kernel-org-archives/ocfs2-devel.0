From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 17:14:22 2008
Subject: [Ocfs2-devel] [PATCH 08/10] ocfs2: Change mlog_bug_on to BUG_ON in
	ocfs2_lockid.h
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204766038-31721-9-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

The masklog code is in the o2cb stack, but ocfs2_lockid.h now needs to
be included by the user stack.  The BUG() in ocfs2_lock_type_string()
does not need masklog support, so change it to a regular BUG_ON().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2_lockid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index 86f3e37..82c200f 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -100,7 +100,7 @@ static char *ocfs2_lock_type_strings[] = {
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
 {
 #ifdef __KERNEL__
-	mlog_bug_on_msg(type >= OCFS2_NUM_LOCK_TYPES, "%d\n", type);
+	BUG_ON(type >= OCFS2_NUM_LOCK_TYPES);
 #endif
 	return ocfs2_lock_type_strings[type];
 }
-- 
1.5.3.8
