From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:08 +0800
Subject: [Ocfs2-devel] [PATCH 25/34] ocfs2: remove NAMEI from symlink.c
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-25-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

No mlog(0,...) in symlink.c, so just remove NAMEI.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/symlink.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 56c1eeb..d3179a7 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -40,7 +40,6 @@
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 
-#define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
-- 
1.7.0.4
