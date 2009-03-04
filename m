From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 04 Mar 2009 13:49:13 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix check condition of max
 inline data
In-Reply-To: <49AE15FF.30503@oracle.com>
References: <49ADF2FB.6060503@oracle.com>
	<1236136898-3999-1-git-send-email-tiger.yang@oracle.com>
	<49ADF8E3.8030605@oracle.com> <49AE15FF.30503@oracle.com>
Message-ID: <49AE1659.5000206@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Tiger Yang wrote:
> Hi, Tao,
> 
> yes. ocfs2_max_inline_data_with_xattr() in read_inline_data() is more 
> critical, I think ocfs2_max_inline_data() is also safe before.
> 
> I deliberately left ocfs2_max_inline_data() because in some case, like 
> in mknod, di->i_dyn_features have not been set with 
> OCFS2_INLINE_XATTR_FL or we couldn't get correct di in somewhere.
yes, I already noticed it. But as I have said in the previous mail, 
could you please make it more intelligent? in mknod, we know all the 
cases so we can do it.

Regards,
Tao
> 
> thanks,
> tiger
> 
> Tao Ma wrote:
>> Hi tiger,
>>     I just searched the code in ocfs2. There are other cases(in 
>> ocfs2_read_inline_data) which may have the problem also.
>>
>> So I just think that since you have already added inlin-data-xattr 
>> support in ocfs2, why not remove the function ocfs2_max_inline_data 
>> and use ocfs2_max_inline_data_with_xattr instead in all the cases?  
>> Make it more intelligent?
>>
>> I am just worried that this function may be used wrongly afterwards 
>> and cause future bugs like this.
>>
>> Regards,
>> Tao
>>
>> Tiger Yang wrote:
>>> We should consider the inline xattr when
>>> we try to write inline data.
>>>
>>> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
>>> ---
>>>  fs/ocfs2/aops.c |    5 ++++-
>>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>> index a067a6c..dc6d734 100644
>>> --- a/fs/ocfs2/aops.c
>>> +++ b/fs/ocfs2/aops.c
>>> @@ -1555,6 +1555,7 @@ static int 
>>> ocfs2_try_to_write_inline_data(struct address_space *mapping,
>>>      int ret, written = 0;
>>>      loff_t end = pos + len;
>>>      struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>> +    struct ocfs2_dinode *di = NULL;
>>>  
>>>      mlog(0, "Inode %llu, write of %u bytes at off %llu. features: 
>>> 0x%x\n",
>>>           (unsigned long long)oi->ip_blkno, len, (unsigned long 
>>> long)pos,
>>> @@ -1587,7 +1588,9 @@ static int 
>>> ocfs2_try_to_write_inline_data(struct address_space *mapping,
>>>      /*
>>>       * Check whether the write can fit.
>>>       */
>>> -    if (mmap_page || end > ocfs2_max_inline_data(inode->i_sb))
>>> +    di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
>>> +    if (mmap_page ||
>>> +        end > ocfs2_max_inline_data_with_xattr(inode->i_sb, di))
>>>          return 0;
>>>  
>>>  do_inline_write:
