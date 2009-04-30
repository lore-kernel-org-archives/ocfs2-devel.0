From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 30 Apr 2009 16:17:11 -0700
Subject: [Ocfs2-devel] [PATCH 03/39] ocfs2:
	Add	ocfs2_read_refcount_block.
In-Reply-To: <1241045931-24607-3-git-send-email-tao.ma@oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-3-git-send-email-tao.ma@oracle.com>
Message-ID: <20090430231711.GI2762@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 30, 2009 at 06:58:15AM +0800, Tao Ma wrote:
> +static int ocfs2_validate_refcount_block(struct super_block *sb,
> +					 struct buffer_head *bh)
> +{
> +	int rc;
> +	struct ocfs2_refcount_block *rb =
> +		(struct ocfs2_refcount_block *)bh->b_data;
> +
> +	mlog(0, "Validating refcount block %llu\n",
> +	     (unsigned long long)bh->b_blocknr);
> +
> +	BUG_ON(!buffer_uptodate(bh));
> +
> +	/*
> +	 * If the ecc fails, we return the error but otherwise
> +	 * leave the filesystem running.  We know any error is
> +	 * local to this block.
> +	 */
> +	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &rb->rf_check);
> +	if (rc) {
> +		mlog(ML_ERROR, "Checksum failed for extent block %llu\n",
> +		     (unsigned long long)bh->b_blocknr);

	'refcount block' instead of 'extent block' :-)

Joel

-- 

"The lawgiver, of all beings, most owes the law allegiance.  He of all
 men should behave as though the law compelled him.  But it is the
 universal weakness of mankind that what we are given to administer we
 presently imagine we own."
        - H.G. Wells

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
