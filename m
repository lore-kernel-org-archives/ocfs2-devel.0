From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:39:06 +0100
Subject: [Ocfs2-devel] [PATCH 16/27] quota: Update version number
In-Reply-To: <1225435158807-git-send-email-jack@suse.cz>
References: y <12254351572189-git-send-email-jack@suse.cz>
	<12254351571914-git-send-email-jack@suse.cz>
	<1225435157625-git-send-email-jack@suse.cz>
	<1225435157218-git-send-email-jack@suse.cz>
	<12254351571677-git-send-email-jack@suse.cz>
	<1225435157894-git-send-email-jack@suse.cz>
	<12254351582004-git-send-email-jack@suse.cz>
	<12254351581363-git-send-email-jack@suse.cz>
	<12254351582759-git-send-email-jack@suse.cz>
	<12254351582523-git-send-email-jack@suse.cz>
	<12254351583984-git-send-email-jack@suse.cz>
	<12254351582475-git-send-email-jack@suse.cz>
	<12254351583997-git-send-email-jack@suse.cz>
	<122543515838-git-send-email-jack@suse.cz>
	<1225435158192-git-send-email-jack@suse.cz>
	<1225435158807-git-send-email-jack@suse.cz>
Message-ID: <1225435159130-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Increase reported version number of quota support since quota core has changed
significantly. Also remove __DQUOT_NUM_VERSION__ since nobody uses it.

Signed-off-by: Jan Kara <jack@suse.cz>
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
1.5.2.4
