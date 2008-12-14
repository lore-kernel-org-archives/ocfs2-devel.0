From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 15 Dec 2008 06:03:41 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/quota: Add QUOTA in mlog_attribute.
Message-ID: <1229292221-5147-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A new mlog mask has to be added into mlog_attribute before it can
be really used in mlog. ML_QUOTA is only added in masklog.h, so
add it to the array to enable it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/cluster/masklog.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index d8a0cb9..96df541 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -110,6 +110,7 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(QUORUM),
 	define_mask(EXPORT),
 	define_mask(XATTR),
+	define_mask(QUOTA),
 	define_mask(ERROR),
 	define_mask(NOTICE),
 	define_mask(KTHREAD),
-- 
1.5.4.GIT
