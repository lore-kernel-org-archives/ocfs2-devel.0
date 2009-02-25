From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 24 Feb 2009 18:10:37 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V4)
In-Reply-To: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
References: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
Message-ID: <20090225021037.GC5209@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 20, 2009 at 05:23:50PM +0800, wengang wang wrote:
> changes from v3:
> 1, move codes that checks inode allocation bit to subfunction
> ocfs2_test_inode_bit().
> 
> 2, release the suballoc lock just after we get it. we should release it asap
> and doing so doesn't affect functionility.
> 
> 3, add inode alloc slot validation.

One last thing, sorry I missed it.

> +static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb, struct inode *suballoc,
> +			    struct buffer_head *alloc_bh, u64 blkno, u16 bit,
> +			    int *res)
> +{
> +	struct ocfs2_dinode *alloc_fe;
> +	struct ocfs2_group_desc *group;
> +	struct buffer_head *group_bh = NULL;
> +	u64 bg_blkno;
> +	int status;
> +
> +	mlog_entry("blkno: %llu bit: %u\n", blkno, (unsigned int)bit);
> +
> +	alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
> +	BUG_ON((bit + 1) > ocfs2_bits_per_group(&alloc_fe->id2.i_chain));
> +
> +	bg_blkno = ocfs2_which_suballoc_group(blkno, bit);
> +	status = ocfs2_read_blocks_sync(osb, bg_blkno, 1, &group_bh);
> +	if (status < 0)
> +		goto bail;
> +
> +	status = ocfs2_check_group_descriptor(osb->sb, alloc_fe, group_bh);
> +	if (status < 0)
> +		goto bail;

	Just use ocfs2_read_group_descriptor() here.  The locking code
will make sure it reads from disk if necessary.

Joel

-- 

 One look at the From:
 understanding has blossomed
 .procmailrc grows
	- Alexander Viro

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
