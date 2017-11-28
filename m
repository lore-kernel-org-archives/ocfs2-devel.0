From: Joseph Qi <jiangqi903@gmail.com>
Date: Tue, 28 Nov 2017 17:03:51 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: add ocfs2_overwrite_io function
In-Reply-To: <5A1D94BF020000F90009AE19@prv-mh.provo.novell.com>
References: <1511775987-841-1-git-send-email-ghe@suse.com>
	<1511775987-841-3-git-send-email-ghe@suse.com>
	<123f1322-d453-4aca-ac95-63d6f90fd8a2@gmail.com>
	<5A1D49E5020000F90009AC66@prv-mh.provo.novell.com>
	<805fb849-dcc7-cbbc-02af-1c6116a88957@gmail.com>
	<5A1D7FC2020000F90009AD91@prv-mh.provo.novell.com>
	<1437e732-35ea-9022-3358-dbe7d2708009@gmail.com>
	<5A1D94BF020000F90009AE19@prv-mh.provo.novell.com>
Message-ID: <88b0035d-0401-9feb-7c51-a8a5dc7be6b4@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, jlbec@evilplan.org, hch@lst.de, Goldwyn Rodrigues <RGoldwyn@suse.com>, mfasheh@versity.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 17/11/28 16:54, Gang He wrote:
> Hi Joseph,
> 
> 
>>>>
> 
>>
>> On 17/11/28 15:24, Gang He wrote:
>>> Hello Joseph,
>>>
>>>
>>>>>>
>>>
>>>>
>>>> On 17/11/28 11:35, Gang He wrote:
>>>>> Hello Joseph,
>>>>>
>>>>>
>>>>>>>>
>>>>>> Hi Gang,
>>>>>>
>>>>>> On 17/11/27 17:46, Gang He wrote:
>>>>>>> Add ocfs2_overwrite_io function, which is used to judge if
>>>>>>> overwrite allocated blocks, otherwise, the write will bring extra
>>>>>>> block allocation overhead.
>>>>>>>
>>>>>>> Signed-off-by: Gang He <ghe@suse.com>
>>>>>>> ---
>>>>>>>  fs/ocfs2/extent_map.c | 67 
>>>>>> +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>  fs/ocfs2/extent_map.h |  3 +++
>>>>>>>  2 files changed, 70 insertions(+)
>>>>>>>
>>>>>>> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
>>>>>>> index e4719e0..98bf325 100644
>>>>>>> --- a/fs/ocfs2/extent_map.c
>>>>>>> +++ b/fs/ocfs2/extent_map.c
>>>>>>> @@ -832,6 +832,73 @@ int ocfs2_fiemap(struct inode *inode, struct 
>>>>>> fiemap_extent_info *fieinfo,
>>>>>>>  	return ret;
>>>>>>>  }
>>>>>>>  
>>>>>>> +/* Is IO overwriting allocated blocks? */
>>>>>>> +int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
>>>>>>> +		       int wait)
>>>>>>> +{
>>>>>>> +	int ret = 0, is_last;
>>>>>>> +	u32 mapping_end, cpos;
>>>>>>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>>>>>> +	struct buffer_head *di_bh = NULL;
>>>>>>> +	struct ocfs2_extent_rec rec;
>>>>>>> +
>>>>>>> +	if (wait)
>>>>>>> +		ret = ocfs2_inode_lock(inode, &di_bh, 0);
>>>>>>> +	else
>>>>>>> +		ret = ocfs2_try_inode_lock(inode, &di_bh, 0);
>>>>>>> +	if (ret)
>>>>>>> +		goto out;
>>>>>>> +
>>>>>>> +	if (wait)
>>>>>>> +		down_read(&OCFS2_I(inode)->ip_alloc_sem);
>>>>>>> +	else {
>>>>>>> +		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
>>>>>>> +			ret = -EAGAIN;
>>>>>>> +			goto out_unlock1;
>>>>>>> +		}
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
>>>>>>> +	   ((map_start + map_len) <= i_size_read(inode)))
>>>>>>> +		goto out_unlock2;
>>>>>>> +
>>>>>>> +	cpos = map_start >> osb->s_clustersize_bits;
>>>>>>> +	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
>>>>>>> +					       map_start + map_len);
>>>>>>> +	is_last = 0;
>>>>>>> +	while (cpos < mapping_end && !is_last) {
>>>>>>> +		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
>>>>>>> +						 NULL, &rec, &is_last);
>>>>>>> +		if (ret) {
>>>>>>> +			mlog_errno(ret);
>>>>>>> +			goto out_unlock2;
>>>>>>> +		}
>>>>>>> +
>>>>>>> +		if (rec.e_blkno == 0ULL)
>>>>>>> +			break;
>>>>>>> +
>>>>>>> +		if (rec.e_flags & OCFS2_EXT_REFCOUNTED)
>>>>>>> +			break;
>>>>>>> +
>>>>>>> +		cpos = le32_to_cpu(rec.e_cpos) +
>>>>>>> +			le16_to_cpu(rec.e_leaf_clusters);
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	if (cpos < mapping_end)
>>>>>>> +		ret = 1;
>>>>>>> +
>>>>>>> +out_unlock2:
>>>>>>> +	brelse(di_bh);
>>>>>>> +
>>>>>>> +	up_read(&OCFS2_I(inode)->ip_alloc_sem);
>>>>>>> +
>>>>>>> +out_unlock1:
>>>>>> Should brelse(di_bh) be here?
>>>>> If the code jumps to out_unlock1 directly, the di_bh pointer should be NULL, 
>>
>>>> it is not necessary to release.
>>>>>
>>>> Umm... No, once going out here, we have already taken inode lock. So
>>>> di_bh should be released.
>>> Sorry, you are right.
>>>
>>>>
>>>>>>
>>>>>>> +	ocfs2_inode_unlock(inode, 0);
>>>>>>> +
>>>>>>> +out:
>>>>>>> +	return (ret ? 0 : 1);
>>>>>> I don't think EAGAIN and other error code can be handled the same. We
>>>>>> have to distinguish them.
>>>>> Ok, I think we can add one line log to report the error in case the error is 
>>
>>>> not EAGAIN. 
>>>>>
>>>> My point is, there is no need to try again in several cases, e.g. EROFS
>>>> returned by ocfs2_get_clusters_nocache.
>>> In this function ocfs2_overwrite_io() only can return True(1) or False(0), 
>> then I think we can only give a error print before return true/false.
>>> It is not necessary to return another value, but should let the user know 
>> any possible error message.
>>> This is because you just ignore the error and convert it to 0 or 1.
>> But in your next patch, if !ocfs2_overwrite_io(), it will return EGAIN
>> to upper layer and let it try again.
>> But in some cases, e.g. EROFS, trying again is meaningless. That's why
>> we can't simply return 0 or 1 here. Also we have to distinguish the
>> error code in the next patch.
> I think that we have to use the return value if we want to propagate the errorno to the above.
> I will change the return value meanings of ocfs2_overwrite_io() function.
> return 0 means this is a overwrite allocated block IO.
> return -EGAIN means there are some blocks which are not allocated.
> return other -ERRNO means there is another error happened.
> Does it make sense?
> 
Yes, that looks fine to me.
We have to make sure the returned EAGAIN to upper layer is really
*EAGAIN*.

>>>>>>
>>>>>>> +}
>>>>>>> +
>>>>>>>  int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int 
>>>>>> whence)
>>>>>>>  {
>>>>>>>  	struct inode *inode = file->f_mapping->host;
>>>>>>> diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
>>>>>>> index 67ea57d..fd9e86a 100644
>>>>>>> --- a/fs/ocfs2/extent_map.h
>>>>>>> +++ b/fs/ocfs2/extent_map.h
>>>>>>> @@ -53,6 +53,9 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 
>>>>>> v_blkno, u64 *p_blkno,
>>>>>>>  int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>>>>>>  		 u64 map_start, u64 map_len);
>>>>>>>  
>>>>>>> +int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
>>>>>>> +		       int wait);
>>>>>>> +
>>>>>>>  int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int 
>>>>>> origin);
>>>>>>>  
>>>>>>>  int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>>>>>>>
>>>>>
