From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 23 Jun 2010 17:14:37 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
	<20100623004937.GB20090@mail.oracle.com>
	<AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
	<20100623013633.GC20090@mail.oracle.com>
	<AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>
Message-ID: <20100624001437.GF20090@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 23, 2010 at 05:04:49PM -0700, Patrick J. LoPresti wrote:
> Note that I believe the original code had a bug: A "-1" was being
> applied to the cluster count, when it should instead be applied to the
> block count.  (Please correct me if I am wrong.)

	Good catch.
	I
> Trying to do all this inline got messy, so I factored out the tests
> into a new static function.

	Works for me.

> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0eaa929..e9d9ca3 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1991,6 +1991,43 @@ static int ocfs2_setup_osb_uuid(struct
> ocfs2_super *osb, const unsigned char *uu
>  	return 0;
>  }
> 
> +/* Check to make sure entire volume is addressable on this system. */
> +static int check_addressable(struct ocfs2_super *osb, struct ocfs2_dinode *di)

	Prefix the function properly: ocfs2_check_addressable().

> +{
> +	int status = 0;
> +	const u32 clusters = le32_to_cpu(di->i_clusters);
> +	const u64 max_block = ocfs2_clusters_to_blocks(osb->sb, clusters) - 1;
> +
> +	/* Absolute addressability check (borrowed from ext4/super.c) */
> +	if ((max_block >
> +	     (sector_t)(~0LL) >> (osb->sb->s_blocksize_bits - 9)) ||
> +	    max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT -
> +					    osb->sb->s_blocksize_bits)) {

	Please wrap the second side of the || in parenthesis.
Precedence is nice, but readability is better.

> +		mlog(ML_ERROR, "Volume too large "
> +		     "to mount safely on this system");
> +		status = -EFBIG;
> +		goto out;
> +	}
> +
> +	if (max_block <= (u32)~0UL)
> +		goto out;
> +
> +	/* Volume is "huge", so see if our journal is new enough to
> +	   have support for it. */
> +	if (!(OCFS2_HAS_COMPAT_FEATURE(osb->sb,
> +				       OCFS2_FEATURE_COMPAT_JBD2_SB) &&
> +	      jbd2_journal_check_used_features(osb->journal->j_journal, 0, 0,
> +					       JBD2_FEATURE_INCOMPAT_64BIT))) {
> +		mlog(ML_ERROR, "Volume might try to write to blocks beyond "
> +		     "what jbd can address in 32 bits.\n");

	"The journal cannot address the entire volume.  Enable the
'block64' journal option with tunefs.ocfs2."

Joel

-- 

Bram's Law:
	The easier a piece of software is to write, the worse it's
	implemented in practice.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
