From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 13 Jul 2009 11:38:23 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] fixes a dangerous typo
Message-ID: <200907130341.n6D3fNob004447@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b730010..a10c989 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1397,7 +1397,7 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 		if (tmpret) {
 			mlog_errno(tmpret);
 			if (ret == 0)
-				tmpret = ret;
+				ret = tmpret;
 		}
 	}
 
-- 
1.6.2.5
