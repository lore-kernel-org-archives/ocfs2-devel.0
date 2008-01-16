From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:03 2008
Subject: [Ocfs2-devel] [PATCH 10/20] ocfs2: Filter -ENOSPC in mlog_errno()
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-11-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit ef9f86ceb63f2803c9aada249986b84d2f99c635
Author: Mark Fasheh <mfasheh@ca-build8.us.oracle.com>
Date: Mon, 19 Nov 2007 18:31:17 -0800

It's almost never worth printing in that situation and we keep forgetting to
manually filter it out.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/masklog.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 75cd877..4c32d1c 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -212,7 +212,7 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 #define mlog_errno(st) do {						\
 	int _st = (st);							\
 	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
-	    _st != AOP_TRUNCATED_PAGE)					\
+	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC)		\
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
 } while (0)
 
-- 
1.5.3.4
