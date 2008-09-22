From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 22 Sep 2008 14:18:46 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add spin lock when accessing
 inode->i_nlink.
In-Reply-To: <200809220915.m8M9F1CR004450@wengang.cn.oracle.com>
References: <200809220915.m8M9F1CR004450@wengang.cn.oracle.com>
Message-ID: <48D80BB6.9080308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

NAK

Firstly ip_lock does not protect inode. Secondly, the field is
protected by inode_lock. Follow the code:

iput (inode_lock taken) => iput_final ==> ocfs2_drop_inode (inode_lock 
still held).

void iput(struct inode *inode)
{
....
                if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
                        iput_final(inode);
}

static inline void iput_final(struct inode *inode)
{
        struct super_operations *op = inode->i_sb->s_op;
        void (*drop)(struct inode *) = generic_drop_inode;

        if (op && op->drop_inode)
                drop = op->drop_inode;
        drop(inode);
}


wangang wang wrote:
> add spin lock when accessing inode->i_nlink in ocfs2_drop_inode().
>
> the patch is against 1.2 svn.
>
> Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
> --
> Index: fs/ocfs2/inode.c
> ===================================================================
> --- fs/ocfs2/inode.c	(revision 3101)
> +++ fs/ocfs2/inode.c	(working copy)
> @@ -991,10 +991,12 @@
>  	/* Testing ip_orphaned_slot here wouldn't work because we may
>  	 * not have gotten a delete_inode vote from any other nodes
>  	 * yet. */
> +	spin_lock(&oi->ip_lock);
>  	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED) {
>  		mlog(0, "Inode was orphaned on another node, clearing nlink.\n");
>  		inode->i_nlink = 0;
>  	}
> +	spin_unlock(&oi->ip_lock);
>  
>  	generic_drop_inode(inode);
>  
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
