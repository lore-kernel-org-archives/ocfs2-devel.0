From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 13 Aug 2008 08:13:21 +0800
Subject: [Ocfs2-devel] [PATCH 13/15] Enable xattr set in index btree. v3
In-Reply-To: <20080812231751.GK21187@wotan.suse.de>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-11-git-send-email-tao.ma@oracle.com>
	<20080812231751.GK21187@wotan.suse.de>
Message-ID: <48A22721.7080102@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh Wrote:
> On Thu, Aug 07, 2008 at 06:31:33AM +0800, Tao Ma wrote:
>   
>> Modification from V2 to V3:
>> 1. Remove kmalloc+memcpy in set.
>> 2. Remove xattr entry when we fails to find the enough space for outside
>>    storage.
>> 3. Empty the whole block when creating new xattr bucket.
>> 4. Limit xattr entry to be only in 1st block of the bucket and limit xattr
>>    name/value pair within the same block.
>> 5. Limit the xattr tree leaf size to be 64K.
>>     
>
> Ok, this is looking good Tao.
>
> I think I figured out what xh_offset is. Basically, ea name/value pairs grow
> from the end of the bucket forward, and you're just using it to mark the
> 'top' of that stack so that insertion doesn't have to search the entire
> bucket. You're relying on a (hopefully rare) defrag of the bucket to
> eliminate holes created by ea removal. I guess we'll only have to worry
> about defragging when the bucket is full.
>   
yes, you are right. As for defragging, please see 
ocfs2_xattr_set_entry_index_block, when we found it is full, we will 
creat a new bucket and move half of the xattr to the new bucket.
> Is this all correct? If so, there might be a more descriptive variable name
> we can use...
>   
so how about xh_store_end? Sorry for my poor English. Or maybe you can 
give me a good name. ;)

Regards,
Tao
