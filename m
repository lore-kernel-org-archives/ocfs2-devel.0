From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:39:09 +0100
Subject: [Ocfs2-devel] [PATCH 19/27] mm: Export pdflush_operation()
In-Reply-To: <12254351592095-git-send-email-jack@suse.cz>
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
	<1225435159130-git-send-email-jack@suse.cz>
	<12254351592930-git-send-email-jack@suse.cz>
	<12254351592095-git-send-email-jack@suse.cz>
Message-ID: <12254351592812-git-send-email-jack@suse.cz>
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
index a0a14c4..13af84d 100644
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
