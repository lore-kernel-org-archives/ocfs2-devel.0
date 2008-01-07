From: tao.ma <tao.ma@oracle.com>
Date: Mon Jan  7 01:06:54 2008
Subject: [Ocfs2-devel] [PATCH 1/2] Add support for cross extent block
	merge.V1
In-Reply-To: <20080107055116.GT23506@ca-server1.us.oracle.com>
References: <20080104083214.GA1584@tma-pc1.cn.oracle.com>
	<20080104084538.GA1916@tma-pc1.cn.oracle.com>
	<20080107055116.GT23506@ca-server1.us.oracle.com>
Message-ID: <4781EB53.8040503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for your review.
Mark Fasheh wrote:
>> @@ -2802,24 +3024,77 @@ static int ocfs2_merge_rec_left(struct inode *inode, struct buffer_head *bh,
>>  	ocfs2_cleanup_merge(el, index);
>>  
>>  	ret = ocfs2_journal_dirty(handle, bh);
>> -	if (ret)
>> +	if (ret) {
>>  		mlog_errno(ret);
>> +		goto out;
>> +	}
>>  
>> +	if (left_path) {
>> +		ret = ocfs2_journal_dirty(handle, path_leaf_bh(left_path));
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>> +
>> +		/*
>> +		 * In the situation that the right_rec is empty and the extent
>> +		 * block is empty also, ocfs2_complete_edge_insert can't handle
>> +		 * it, while ocfs2_rotate_tree_left can be called and the extent
>> +		 * block will be deleted since c_split_covers_rec is set.
>> +		 */
>> +		if (le16_to_cpu(right_rec->e_leaf_clusters) == 0 &&
>> +		    le16_to_cpu(el->l_next_free_rec) == 1)
>> +			goto out;
>>
>>     
>
> Hmm, I'm worried that we're exiting this function with a path whose upper
> cpos values are inconsistent. An error before we get the chance to actually
> do the rotate / removal could leave us with an inconsistent tree.
>
> I'm not sure that we can just slap some code to handle it here though - from
> what I can tell, the callers are expecting that we'd leave an empty extent
> for them to handle.
>   
Yes. So the situation here is really hard to handle and lead me to make 
the decision that we should let ocfs2_roatate_tree_left go on the issue.
> I see that ocfs2_rotate_tree_left _almost_ handles this situation
> correctly, except the transaction extend could fail before we get to remove
> the blocks. That might actually be a bug, though I have to think about it
> some more. Generally if ocfs2_rotate_tree_left handled it 100% correctly, we
> _could_ just comment the heck out of this function that callers *must* call
> the rotate function later. Since calling ocfs2_rotate_tree_left() is
> implicitely decided by the callers, I'd also want to audit the code to make
> sure that it always gets called in the new merge situations we've
> introduced.
>   
So any suggestion is welcomed. By now, I haven't found a good way to 
handle it except my current ugly codes. ;)
>
>   
>> @@ -2858,9 +3132,21 @@ static int ocfs2_try_to_merge_extent(struct inode *inode,
>>  		 * Since the adding of an empty extent shifts
>>  		 * everything back to the right, there's no need to
>>  		 * update split_index here.
>> -		 */
>> -		ret = ocfs2_merge_rec_left(inode, path_leaf_bh(left_path),
>> -					   handle, split_rec, el, split_index);
>> +		 *
>> + 		 * When the split_index is zero, we need to merge it to the
>> + 		 * prevoius extent block. It is more efficient and easier
>> + 		 * if we do merge_right first and merge_left later.
>> + 		 */
>>     
>
> So why don't we just always do the left merge 1st, instead of switching on
> them like this?
>   
If split_index==0, then if we do merge_right first, it will not touch 
the previous extent block(so no cross extent block merge is needed) and 
only the extent block after the record will be affected. The second 
merge_left will be cross extent block merge.
If split_index==l_count-1, then if we do merge_left first, the first 
merge will move the recs[0] of the next extent block into this block. So 
when merge_right is called, no cross extent block merge is needed.
So if you don't like this switch, I would prefer merge_right first and 
merge_left second to the original merge_left first. ;)

btw, I have patched your code of ocfs2_check_tree to my current git 
tree, it works well under my test script. The test script should be 
ready for review soon.
