From: tristan <tristan.ye@oracle.com>
Date: Tue, 22 Dec 2009 09:18:06 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Let ocfs2 support fiemap for
 symlink and fast symlink.
In-Reply-To: <4B30173C.8000303@oracle.com>
References: <1261215910-16398-1-git-send-email-tristan.ye@oracle.com>
	<4B30173C.8000303@oracle.com>
Message-ID: <4B301E4E.9080708@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> Can you add a comment atop ocfs2_fiemap_inline() saying that
> this function handles fiemap for both inline data and fast symlink.
>
> Just want to be clear about this considering the function name
> suggests it is inline-data only.
>
> Also, change the comment in ocfs2_fiemap()... "Handle inline-data and
> fast symlink separately".

It makes sense:)

>
> You can add my ack to your next post with the changes.
>
> Acked-by: Sunil Mushran <sunil.mushran@oracle.com>
>
> Tristan Ye wrote:
>> For fast symlink, it can be treated the same as inlined files since
>> the data extent we want to return of both case all were stored in
>> metadata block. For symlink, it can be simply treated the same as we
>> did for regular files.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>> ---
>>  fs/ocfs2/extent_map.c |   15 ++++++++++++---
>>  fs/ocfs2/symlink.c    |    2 ++
>>  2 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
>> index 843db64..3b5e435 100644
>> --- a/fs/ocfs2/extent_map.c
>> +++ b/fs/ocfs2/extent_map.c
>> @@ -37,6 +37,7 @@
>>  #include "extent_map.h"
>>  #include "inode.h"
>>  #include "super.h"
>> +#include "symlink.h"
>>  
>>  #include "buffer_head_io.h"
>>  
>> @@ -715,11 +716,18 @@ static int ocfs2_fiemap_inline(struct inode 
>> *inode, struct buffer_head *di_bh,
>>      struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>  
>>      di = (struct ocfs2_dinode *)di_bh->b_data;
>> -    id_count = le16_to_cpu(di->id2.i_data.id_count);
>> +    if (ocfs2_inode_is_fast_symlink(inode))
>> +        id_count = ocfs2_fast_symlink_chars(inode->i_sb);
>> +    else
>> +        id_count = le16_to_cpu(di->id2.i_data.id_count);
>>  
>>      if (map_start < id_count) {
>>          phys = oi->ip_blkno << inode->i_sb->s_blocksize_bits;
>> -        phys += offsetof(struct ocfs2_dinode, id2.i_data.id_data);
>> +        if (ocfs2_inode_is_fast_symlink(inode))
>> +            phys += offsetof(struct ocfs2_dinode, id2.i_symlink);
>> +        else
>> +            phys += offsetof(struct ocfs2_dinode,
>> +                     id2.i_data.id_data);
>>  
>>          ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count,
>>                            flags);
>> @@ -758,7 +766,8 @@ int ocfs2_fiemap(struct inode *inode, struct 
>> fiemap_extent_info *fieinfo,
>>      /*
>>       * Handle inline-data separately.
>>       */
>> -    if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
>> +    if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
>> +        ocfs2_inode_is_fast_symlink(inode)) {
>>          ret = ocfs2_fiemap_inline(inode, di_bh, fieinfo, map_start);
>>          goto out_unlock;
>>      }
>> diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
>> index e342103..49b133c 100644
>> --- a/fs/ocfs2/symlink.c
>> +++ b/fs/ocfs2/symlink.c
>> @@ -163,6 +163,7 @@ const struct inode_operations 
>> ocfs2_symlink_inode_operations = {
>>      .getxattr    = generic_getxattr,
>>      .listxattr    = ocfs2_listxattr,
>>      .removexattr    = generic_removexattr,
>> +    .fiemap        = ocfs2_fiemap,
>>  };
>>  const struct inode_operations ocfs2_fast_symlink_inode_operations = {
>>      .readlink    = ocfs2_readlink,
>> @@ -174,4 +175,5 @@ const struct inode_operations 
>> ocfs2_fast_symlink_inode_operations = {
>>      .getxattr    = generic_getxattr,
>>      .listxattr    = ocfs2_listxattr,
>>      .removexattr    = generic_removexattr,
>> +    .fiemap        = ocfs2_fiemap,
>>  };
>>   
>
