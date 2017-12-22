From: Gang He <ghe@suse.com>
Date: Fri, 22 Dec 2017 00:01:25 -0700
Subject: [Ocfs2-devel] [patch 10/11] ocfs2: add ocfs2_overwrite_io()
In-Reply-To: <5A390BD9.4010804@huawei.com>
References: <5a208528.nZGENOlql9oMjjxc%akpm@linux-foundation.org>
	<5A390BD9.4010804@huawei.com>
Message-ID: <5A3D1E45020000F90009FE58@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Alex,

Sorry for replaying your mail so late.


>>> 
> Hi Gang,
> 
> On 2017/12/1 6:24, akpm at linux-foundation.org wrote:
>> From: Gang He <ghe@suse.com>
>> Subject: ocfs2: add ocfs2_overwrite_io()
>> 
>> Add ocfs2_overwrite_io(), which is used to judge if overwrite allocated
>> blocks, otherwise, the write will bring extra block allocation overhead.
>> 
>> [ghe at suse.com: v2]
>>   Link: 
> https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_151194 
> 4612-2D9629-2D3-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8P
> Zh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=C4AZ7lGI2-
> gfFtbla8puNvYIA3a9Cr_XOH6oyx94oGo&s=QhxdPyP9gdEJZTa2UhuSk0x7ENXyGXUOIBV_LyP8oZ
> w&e=
>> Link: 
> https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_151177 
> 5987-2D841-2D3-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZ
> h8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=C4AZ7lGI2-g
> fFtbla8puNvYIA3a9Cr_XOH6oyx94oGo&s=T9Ljku-nipBqCaeXWukY2hAwcHQL95gtlU7pS3l1fgs&e
> =
>> Signed-off-by: Gang He <ghe@suse.com>
>> Cc: Mark Fasheh <mfasheh@versity.com>
>> Cc: Joel Becker <jlbec@evilplan.org>
>> Cc: Junxiao Bi <junxiao.bi@oracle.com>
>> Cc: Joseph Qi <jiangqi903@gmail.com>
>> Cc: Changwei Ge <ge.changwei@h3c.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>> 
>>  fs/ocfs2/extent_map.c |   41 ++++++++++++++++++++++++++++++++++++++++
>>  fs/ocfs2/extent_map.h |    3 ++
>>  2 files changed, 44 insertions(+)
>> 
>> diff -puN fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function 
> fs/ocfs2/extent_map.c
>> --- a/fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function
>> +++ a/fs/ocfs2/extent_map.c
>> @@ -832,6 +832,47 @@ out:
>>  	return ret;
>>  }
>>  
>> +/* Is IO overwriting allocated blocks? */
>> +int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
>> +		       u64 map_start, u64 map_len)
>> +{
>> +	int ret = 0, is_last;
>> +	u32 mapping_end, cpos;
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	struct ocfs2_extent_rec rec;
>> +
>> +	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
>> +	   ((map_start + map_len) <= i_size_read(inode)))
>> +		goto out;
>> +
> Should we return -EAGAIN directly when the condition 
> ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) && ((map_start + 
> map_len) > i_size_read(inode)))
> is true?
Yes, here the code can be improved like as below.
e.g.
if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
	if (ocfs2_size_fits_inline_data(di_bh, map_start + map_len))
		goto out;
	else
		return -EAGAIN;
} 

Thanks
Gang

> 
> Thanks,
> Alex
>> +	cpos = map_start >> osb->s_clustersize_bits;
>> +	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
>> +					       map_start + map_len);
>> +	is_last = 0;
>> +	while (cpos < mapping_end && !is_last) {
>> +		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
>> +						 NULL, &rec, &is_last);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>> +
>> +		if (rec.e_blkno == 0ULL)
>> +			break;
>> +
>> +		if (rec.e_flags & OCFS2_EXT_REFCOUNTED)
>> +			break;
>> +
>> +		cpos = le32_to_cpu(rec.e_cpos) +
>> +			le16_to_cpu(rec.e_leaf_clusters);
>> +	}
>> +
>> +	if (cpos < mapping_end)
>> +		ret = -EAGAIN;
>> +out:
>> +	return ret;
>> +}
>> +
>>  int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int 
> whence)
>>  {
>>  	struct inode *inode = file->f_mapping->host;
>> diff -puN fs/ocfs2/extent_map.h~ocfs2-add-ocfs2_overwrite_io-function 
> fs/ocfs2/extent_map.h
>> --- a/fs/ocfs2/extent_map.h~ocfs2-add-ocfs2_overwrite_io-function
>> +++ a/fs/ocfs2/extent_map.h
>> @@ -53,6 +53,9 @@ int ocfs2_extent_map_get_blocks(struct i
>>  int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>  		 u64 map_start, u64 map_len);
>>  
>> +int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
>> +		       u64 map_start, u64 map_len);
>> +
>>  int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int 
> origin);
>>  
>>  int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>> _
>> 
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com 
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
>> 
>> .
>> 
