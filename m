From: Jan Kara <jack@suse.cz>
Date: Wed, 28 Feb 2018 12:17:57 +0100
Subject: [Ocfs2-devel] [PATCH 1/6] Linux 4.16-rc3
In-Reply-To: <20180228111802.23967-1-jack@suse.cz>
References: <20180228111802.23967-1-jack@suse.cz>
Message-ID: <20180228111802.23967-2-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Linus Torvalds <torvalds@linux-foundation.org>

---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index d9cf3a40eda9..659a7780aeb3 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@
 VERSION = 4
 PATCHLEVEL = 16
 SUBLEVEL = 0
-EXTRAVERSION = -rc2
+EXTRAVERSION = -rc3
 NAME = Fearless Coyote
 
 # *DOCUMENTATION*
-- 
2.13.6
