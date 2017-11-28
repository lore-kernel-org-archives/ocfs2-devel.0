From: Gang He <ghe@suse.com>
Date: Mon, 27 Nov 2017 22:33:56 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: add ocfs2_overwrite_io function
In-Reply-To: <5A1CC7BC.3060309@huawei.com>
References: <1511775987-841-1-git-send-email-ghe@suse.com>
	<1511775987-841-3-git-send-email-ghe@suse.com>
	<5A1CC7BC.3060309@huawei.com>
Message-ID: <5A1D65C4020000F90009ACE1@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alex.chen@huawei.com
Cc: jlbec@evilplan.org, hch@lst.de, ocfs2-devel@oss.oracle.com, Goldwyn Rodrigues <RGoldwyn@suse.com>, mfasheh@versity.com, linux-kernel@vger.kernel.org

Hello Alex,


>>> 
> Hi Gang,
> 
> On 2017/11/27 17:46, Gang He wrote:
>> Add ocfs2_overwrite_io function, which is used to judge if
>> overwrite allocated blocks, otherwise, the write will bring extra
>> block allocation overhead.
>> 
>> Signed-off-by: Gang He <ghe@suse.com>
>> ---
>>  fs/ocfs2/extent_map.c | 67 
> +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/ocfs2/extent_map.h |  3 +++
>>  2 files changed, 70 insertions(+)
>> 
>> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
>> index e4719e0..98bf325 100644
>> --- a/fs/ocfs2/extent_map.c
>> +++ b/fs/ocfs2/extent_map.c
>> @@ -832,6 +832,73 @@ int ocfs2_fiemap(struct inode *inode, struct 
> fiemap_extent_info *fieinfo,
>>  	return ret;
>>  }
>>  
>> +/* Is IO overwriting allocated blocks? */
>> +int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
>> +		       int wait)
>> +{
>> +	int ret = 0, is_last;
>> +	u32 mapping_end, cpos;
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	struct buffer_head *di_bh = NULL;
>> +	struct ocfs2_extent_rec rec;
>> +
>> +	if (wait)
>> +		ret = ocfs2_inode_lock(inode, &di_bh, 0);
>> +	else
>> +		ret = ocfs2_try_inode_lock(inode, &di_bh, 0);
>> +	if (ret)
>> +		goto out;
>> +
>> +	if (wait)
>> +		down_read(&OCFS2_I(inode)->ip_alloc_sem);
>> +	else {
>> +		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
>> +			ret = -EAGAIN;
>> +			goto out_unlock1;
>> +		}
>> +	}
>> +
>> +	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
>> +	   ((map_start + map_len) <= i_size_read(inode)))
>> +		goto out_unlock2;
>> +
>> +	cpos = map_start >> osb->s_clustersize_bits;
>> +	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
>> +					       map_start + map_len);
>> +	is_last = 0;
>> +	while (cpos < mapping_end && !is_last) {
>> +		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
>> +						 NULL, &rec, &is_last);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out_unlock2;
>> +		}
>> +
>> +		if (rec.e_blkno == 0ULL)
>> +			break;
> I think here the blocks is not overwrite, because the hold is found and the 
> blocks
> should be allocated.
If the rec.e_blkno == NULL, this means there is a hole.
The file hole means that these blocks are not allocated, it does not like unwritten block.
The unwritten blocks means that these blocks are allocated, but still have not been unwritten. 

>> +
>> +		if (rec.e_flags & OCFS2_EXT_REFCOUNTED)
>> +			break;
>> +
>> +		cpos = le32_to_cpu(rec.e_cpos) +
>> +			le16_to_cpu(rec.e_leaf_clusters);
>> +	}
>> +
>> +	if (cpos < mapping_end)
>> +		ret = 1;
>> +
>> +out_unlock2:
> 
> I think the 'out_up_read' is more readable than the 'out_unlock2' .
Ok, I will use more readable tag here.
> 
>> +	brelse(di_bh);
>> +
>> +	up_read(&OCFS2_I(inode)->ip_alloc_sem);
>> +
>> +out_unlock1:
> 
> We should release buffer head here.
> 
>> +	ocfs2_inode_unlock(inode, 0);
>> +
>> +out:
>> +	return (ret ? 0 : 1);
>> +}
>> +
>>  int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int 
> whence)
>>  {
>>  	struct inode *inode = file->f_mapping->host;
>> diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
>> index 67ea57d..fd9e86a 100644
>> --- a/fs/ocfs2/extent_map.h
>> +++ b/fs/ocfs2/extent_map.h
>> @@ -53,6 +53,9 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 
> v_blkno, u64 *p_blkno,
>>  int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>  		 u64 map_start, u64 map_len);
>>  
>> +int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
>> +		       int wait);
>> +
>>  int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int 
> origin);
>>  
>>  int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>> 
