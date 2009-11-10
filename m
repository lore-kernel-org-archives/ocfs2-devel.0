From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 18:00:07 -0800
Subject: [Ocfs2-devel] [PATCH 04/10] ocfs2: Enable CONFIG_OCFS2_FS_POSIX_ACL
In-Reply-To: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257818413-32014-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index e997fe4..efa7f57 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -34,6 +34,8 @@ EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
 
 EXTRA_CFLAGS += -DCONFIG_OCFS2_FS_STATS
 
+EXTRA_CFLAGS += -DCONFIG_OCFS2_FS_POSIX_ACL
+
 ifdef NO_DELAYED_WORK_STRUCT
 EXTRA_CFLAGS += -DNO_DELAYED_WORK_STRUCT
 endif
-- 
1.5.6.5
