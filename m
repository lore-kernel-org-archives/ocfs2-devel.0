From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Apr 2010 18:00:31 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Make nointr a default mount option
In-Reply-To: <1271206831-3203-1-git-send-email-sunil.mushran@oracle.com>
References: <1271206831-3203-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1271206831-3203-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2 has never really supported intr. This patch acknowledges this reality
and makes nointr the default mount option. In a later patch, we intend to
support intr.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index dee0319..1a945ba 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1290,6 +1290,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 	mopt->slot = OCFS2_INVALID_SLOT;
 	mopt->localalloc_opt = OCFS2_DEFAULT_LOCAL_ALLOC_SIZE;
 	mopt->cluster_stack[0] = '\0';
+	mopt->mount_opt |= OCFS2_MOUNT_NOINTR;
 
 	if (!options) {
 		status = 1;
-- 
1.6.3.3
