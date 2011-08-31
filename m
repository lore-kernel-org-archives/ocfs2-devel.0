From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 31 Aug 2011 10:51:55 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock open_lock immediately
In-Reply-To: <4E5D949A.4040802@oracle.com>
References: <201108260250.p7Q2oQH9017484@acsmt357.oracle.com>
	<4E5D949A.4040802@oracle.com>
Message-ID: <20110831025154.GA5342@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

thanks for you review!

On 11-08-30 18:55, Sunil Mushran wrote:
> Comments inlined.
> 
> BTW, how common place is this race in your testing? If you can
> answer that, I would like to also know how you arrived at it.
The test case is simple:
in a three-node cluster, 
1) node A copies kernel tree to ocfs2 volume
2) node B and C keeps "ls -R" the tree which is under copying
3) after the copy finished, remove the whole tree by "rm -rf xxx" while
   Node B and C are still "ls -R"ing.
4) stop the "ls -R" on node B/C when "rm" on node A is finished.
5) umount all three nodes.
There are entries left in orphandirs(could for all slots).
Actually copying whole is time consuming, I can hit the problem when copied part
of the kernel tree.

I confirmed that the cause is "remotely opened" by printing logs.
log showed that all the three nodes think "there is other node(s) still opening the inode",
so they don't do dinode deletion.

> On 08/25/2011 07:50 PM, Wengang Wang wrote:
> >There is a race between 2(+) nodes that calls iput_final() on same inode.
> >time sequence is like the following. The result is neither of the 2(+) node
> >does real inode deletion work and the unlinked inode is left in orphandir.
> >
> >--------------------------------------
> >
> >node A                                  node B
> >
> >open_lock PR
> >
> >                                         open_LOCK PR
> >
> >.......
> >
> >                                          .......
> >
> >#in ocfs2_delete_inode()
> >inode_lock EX
> >#in ocfs2_query_inode_wipe
> >try open_lock EX -->cant grant(B has PR)
> >ignore the deletion
> >inode_unlock EX
> >
> >                                         #in ocfs2_delete_inode()
> >                                         inode_lock EX
> >                                         #in ocfs2_query_inode_wipe
> >                                         try open_lock EX -->can't grant(A has PR)
> >                                         ignore the deletion
> >                                         inode_unlock EX
> >
> >#in ocfs2_clear_inode()
> >open_unlock EX
> >drop open_lock
> >
> >                                          #in ocfs2_clear_inode()
> >                                          open_unlock EX
> >
> >--------------------------------------
> >
> >The fix is to force dlm_unlock on open_lock within inode_lock. see
> >comment embedded in patch.
> >
> >Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> 
> While I am still wrapping my head around this, I see no harm in releasing
> the open_lock early. Afterall the inode is in MAYBE_ORPHANED state.
> 
> >---
> >  fs/ocfs2/dlmglue.c |    8 ++++++--
> >  fs/ocfs2/inode.c   |   11 +++++++++++
> >  2 files changed, 17 insertions(+), 2 deletions(-)
> >
> >diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> >index 7642d7c..f331310 100644
> >--- a/fs/ocfs2/dlmglue.c
> >+++ b/fs/ocfs2/dlmglue.c
> >@@ -1752,12 +1752,16 @@ void ocfs2_open_unlock(struct inode *inode)
> >  	if (ocfs2_mount_local(osb))
> >  		goto out;
> >
> >-	if(lockres->l_ro_holders)
> >+	if (lockres->l_ro_holders) {
> >  		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
> >  				     DLM_LOCK_PR);
> >-	if(lockres->l_ex_holders)
> >+		lockres->l_ro_holders = 0;
> >+	}
> >+	if (lockres->l_ex_holders) {
> >  		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
> >  				     DLM_LOCK_EX);
> >+		lockres->l_ex_holders = 0;
> >+	}
> 
> 
> This bit looks incorrect. We cannot force these counts to zero.
> We have to let dec_holders() to do that in cluster_unlock().

OK, good point. Seems we don't need force them to zero since
cluster_unlock() takes care of it.

> 
> 
> >  out:
> >  	return;
> >diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> >index b4c8bb6..390a6fc 100644
> >--- a/fs/ocfs2/inode.c
> >+++ b/fs/ocfs2/inode.c
> >@@ -1052,6 +1052,17 @@ static void ocfs2_delete_inode(struct inode *inode)
> >  	OCFS2_I(inode)->ip_flags |= OCFS2_INODE_DELETED;
> >
> >  bail_unlock_inode:
> >+	/*
> >+	 * since we don't take care of deleting the on disk inode any longer
> >+	 * from now on, we must release the open_lock(dlm unlock) immediately
> >+	 * within inode_lock. Otherwise, trying open_lock for EX from other node
> >+	 * can fail if it comes before we release PR on open_lock later, so that
> >+	 * both/all nodes think other node(s) is/are opening the inode thus
> >+	 * neither/none of them do real inode deletion.
> >+	 */
> >+	ocfs2_open_unlock(inode);
> >+	ocfs2_simple_drop_lockres(OCFS2_SB(inode->i_sb),
> >+				&OCFS2_I(inode)->ip_open_lockres);
> >  	ocfs2_inode_unlock(inode, 1);
> >  	brelse(di_bh);
> >
> 
> We have to make corresponding changes in ocfs2_drop_inode_locks()
> and ocfs2_clear_inode().
Yes, I have also checked into the two functions.
I found there is no bad effect to call ocfs2_open_unlock() and
ocfs2_simple_drop_lockres() on openlock twice.

when ocfs2_inode_unlock() is called in ocfs2_clear_inode again, the holders
should be zero already(in the first call), so no confusing to dlm unlock. 
when ocfs2_mark_lockres_freeing() is called for the second time, the openlock
should be with OCFS2_LOCK_FREEING flag already, I don't see problem here. 
when ocfs2_drop_lock() is called for the second time, flag OCFS2_LOCK_ATTACHED
should be cleared already(in first call), so no problem either.
Maybe I missed something?

Simply removing ocfs2_open_unlock/ocfs2_mark_lockres_freeing from
ocfs2_clear_inode() and ocfs2_drop_lock from ocfs2_drop_inode_locks()
respectively can introduce problem:

For ((inode->i_nlink &&
     !(OCFS2_I(inode)->ip_flags &OCFS2_INODE_MAYBE_ORPHANED))
case, we still need to call ocfs2_open_unlock() and
ocfs2_mark_lockres_freeing() against openlock in ocfs2_clear_inode()
and call ocfs2_drop_lock() in ocfs2_drop_inode_locks().

Or do you mean we should add a flag to indicate whether we should do those
or not?

thanks,
wengang.
