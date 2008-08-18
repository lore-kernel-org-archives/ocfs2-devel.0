From: TaoMa <tao.ma@oracle.com>
Date: Mon, 18 Aug 2008 20:52:59 +0800
Subject: [Ocfs2-devel] [PATCH 07/15] Add extent tree operation for xattr
 value.v3
In-Reply-To: <20080816032906.GA6393@mail.oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-7-git-send-email-tao.ma@oracle.com>
	<20080816021854.GA31499@mail.oracle.com>
	<20080816032906.GA6393@mail.oracle.com>
Message-ID: <48A970AB.8030706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, Aug 15, 2008 at 07:18:54PM -0700, Joel Becker wrote:
>   
>> 	Why don't you have an operation for getting the el?  Really, the
>> way I see it, you should have:
>>
>>     void ocfs2_fill_extent_tree(*et, *bh, void *object, type)
>>     {
>>             et->et_type = type;
>>             et->et_ops = extent_tree_ops[type];
>>             get_bh(bh);
>>             et->et_root_bh = bh;
>>             et->et_object = object ? object : (void *)bh->b_data;
>>             et->et_root_el = et->et_ops->et_get_root_el(et);
>>     }
>>
>> If you pass NULL for *object, it knows to use the start of the bh.  This
>> works for dinode, etc.  But you can pass a non-NULL object for the
>> xattr_value_root.  The get_root_el operations know how to take et_object
>> and return the el:
>>     
>
> <snip>
>
>   
>>> -int ocfs2_insert_extent(struct ocfs2_super *osb,
>>> -			handle_t *handle,
>>> -			struct inode *inode,
>>> -			struct buffer_head *root_bh,
>>> -			u32 cpos,
>>> -			u64 start_blk,
>>> -			u32 new_clusters,
>>> -			u8 flags,
>>> -			struct ocfs2_alloc_context *meta_ac,
>>> -			enum ocfs2_extent_tree_type et_type)
>>> +static int ocfs2_insert_extent(struct ocfs2_super *osb,
>>> +			       handle_t *handle,
>>> +			       struct inode *inode,
>>> +			       struct buffer_head *root_bh,
>>> +			       u32 cpos,
>>> +			       u64 start_blk,
>>> +			       u32 new_clusters,
>>> +			       u8 flags,
>>> +			       struct ocfs2_alloc_context *meta_ac,
>>> +			       struct ocfs2_extent_tree *et)
>>>       
>> 	Here you are passing in the et, so you don't need root_bh
>> anymore, right
>>     
>
> 	In fact, you don't need
> xattr_insert_extent/dinode_insert_extent.  Just have the callers of
> ocfs2_insert_extent create an extent tree (they're almost doing so
> already) and then pass it to ocfs2_insert_extent.
>   
Actually this is the consensus that Mark and I have made. See
http://oss.oracle.com/pipermail/ocfs2-devel/2008-June/002332.html
> 	Conversely, if you really like those wrappers, have them turn
> cpos/start_blk/new_clusters into an extent_rec before calling
> ocfs2_insert_extent.  It can be passed straight down into
> do_insert_extent.
>   
yes, this sounds reasonable since ocfs2_extent_rec will be created in 
ocfs2_insert_extent also. So we just move it to the 3 different callers.
Mark, agree?

Regards,
Tao
