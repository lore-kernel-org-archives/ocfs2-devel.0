From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  8 10:49:57 2008
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: Enable localalloc for local mounts
In-Reply-To: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
References: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1202496577-21982-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 2fbe8d1ebe004425b4f7b8bba345623d2280be82 disabled localalloc
for local mounts. This caused issues as ocfs2 uses localalloc to
provide write locality. This patch enables localalloc for local mounts.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/localalloc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ff7f343..d036fe8 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -120,9 +120,6 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 
 	mlog_entry_void();
 
-	if (ocfs2_mount_local(osb))
-		goto bail;
-
 	if (osb->local_alloc_size == 0)
 		goto bail;
 
-- 
1.5.2.5
