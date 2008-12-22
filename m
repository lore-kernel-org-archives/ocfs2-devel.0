From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:47:57 -0800
Subject: [Ocfs2-devel] [PATCH 16/56] quota: Update version number
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-17-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

Increase reported version number of quota support since quota core has changed
significantly. Also remove __DQUOT_NUM_VERSION__ since nobody uses it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 include/linux/quota.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/quota.h b/include/linux/quota.h
index 6d98885..ec82beb 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -36,8 +36,7 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
-#define __DQUOT_VERSION__	"dquot_6.5.1"
-#define __DQUOT_NUM_VERSION__	6*10000+5*100+1
+#define __DQUOT_VERSION__	"dquot_6.5.2"
 
 #define MAXQUOTAS 2
 #define USRQUOTA  0		/* element used for user quotas */
-- 
1.5.6
