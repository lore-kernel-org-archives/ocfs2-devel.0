From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 28 Dec 2017 06:38:31 +0000
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: try to reuse extent block in
 dealloc without meta_alloc
References: <63ADC13FD55D6546B7DECE290D39E373F2908FC7@H3CMLB12-EX.srv.huawei-3com.com>
	<5A448D59.4040603@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F2909D75@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Alex,

On 2017/12/28 14:22, alex chen wrote:
> Hi Changwei,
> 
>> @@ -1347,8 +1362,15 @@ static int ocfs2_shift_tree_depth(handle_t *handle,
>>    	struct ocfs2_extent_list  *root_el;

>> @@ -1762,8 +1764,8 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>>    		 */
>>    		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
>>    					      wc->w_di_bh);
>> -		ret = ocfs2_lock_allocators(inode, &et,
>> -					    clusters_to_alloc, extents_to_split,
>> +		ret = ocfs2_lock_allocators(inode, &et, clusters_to_alloc,
>> +					    2*extents_to_split,
>>    					    &data_ac, &meta_ac);
> We has doubled extent number in ocfs2_populate_write_desc(), so here we don't need to double again.

I think your comment here makes sense.
I will remove the multiplier 2 in my next version of this patch.

Thanks,
Changwei


> 
> Thanks,
> Alex

> 
