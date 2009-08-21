From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 20 Aug 2009 17:59:32 -0700
Subject: [Ocfs2-devel] [PATCH 17/41] ocfs2: Add CoW support.
In-Reply-To: <1250576382-27080-17-git-send-email-tao.ma@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-17-git-send-email-tao.ma@oracle.com>
Message-ID: <20090821005932.GE10558@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 18, 2009 at 02:19:18PM +0800, Tao Ma wrote:
> +		if (*cow_len + leaf_clusters >= max_clusters) {
> +			if (*cow_len == 0) {
> +				/*
> +				 * cpos is in a very large extent record.
> +				 * So just split max_clusters from the
> +				 * extent record.
> +				 */
> +				if ((rec_end - cpos) <= max_clusters) {
> +					/*
> +					 * We can take max_clusters off
> +					 * the end and cover all of our
> +					 * write.
> +					 */
> +					*cow_start = rec_end - max_clusters;

	I just had a thought.  What if leaf_clusters is more than
max_clusters, but our cpos is near the end of the extent?  This only
works for the first pass (*cow_len == 0).  Imagine we have an extent of
1.5MB, and our cpos is at 1MB, and we want to write 1MB.  Clustersize of
256K.

  |<-- rec->e_cpo ==0                   leaf_clusters == 6 -->|
  |--<256>--|--<256>--|--<256>--|--<256>--|--<256>--|--<256>--|
                                          `cpos

When we get here, *cow_len is 0, *cow_start is 0 (rec->e_cpos), rec_end
is 6 (leaf_clusters), cpos is 4 because the user wants to write at 1MB
into the file, max_clusters is 4 (1MB) and write_len is 4 (1MB write).

1. *cow_len + leaf_clusters >= max_clusters
   0        + 6             >= 4  -> TRUE

2. (rec_end - cpos) <= max_clusters
   6        - 4     <= 4  -> TRUE

3. *cow_start = rec_end - max_clusters
              = 6       - 4  -> 2

4. *cow_len = max_clusters
            = 4

	This leaves us with a *cow_start of 2 and a *cow_len of 4.  This
*correctly gets us the last MB of the extent.  That's good.
However, our write was 1MB from cpos 4.  We're returning to the caller
1MB from cpos 2.  We're going to do a short write.

> +				} else if ((*cow_start + max_clusters) >
> +					   (cpos + write_len)) {

	Should this be >=?  I think it should be, and I think it's my
fault.  But check to make sure.

> +					/*
> +					 * We can take max_clusters off
> +					 * the front and cover all of
> +					 * our write.
> +					 */
> +					/* NOOP, *cow_start is already set */
> +				} else {
> +					/*
> +					 * We're CoWing more data than
> +					 * write_len for contiguousness,
> +					 * but it doesn't fit at the
> +					 * front or end of this extent.
> +					 * Let's try to slice the extent
> +					 * up nicely.  Optimally, our
> +					 * CoW region starts at a
> +					 * multiple of max_clusters.  If
> +					 * that doesn't fit, we give up
> +					 * and just CoW at cpos.
> +					 */
> +					*cow_start +=
> +						(cpos - *cow_start) &
> +							~(max_clusters - 1);
> +					if ((*cow_start + max_clusters) <
> +					    (cpos + write_len))
> +						*cow_start = cpos;
> +				}
> +			}
> +			*cow_len = max_clusters;
> +			break;
> +		} else
> +			*cow_len += leaf_clusters;
> +
> +		/*
> +		 * If we reach the end of the extent block and don't get enough
> +		 * clusters, continue with the next extent block if possible.
> +		 */
> +		if (i + 1 == le16_to_cpu(el->l_next_free_rec) &&
> +		    eb && eb->h_next_leaf_blk) {
> +			brelse(eb_bh);
> +			eb_bh = NULL;
> +
> +			ret = ocfs2_read_extent_block(INODE_CACHE(inode),
> +					       le64_to_cpu(eb->h_next_leaf_blk),
> +					       &eb_bh);
> +			if (ret) {
> +				mlog_errno(ret);
> +				goto out;
> +			}
> +
> +			eb = (struct ocfs2_extent_block *) eb_bh->b_data;
> +			el = &eb->h_list;
> +			i = -1;
> +		}
> +	}
> +
> +out:
> +	brelse(eb_bh);
> +	return ret;
> +}

Joel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
