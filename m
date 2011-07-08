From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 8 Jul 2011 10:28:58 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: drop and retake
 orphan_dir.i_mutex in ocfs2_recover_orphans
In-Reply-To: <4E162991.4090505@oracle.com>
References: <201107060539.p665dq41013976@acsmt357.oracle.com>
	<4E162991.4090505@oracle.com>
Message-ID: <20110708022858.GD3013@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-07-07 14:48, Sunil Mushran wrote:
> This is too hacky for mainline. May work as a temp fix only.

:D

> 
> This assumes that we only need to recover orphans in our own slot.
> If that is the case, then if nothing else, we can remove the orphan
> scan lock. We added the lock so as to ensure all nodes get a chance
> to replay it. If all nodes are doing there own, they why do we need
> the lock.

Actually, for live nodes, yes we only recover our own slot. For the
dead slots, we need the orphan scan lock.

> 
> On 07/05/2011 10:11 PM, Wengang Wang wrote:
> >drop and retake orphan_dir.i_mutex in ocfs2_recover_orphans.
> >
> >Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> >---
> >  fs/ocfs2/journal.c |   40 ++++++++++++++++++++++++++++++++++------
> >  1 files changed, 34 insertions(+), 6 deletions(-)
> >
> >diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> >index 7994823..e3b8340 100644
> >--- a/fs/ocfs2/journal.c
> >+++ b/fs/ocfs2/journal.c
> >@@ -56,6 +56,7 @@
> >  DEFINE_SPINLOCK(trans_inc_lock);
> >
> >  #define ORPHAN_SCAN_SCHEDULE_TIMEOUT 300000
> >+#define ORPHAN_SCAN_ITEMS_PER_LOOP 200
> >
> >  static int ocfs2_force_read_journal(struct inode *inode);
> >  static int ocfs2_recover_node(struct ocfs2_super *osb,
> >@@ -1949,6 +1950,8 @@ void ocfs2_orphan_scan_start(struct ocfs2_super *osb)
> >  struct ocfs2_orphan_filldir_priv {
> >  	struct inode		*head;
> >  	struct ocfs2_super	*osb;
> >+	int			count;
> >+	int			for_live:1;
> >  };
> >
> >  static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
> >@@ -1957,6 +1960,9 @@ static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
> >  	struct ocfs2_orphan_filldir_priv *p = priv;
> >  	struct inode *iter;
> >
> >+	if (p->for_live)
> >+		BUG_ON(p->count>  ORPHAN_SCAN_ITEMS_PER_LOOP);
> >+
> >  	if (name_len == 1&&  !strncmp(".", name, 1))
> >  		return 0;
> >  	if (name_len == 2&&  !strncmp("..", name, 2))
> >@@ -1974,20 +1980,38 @@ static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
> >  	OCFS2_I(iter)->ip_next_orphan = p->head;
> >  	p->head = iter;
> >
> >+	/*
> >+	 * we fill at most ORPHAN_SCAN_ITEMS_PER_LOOP direntry in a loop with
> >+	 * the orphan_dir.i_mutex locked.
> >+	 */
> >+	if (p->for_live) {
> >+		if (++p->count == ORPHAN_SCAN_ITEMS_PER_LOOP)
> >+			return -EAGAIN;
> >+	}
> >  	return 0;
> >  }
> >
> >  static int ocfs2_queue_orphans(struct ocfs2_super *osb,
> >  			       int slot,
> >-			       struct inode **head)
> >+			       struct inode **head,
> >+			       loff_t *pos)
> >  {
> >  	int status;
> >  	struct inode *orphan_dir_inode = NULL;
> >  	struct ocfs2_orphan_filldir_priv priv;
> >-	loff_t pos = 0;
> >+	unsigned int node_num;
> >
> >  	priv.osb = osb;
> >  	priv.head = *head;
> >+	priv.count = 0;
> >+
> >+	spin_lock(&osb->osb_lock);
> >+	status = ocfs2_slot_to_node_num_locked(osb, slot,&node_num);
> >+	spin_unlock(&osb->osb_lock);
> >+	if (!status&&  node_num == osb->node_num)
> >+		priv.for_live = true;
> >+	else
> >+		priv.for_live = false;
> 
> You cannot return (save) pos and yet lookup the slotnum again. That's
> not the right order. Too hackish. All these functions will need to be
> re-prototyped if your approach is what we use.

Yes, I also think it's hackish.
But I don't have a better fix so far. While though it's hackish, it works.
It is just like ocfs2_readdir(). If a new direntry is added before the
position, we just leave there for next run; If one is added after the
possition, we take it; If a diretry is removed, I means the file/inode
is freed, OK; It's safe.
If we restart from offset 0, in case all the inodes in the first 200 or
whatever other limit are not freed and won't be freed(say still opened),
we are in bad loops. 

> 
> >
> >  	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
> >  						       ORPHAN_DIR_SYSTEM_INODE,
> >@@ -2005,9 +2029,9 @@ static int ocfs2_queue_orphans(struct ocfs2_super *osb,
> >  		goto out;
> >  	}
> >
> >-	status = ocfs2_dir_foreach(orphan_dir_inode,&pos,&priv,
> >+	status = ocfs2_dir_foreach(orphan_dir_inode, pos,&priv,
> >  				   ocfs2_orphan_filldir);
> >-	if (status) {
> >+	if (status&&  status != -EAGAIN) {
> >  		mlog_errno(status);
> >  		goto out_cluster;
> >  	}
> >@@ -2083,16 +2107,18 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
> >  	struct inode *inode = NULL;
> >  	struct inode *iter;
> >  	struct ocfs2_inode_info *oi;
> >+	loff_t pos = 0;
> >
> >  	trace_ocfs2_recover_orphans(slot);
> >
> >+cnt_scan:
> >  	ocfs2_mark_recovering_orphan_dir(osb, slot);
> >-	ret = ocfs2_queue_orphans(osb, slot,&inode);
> >+	ret = ocfs2_queue_orphans(osb, slot,&inode,&pos);
> >  	ocfs2_clear_recovering_orphan_dir(osb, slot);
> 
> The slot is being marked and cleared multiple times. I am unsure what the
> ramifications are, but it does not look right.

I will look at this more...

thanks,
wengang.
