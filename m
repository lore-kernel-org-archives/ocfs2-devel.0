From: Gang He <ghe@suse.com>
Date: Mon, 27 Nov 2017 22:27:32 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: add ocfs2_overwrite_io function
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F1470AB8@H3CMLB12-EX.srv.huawei-3com.com>
References: <1511775987-841-1-git-send-email-ghe@suse.com>
	<1511775987-841-3-git-send-email-ghe@suse.com>
	<5A1CC0EA.9010100@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F1470AB8@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5A1D6444020000F90009ACCB@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jlbec@evilplan.org, ge.changwei@h3c.com, piaojun@huawei.com, hch@lst.de, Goldwyn Rodrigues <RGoldwyn@suse.com>, mfasheh@versity.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org




>>> 
> On 2017/11/28 9:52, piaojun wrote:
>> Hi Gang,
>> 
>> If ocfs2_overwrite_io is only called in 'nowait' scenarios, I wonder if
>> we can discard 'int wait' just as ext4 does:
>> 
>> static bool ext4_overwrite_io(struct inode *inode, loff_t pos, loff_t len);
> 
> Yes, Jun has a point.
> It seems that ocfs2_overwrite_io is only involved in non-blocking aio 
> and no other code spot is calling ocfs2_overwrite_io with wait=1 passed.
Ok, I will do this change.

> 
>> 
>> thans,
>> Jun
>> 
>> On 2017/11/27 17:46, Gang He wrote:
>>> Add ocfs2_overwrite_io function, which is used to judge if
>>> overwrite allocated blocks, otherwise, the write will bring extra
>>> block allocation overhead.
>>>
>>> Signed-off-by: Gang He <ghe@suse.com>
>>> ---
>>>   fs/ocfs2/extent_map.c | 67 
> +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   fs/ocfs2/extent_map.h |  3 +++
>>>   2 files changed, 70 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
>>> index e4719e0..98bf325 100644
>>> --- a/fs/ocfs2/extent_map.c
>>> +++ b/fs/ocfs2/extent_map.c
>>> @@ -832,6 +832,73 @@ int ocfs2_fiemap(struct inode *inode, struct 
> fiemap_extent_info *fieinfo,
>>>   	return ret;
>>>   }
>>>   
>>> +/* Is IO overwriting allocated blocks? */
>>> +int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
>>> +		       int wait)
>>> +{
>>> +	int ret = 0, is_last;
>>> +	u32 mapping_end, cpos;
>>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>> +	struct buffer_head *di_bh = NULL;
>>> +	struct ocfs2_extent_rec rec;
>>> +
>>> +	if (wait)
>>> +		ret = ocfs2_inode_lock(inode, &di_bh, 0);
>>> +	else
>>> +		ret = ocfs2_try_inode_lock(inode, &di_bh, 0);
>>> +	if (ret)
>>> +		goto out;
>>> +
>>> +	if (wait)
>>> +		down_read(&OCFS2_I(inode)->ip_alloc_sem);
>>> +	else {
>>> +		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
>>> +			ret = -EAGAIN;
> Here is a little strange, it seems that you don't care much about how 
> this function fails. Why evaluate _ret_ to  -EAGAIN here and ignore it 
> later?
> 
> Thanks,
> Changwei
> 
>>> +			goto out_unlock1;
>>> +		}
>>> +	}
>>> +
>>> +	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
>>> +	   ((map_start + map_len) <= i_size_read(inode)))
>>> +		goto out_unlock2;
>>> +
>>> +	cpos = map_start >> osb->s_clustersize_bits;
>>> +	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
>>> +					       map_start + map_len);
>>> +	is_last = 0;
>>> +	while (cpos < mapping_end && !is_last) {
>>> +		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
>>> +						 NULL, &rec, &is_last);
>>> +		if (ret) {
>>> +			mlog_errno(ret);
>>> +			goto out_unlock2;
>>> +		}
>>> +
>>> +		if (rec.e_blkno == 0ULL)
>>> +			break;
>>> +
>>> +		if (rec.e_flags & OCFS2_EXT_REFCOUNTED)
>>> +			break;
>>> +
>>> +		cpos = le32_to_cpu(rec.e_cpos) +
>>> +			le16_to_cpu(rec.e_leaf_clusters);
>>> +	}
>>> +
>>> +	if (cpos < mapping_end)
>>> +		ret = 1;
>>> +
>>> +out_unlock2:
>>> +	brelse(di_bh);
>>> +
>>> +	up_read(&OCFS2_I(inode)->ip_alloc_sem);
>>> +
>>> +out_unlock1:
>>> +	ocfs2_inode_unlock(inode, 0);
>>> +
>>> +out:
>>> +	return (ret ? 0 : 1);
>>> +}
>>> +
>>>   int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int 
> whence)
>>>   {
>>>   	struct inode *inode = file->f_mapping->host;
>>> diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
>>> index 67ea57d..fd9e86a 100644
>>> --- a/fs/ocfs2/extent_map.h
>>> +++ b/fs/ocfs2/extent_map.h
>>> @@ -53,6 +53,9 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 
> v_blkno, u64 *p_blkno,
>>>   int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>>   		 u64 map_start, u64 map_len);
>>>   
>>> +int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
>>> +		       int wait);
>>> +
>>>   int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int 
> origin);
>>>   
>>>   int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>>>
>> 
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com 
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
>> 
