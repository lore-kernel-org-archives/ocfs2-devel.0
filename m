From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 7 Sep 2011 11:04:36 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock open_lock immediately
In-Reply-To: <201108260250.p7Q2oQH9017484@acsmt357.oracle.com>
References: <201108260250.p7Q2oQH9017484@acsmt357.oracle.com>
Message-ID: <20110907180435.GB17687@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 26, 2011 at 10:50:27AM +0800, Wengang Wang wrote:
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
>                                         open_LOCK PR
> 

	Who is taking the open lock here?  Or are you presuming a
long-held open lock (eg, back when you untarred stuff)?

> .......
> 
>                                          .......
> 
> #in ocfs2_delete_inode()
> inode_lock EX
> #in ocfs2_query_inode_wipe
> try open_lock EX -->cant grant(B has PR)
> ignore the deletion
> inode_unlock EX
> 
>                                         #in ocfs2_delete_inode() 
>                                         inode_lock EX
>                                         #in ocfs2_query_inode_wipe
>                                         try open_lock EX -->can't grant(A has PR)
>                                         ignore the deletion
>                                         inode_unlock EX
> 
> #in ocfs2_clear_inode()
> open_unlock EX
> drop open_lock
> 
>                                          #in ocfs2_clear_inode()
>                                          open_unlock EX
> 
> --------------------------------------
> 
> The fix is to force dlm_unlock on open_lock within inode_lock. see
> comment embedded in patch.

	Why wouldn't the orphan scan catch this?

> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index b4c8bb6..390a6fc 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1052,6 +1052,17 @@ static void ocfs2_delete_inode(struct inode *inode)
>  	OCFS2_I(inode)->ip_flags |= OCFS2_INODE_DELETED;
>  
>  bail_unlock_inode:
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
> +				  &OCFS2_I(inode)->ip_open_lockres);

	How do you know that you can ocfs2_simple_drop_lockres()?  Can't
Another code path have a reference on the inode?

Joel

-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

			http://www.jlbec.org/
			jlbec at evilplan.org
