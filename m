From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:00 -0800
Subject: [Ocfs2-devel] [PATCH 19/56] mm: Export pdflush_operation()
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-20-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

OCSF2 will need to queue up work for periodic syncing of quotas
among nodes in the cluster. pdflush() is good thread for this so
export it's controlling function so that OCFS2 can use it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
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
1.5.6
