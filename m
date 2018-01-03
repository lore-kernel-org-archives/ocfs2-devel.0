From: Gang He <ghe@suse.com>
Date: Tue, 02 Jan 2018 22:14:01 -0700
Subject: [Ocfs2-devel] [PATCH v3 2/3] ocfs2: add ocfs2_overwrite_io
 function
In-Reply-To: <5A4B666B.1040803@huawei.com>
References: <1514455665-16325-1-git-send-email-ghe@suse.com>
	<1514455665-16325-3-git-send-email-ghe@suse.com>
	<5A4B666B.1040803@huawei.com>
Message-ID: <5A4CD719020000F9000A0FE0@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alex.chen@huawei.com
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, mfasheh@versity.com, linux-kernel@vger.kernel.org

Hi Alex,


>>> 
> Hi Gang,
> 
> On 2017/12/28 18:07, Gang He wrote:
>> Add ocfs2_overwrite_io function, which is used to judge if
>> overwrite allocated blocks, otherwise, the write will bring extra
>> block allocation overhead.
>> 
>> Signed-off-by: Gang He <ghe@suse.com>
>> ---
>>  fs/ocfs2/extent_map.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>  fs/ocfs2/extent_map.h |  3 +++
>>  2 files changed, 48 insertions(+)
>> 
>> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
>> index e4719e0..06cb964 100644
>> --- a/fs/ocfs2/extent_map.c
>> +++ b/fs/ocfs2/extent_map.c
>> @@ -38,6 +38,7 @@
>>  #include "inode.h"
>>  #include "super.h"
>>  #include "symlink.h"
>> +#include "aops.h"
>>  #include "ocfs2_trace.h" 
>>  
>>  #include "buffer_head_io.h"
>> @@ -832,6 +833,50 @@ int ocfs2_fiemap(struct inode *inode, struct 
> fiemap_extent_info *fieinfo,
>>  	return ret;
>>  }
>>  
>> +/* Is IO overwriting allocated blocks? */
>> +int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
>> +		       u64 map_start, u64 map_len)
> Here can the type of 'map_start' is struct loff_t and map_len is struct 
> size_t?
I prefer to use the detailed types for file start address and length in ocfs2_overwrite_io() function declaration, 
then here will be a potential type conversion (loff_t  -> u64, size_t -> u64), I think this conversion should be considered as expectation. 
Since our OCFS2 is a 64 bit file system, the related data types do not change,  but loff_t and size_t type can change under different architectures (e.g. x86_32, x86_64, etc.).

Thanks
Gang

> 
> Thanks,
> Alex
>> +{
>> +	int ret = 0, is_last;
>> +	u32 mapping_end, cpos;
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	struct ocfs2_extent_rec rec;
>> +
>> +	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
>> +		if (ocfs2_size_fits_inline_data(di_bh, map_start + map_len))
>> +			return ret;
>> +		else
>> +			return -EAGAIN;
>> +	}
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
>> diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
>> index 67ea57d..1057586 100644
>> --- a/fs/ocfs2/extent_map.h
>> +++ b/fs/ocfs2/extent_map.h
>> @@ -53,6 +53,9 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 
> v_blkno, u64 *p_blkno,
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
>> 
