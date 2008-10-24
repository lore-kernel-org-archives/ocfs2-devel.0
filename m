From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:08:11 +0200
Subject: [Ocfs2-devel] [PATCH 18/29] mm: Export pdflush_operation()
In-Reply-To: <122488610212-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
Message-ID: <12248861043343-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCSF2 will need to queue up work for periodic syncing of quotas
among nodes in the cluster. pdflush() is good thread for this so
export it's controlling function so that OCFS2 can use it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/pdflush.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/pdflush.c b/mm/pdflush.c
index 0cbe0c6..1127615 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -223,6 +223,7 @@ int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
 
 	return ret;
 }
+EXPORT_SYMBOL(pdflush_operation);
 
 static void start_one_pdflush_thread(void)
 {
-- 
1.5.2.4
