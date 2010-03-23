From: tristan <tristan.ye@oracle.com>
Date: Tue, 23 Mar 2010 11:00:13 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Optimize punching-hole codes
 v2.
In-Reply-To: <20100323023740.GE12279@mail.oracle.com>
References: <1267091348-26923-1-git-send-email-tristan.ye@oracle.com>
	<20100323023740.GE12279@mail.oracle.com>
Message-ID: <4BA82EBD.40909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Thanks for your comments.

Joel Becker wrote:
> On Thu, Feb 25, 2010 at 05:49:08PM +0800, Tristan Ye wrote:
>> ===========================================================================
>>  * Former punching-hole mechanism:
>> ===========================================================================
>>
>>    I waited 1 hour for its completion, unfortunately it's still ongoing.
>>
>> ===========================================================================
>>  * Patched punching-hode mechanism:
>> ===========================================================================
>>
>>    real	0m2.518s
>>    user	0m0.000s
>>    sys	0m2.445s
>>
>> That means we've gained up to 1000 times improvement on performance in this
>> case, whee! It's fairly cool. and it looks like that performance gain will
>> be raising when extent records grow.
>
> 	Love the numbers, obviously.

Maye such extent number didn't exist in a real world, it however was 
doing something positive;)

>
>> The patch was based on my former 2 patches, which were about truncating
>> codes optimization and fixup to handle CoW on punching hole.
>
> 	I've already reviewed these.  I'm waiting on Mark's ack for them
> to go to ocfs2.git.
>
>> -	cpos = trunc_start;
>> -	while (trunc_len) {
>> -		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos,
>> -					 &alloc_size, &flags);
>> -		if (ret) {
>> -			mlog_errno(ret);
>> -			goto out;
>> -		}
>> +	path = ocfs2_new_path_from_et(&et);
>> +	if (!path) {
>> +		ret = -ENOMEM;
>> +		mlog_errno(ret);
>> +		goto out;
>> +	}
>> +
>> +start:
>> +	if (trunc_end == 0) {
>> +		ret = 0;
>> +		goto out;
>> +	}
>
> 	NO!  Don't do loops via goto.  Just Don't.  There are some
> convoluted functions that end up being cleaner with gotos, but they are
> *convoluted*.  This is a simple loop.  Keep it that way.
> 	In fact, this all really wants to be a helper function:
>
> 	while (trunc_end > 0) {
> 		do_one_hunk();
> 		ocfs2_reinit_path(path, 1);
> 	}
>
> 	Actually, looking at the rest of the code, I see a couple
> helpers.  If you wrap trunc_start, trunc_len, etc in a structure, you
> can pass it through.
>
>>  
>> -		if (alloc_size > trunc_len)
>> -			alloc_size = trunc_len;
>> +	/*
>> +	 * Unlike truncating codes, here we want to find a path which contains
>> +	 * (trunc_end - 1) cpos, and trunc_end will be decreased after each
>> +	 * removal of a record range.
>> +	 *
>> +	 * Why didn't use trunc_end to search the path?
>> +	 * The reason is simple, think about the situation when we cross the
>> +	 * extent block, we need to find the adjacent block by decreasing one
>> +	 * cluster, otherwise, it will run into loop.
>> +	 */
>> +	ret = ocfs2_find_path(INODE_CACHE(inode), path, cluster_within_list);
>> +	if (ret) {
>> +		mlog_errno(ret);
>> +		goto out;
>> +	}
>>  
>> -		/* Only do work for non-holes */
>> -		if (phys_cpos != 0) {
>> -			ret = ocfs2_remove_btree_range(inode, &et, cpos,
>> -						       phys_cpos, alloc_size,
>> -						       &dealloc, refcount_loc,
>> -						       flags);
>> -			if (ret) {
>> -				mlog_errno(ret);
>> -				goto out;
>> -			}
>> +	el = path_leaf_el(path);
>> +
>> +	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
>> +		rec = &el->l_recs[i];
>> +		/*
>> +		 * Find the rightmost record which contains 'trunc_end' cpos,
>> +		 * and we just simply jump to previous record if the trunc_end
>> +		 * is the start of a record.
>> +		 */
>> +		if (le32_to_cpu(rec->e_cpos) < trunc_end) {
>> +			/*
>> +			 * Skip a hole.
>> +			 */
>> +			if ((le32_to_cpu(rec->e_cpos) +
>> +			     ocfs2_rec_clusters(el, rec)) < trunc_end)
>> +				trunc_end = le32_to_cpu(rec->e_cpos) +
>> +					ocfs2_rec_clusters(el, rec);
>> +			break;
>>  		}
>>  
>> -		cpos += alloc_size;
>> -		trunc_len -= alloc_size;
>> +		if (le32_to_cpu(rec->e_cpos) == trunc_end) {
>> +			i--;
>> +			break;
>> +		}
>> +	}
>> +
>> +	rec = &el->l_recs[i];
>
> 	This is the first helper.  It finds the rec.
>
>> +	flags = rec->e_flags;
>> +	range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
>> +
>> +	/*
>> +	 * Similar with the truncating codes, we also handle the
>> +	 * following three cases in order:
>> +	 *
>> +	 * - remove the entire record
>> +	 * - remove a partial record
>> +	 * - no record needs to be removed
>> +	 */
>> +	if (le32_to_cpu(rec->e_cpos) >= trunc_start) {
>> +		trunc_cpos = le32_to_cpu(rec->e_cpos);
>> +		trunc_len = trunc_end - le32_to_cpu(rec->e_cpos);
>> +		blkno = le64_to_cpu(rec->e_blkno);
>> +		trunc_end = le32_to_cpu(rec->e_cpos);
>> +	} else if (range > trunc_start) {
>> +		trunc_cpos = trunc_start;
>> +		trunc_len = range - trunc_start;
>> +		coff = trunc_start - le32_to_cpu(rec->e_cpos);
>> +		blkno = le64_to_cpu(rec->e_blkno) +
>> +				ocfs2_clusters_to_blocks(inode->i_sb, coff);
>> +		trunc_end = trunc_start;
>> +	} else {
>> +		/*
>> +		 * It may have two following possibilities:
>> +		 *
>> +		 * - last record has been removed
>> +		 * - trunc_start was within a hole
>> +		 *
>> +		 * both two cases mean the completion of hole punching.
>> +		 */
>> +		ret = 0;
>> +		goto out;
>>  	}
>>  
>> +	phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
>
> 	This is the second helper.  It computes the actual results from
> the found record.
>
>> +	ret = ocfs2_remove_btree_range(inode, &et, trunc_cpos,
>> +				       phys_cpos, trunc_len, &dealloc,
>> +				       refcount_loc, flags);
>> +	if (ret < 0) {
>> +		mlog_errno(ret);
>> +		goto out;
>> +	}
>> +
>> +	if (trunc_end > 0)
>> +		cluster_within_list = trunc_end - 1;
>
> 	This is the third helper.  It does the actual punch.

Your words make sense:)


I may wrap these loose codes up for better readability.


Tristan.

>
> Joel
>
