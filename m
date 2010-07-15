From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 15 Jul 2010 14:03:11 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove BUG_ON in a rare case
In-Reply-To: <201007141440.o6EEeWod016015@rcsinet13.oracle.com>
References: <201007141440.o6EEeWod016015@rcsinet13.oracle.com>
Message-ID: <20100715210311.GB29283@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 14, 2010 at 10:38:21PM +0800, Wengang Wang wrote:
> For migration, we are waiting for DLM_LOCK_RES_MIGRATING flag to be set
> before sending DLM_MIG_LOCKRES_MSG message to the target. We are using
> dlm_migration_can_proceed() for that purpose. while, dlm_migration_can_proceed()
> also returns "go ahead" if target node is down. In this rare case, the
> DLM_LOCK_RES_MIGRATING maybe is not set yet. Remove the BUG_ON() in this case.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

	This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"The whole problem with the world is that fools and fanatics are always
 so certain of themselves, and wiser people so full of doubts."
	- Bertrand Russell

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
