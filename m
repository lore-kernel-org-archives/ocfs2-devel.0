From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 13 May 2011 12:02:58 -0700
Subject: [Ocfs2-devel] [PATCH 8/8] ocfs2/dlm: Target node death during
	resource migration leads to thread spin
In-Reply-To: <1305313378-31191-1-git-send-email-sunil.mushran@oracle.com>
References: <1305313378-31191-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1305313378-31191-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During resource migration, if the target node were to die, the thread doing
the migration spins until the target node is not removed from the domain map.
This patch slows the spin by making the thread wait for the recovery to kick in.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 1d2fe69..378a0ab 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2522,6 +2522,9 @@ fail:
 		res->state &= ~DLM_LOCK_RES_MIGRATING;
 		wake = 1;
 		spin_unlock(&res->spinlock);
+		if (dlm_is_host_down(ret))
+			dlm_wait_for_node_death(dlm, target,
+						DLM_NODE_DEATH_WAIT_MAX);
 		goto leave;
 	}
 
-- 
1.7.4.1
