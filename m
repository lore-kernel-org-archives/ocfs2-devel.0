From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:17 2008
Subject: [Ocfs2-devel] [PATCH 06/18] ocfs2: make ocfs2_downconvert_thread()
	static
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 200bfae37a15e50e0f9aa5683958bdfc3fd55e05
Author: Adrian Bunk <bunk@kernel.org>
Date: Sun, 17 Feb 2008 10:20:38 +0200

This patch makes the needlessly global ocfs2_downconvert_thread()
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index f240079..7227af5 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3364,7 +3364,7 @@ static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super *osb)
 	return should_wake;
 }
 
-int ocfs2_downconvert_thread(void *arg)
+static int ocfs2_downconvert_thread(void *arg)
 {
 	int status = 0;
 	struct ocfs2_super *osb = arg;
-- 
1.5.3.4
