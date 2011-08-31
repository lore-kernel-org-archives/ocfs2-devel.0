From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 30 Aug 2011 18:55:38 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock open_lock immediately
In-Reply-To: <201108260250.p7Q2oQH9017484@acsmt357.oracle.com>
References: <201108260250.p7Q2oQH9017484@acsmt357.oracle.com>
Message-ID: <4E5D949A.4040802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Comments inlined.

BTW, how common place is this race in your testing? If you can
answer that, I would like to also know how you arrived at it.

On 08/25/2011 07:50 PM, Wengang Wang wrote:
> There is a race between 2(+) nodes that calls iput_final() on same inode.
> time sequence is like the following. The result is neither of the 2(+) node
> does real inode deletion work and the unlinked inode is left in orphandir.
>
> --------------------------------------
>
> node A                                  node B
>
> open_lock PR
>
>                                          open_LOCK PR
>
> .......
>
>                                           .......
>
> #in ocfs2_delete_inode()
> inode_lock EX
> #in ocfs2_query_inode_wipe
> try open_lock EX -->cant grant(B has PR)
> ignore the deletion
> inode_unlock EX
>
>                                          #in ocfs2_delete_inode()
>                                          inode_lock EX
>                                          #in ocfs2_query_inode_wipe
>                                          try open_lock EX -->can't grant(A has PR)
>                                          ignore the deletion
>                                          inode_unlock EX
>
> #in ocfs2_clear_inode()
> open_unlock EX
> drop open_lock
>
>                                           #in ocfs2_clear_inode()
>                                           open_unlock EX
>
> --------------------------------------
>
> The fix is to force dlm_unlock on open_lock within inode_lock. see
> comment embedded in patch.
>
> Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>

While I am still wrapping my head around this, I see no harm in releasing
the open_lock early. Afterall the inode is in MAYBE_ORPHANED state.

> ---
>   fs/ocfs2/dlmglue.c |    8 ++++++--
>   fs/ocfs2/inode.c   |   11 +++++++++++
>   2 files changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 7642d7c..f331310 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1752,12 +1752,16 @@ void ocfs2_open_unlock(struct inode *inode)
>   	if (ocfs2_mount_local(osb))
>   		goto out;
>
> -	if(lockres->l_ro_holders)
> +	if (lockres->l_ro_holders) {
>   		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
>   				     DLM_LOCK_PR);
> -	if(lockres->l_ex_holders)
> +		lockres->l_ro_holders = 0;
> +	}
> +	if (lockres->l_ex_holders) {
>   		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
>   				     DLM_LOCK_EX);
> +		lockres->l_ex_holders = 0;
> +	}


This bit looks incorrect. We cannot force these counts to zero.
We have to let dec_holders() to do that in cluster_unlock().


>   out:
>   	return;
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index b4c8bb6..390a6fc 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1052,6 +1052,17 @@ static void ocfs2_delete_inode(struct inode *inode)
>   	OCFS2_I(inode)->ip_flags |= OCFS2_INODE_DELETED;
>
>   bail_unlock_inode:
> +	/*
> +	 * since we don't take care of deleting the on disk inode any longer
> +	 * from now on, we must release the open_lock(dlm unlock) immediately
> +	 * within inode_lock. Otherwise, trying open_lock for EX from other node
> +	 * can fail if it comes before we release PR on open_lock later, so that
> +	 * both/all nodes think other node(s) is/are opening the inode thus
> +	 * neither/none of them do real inode deletion.
> +	 */
> +	ocfs2_open_unlock(inode);
> +	ocfs2_simple_drop_lockres(OCFS2_SB(inode->i_sb),
> +				&OCFS2_I(inode)->ip_open_lockres);
>   	ocfs2_inode_unlock(inode, 1);
>   	brelse(di_bh);
>

We have to make corresponding changes in ocfs2_drop_inode_locks()
and ocfs2_clear_inode().
