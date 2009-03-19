From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 19 Mar 2009 14:47:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix 2 warning during ocfs2 make.
In-Reply-To: <49C1E968.9070103@oracle.com>
References: <1237410523-8639-1-git-send-email-tao.ma@oracle.com>
	<49C1E605.5030801@oracle.com> <49C1E968.9070103@oracle.com>
Message-ID: <49C1EA90.6090201@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

yes, that's the problem.
we'd better unify the different types(but could be another patch).
since the on disk is u16, modifying other types to u16 is fine :)

thanks,
wengang.

Tao Ma wrote:
> Hi wengang,
> 
> Wengang Wang wrote:
>> Hi Tao,
>>
>> I think for the OCFS2_INVALID_SLOT problem,
>> define OCFS2_INVALID_SLOT as (u16)-1 is better. so that we needn't
>> force convert type wherever it's used.
> I just copy/paste and do like others. See
> fs/ocfs2/slot_map.c:        if (le16_to_cpu(sm->sm_slots[i]) == 
> (u16)OCFS2_INVALID_SLOT)
> 
> And after I searched again, I guess we can't do that. look at 
> fs/ocfs2/super.c.
> osb->slot_num = OCFS2_INVALID_SLOT;
> slot_num is defined as int. So your definition will break the rule. and 
> make slot_num=65535.
> 
> Regards,
> Tao
>>
>>
>> --- fs/ocfs2/ocfs2_fs.h 2009-02-18 19:58:02.000000000 +0800
>> +++ fs/ocfs2/ocfs2_fs.h.1       2009-03-19 14:24:18.000000000 +0800
>> @@ -303,7 +303,7 @@ struct ocfs2_new_group_input {
>>  #define OCFS2_MAX_SLOTS                        255
>>
>>  /* Slot map indicator for an empty slot */
>> -#define OCFS2_INVALID_SLOT             -1
>> +#define OCFS2_INVALID_SLOT             (u16)-1
>>
>>  #define OCFS2_VOL_UUID_LEN             16
>>  #define OCFS2_MAX_VOL_LABEL_LEN                64
>>
>> I didn't paste the part for removing force type converting.
>>
>> thanks,
>> wengang.
>>
>> Tao Ma wrote:
>>> fs/ocfs2/dir.c: In function ?ocfs2_extend_dir?:
>>> fs/ocfs2/dir.c:2700: warning: ?ret? may be used uninitialized in this 
>>> function
>>>
>>> fs/ocfs2/suballoc.c: In function ?ocfs2_get_suballoc_slot_bit?:
>>> fs/ocfs2/suballoc.c:2216: warning: comparison is always true due to 
>>> limited range of data type
>>>
>>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>>> ---
>>>  fs/ocfs2/dir.c      |    2 +-
>>>  fs/ocfs2/suballoc.c |    2 +-
>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>> index e71160c..eeac241 100644
>>> --- a/fs/ocfs2/dir.c
>>> +++ b/fs/ocfs2/dir.c
>>> @@ -2697,7 +2697,7 @@ static int ocfs2_dx_dir_index_block(struct 
>>> inode *dir,
>>>                      u32 *num_dx_entries,
>>>                      struct buffer_head *dirent_bh)
>>>  {
>>> -    int ret, namelen, i;
>>> +    int ret = 0, namelen, i;
>>>      char *de_buf, *limit;
>>>      struct ocfs2_dir_entry *de;
>>>      struct buffer_head *dx_leaf_bh;
>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>> index b4ca591..eb21dbb 100644
>>> --- a/fs/ocfs2/suballoc.c
>>> +++ b/fs/ocfs2/suballoc.c
>>> @@ -2213,7 +2213,7 @@ static int ocfs2_get_suballoc_slot_bit(struct 
>>> ocfs2_super *osb, u64 blkno,
>>>          goto bail;
>>>      }
>>>  
>>> -    if (le16_to_cpu(inode_fe->i_suballoc_slot) != OCFS2_INVALID_SLOT &&
>>> +    if (le16_to_cpu(inode_fe->i_suballoc_slot) != 
>>> (u16)OCFS2_INVALID_SLOT &&
>>>          (u32)le16_to_cpu(inode_fe->i_suballoc_slot) > osb->max_slots 
>>> - 1) {
>>>          mlog(ML_ERROR, "inode %llu has invalid suballoc slot %u\n",
>>>               blkno, (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
