From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 8 Jul 2010 12:42:24 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Make xattr reflink work with new
 local alloc reservation.
In-Reply-To: <1276830171-5908-2-git-send-email-tao.ma@oracle.com>
References: <4C1AE141.60707@oracle.com>
	<1276830171-5908-2-git-send-email-tao.ma@oracle.com>
Message-ID: <20100708194224.GE17445@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 18, 2010 at 11:02:51AM +0800, Tao Ma wrote:
> +	num_buckets = le16_to_cpu(bucket_xh(args->old_bucket)->xh_num_buckets);
> +	ocfs2_xattr_bucket_relse(args->old_bucket);
> +
> +	while (len && num_buckets) {
> +		ret = ocfs2_claim_clusters(handle, data_ac,
> +					   1, &p_cluster, &num_clusters);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		new_blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
> +		reflink_buckets = num_buckets < bpc * num_clusters ?
> +				  num_buckets : bpc * num_clusters;

	I don't get this check.  In
ocfs2_lock_reflink_xattr_rec_allocators(), we've reserved exactly enough
clusters for the xattr rec.  ocfs2_claim_clusters() may return less than
that, but in the optimal case it will return the entire len.  So...
	Ok, I think I get it.  I was trying to figure out if you were
leaking clusters.  This check reflects that a cluster may contain
multiple buckets, but not all buckets may be used yet.  Correct me if
I'm wrong about the following limits: 

	BUG_ON(num_buckets < (bpc * (len - 1)));
	BUG_ON(num_buckets > (bpc * len));

You don't have to add those BUG_ON() calls to the code; I'm just
confirming the range as I understand it.
	With that knowledge, your code is saying: "I have num_buckets to
reflink, did I get enough clusters to do them all, or do I just use the
entire range I got?"
	I think we should be more explicit.  Something like:

		reflink_buckets = num_buckets;
		if (reflink_buckets < (bpc * num_clusters))
			reflink_buckets = bpc * num_clusters;

This way speaks the intention.  I'd also be fine with:

		reflink_buckets = min(num_buckets, bpc * num_clusters);

Actually, I think that's the most readable.

Joel

-- 

Life's Little Instruction Book #337

	"Reread your favorite book."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
