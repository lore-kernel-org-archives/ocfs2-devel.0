From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 10:14:12 +0800
Subject: [Ocfs2-devel] [PATCH 07/16] Add extent tree operation for xattr
 value.
In-Reply-To: <20080821020255.GD4563@wotan.suse.de>
References: <48A929A4.90103@oracle.com>
	<1219052334-10415-7-git-send-email-tao.ma@oracle.com>
	<20080821005737.GB28632@mail.oracle.com>
	<48ACBECD.4010506@oracle.com> <20080821012106.GC4563@wotan.suse.de>
	<48ACC65C.9020008@oracle.com> <20080821020255.GD4563@wotan.suse.de>
Message-ID: <48ACCF74.1000900@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Thu, Aug 21, 2008 at 09:35:24AM +0800, Tao Ma wrote:
>   
>> Mark Fasheh wrote:
>>     
>>> [ Joel, good catch ]
>>>
>>> On Thu, Aug 21, 2008 at 09:03:09AM +0800, Tao Ma wrote:
>>>  
>>>       
>>>>> BUG when growing that xattr extent tree?
>>>>> 	Next, a few lines down:
>>>>>
>>>>>        mlog_bug_on_msg(!ocfs2_sparse_alloc(osb) &&
>>>>>                        (OCFS2_I(inode)->ip_clusters != cpos),
>>>>>                        "Device %s, asking for sparse allocation: inode 
>>>>>                        %llu, "
>>>>>                        "cpos %u, clusters %u\n",
>>>>>                        osb->dev_str,
>>>>>                        (unsigned long long)OCFS2_I(inode)->ip_blkno, 
>>>>>                        cpos,
>>>>>                        OCFS2_I(inode)->ip_clusters);
>>>>>
>>>>> Won't that BUG() when cpos of an xattr extent is not matching the
>>>>> ip_clusters of the data?
>>>>>  
>>>>>      
>>>>>           
>>>> yeah, you are right, we should move these 2 into 
>>>> ocfs2_dinode_insert_extent. thx.
>>>>    
>>>>         
>>> It might be a good idea for us to run this on a file system without sparse
>>> file support to catch any issues that don't show up during review. 
>>> Probably,
>>> running with / without inline-data helps too. Conceptually though, we 
>>> should
>>> be safe - anything that supports EA's has all the sparse-file code,
>>> regardless of whether we allow the inode data btree to be sparse or not.
>>> It's all just a matter of making sure the proper checks are in the right
>>> place.
>>>  
>>>       
>> Yes, we may need to add some test cases for inline-data volume. As for 
>> sparse, currently, in Tiger's mkfs patch, xattr depends on sparse, so it 
>> will add sparse automatically, so I am not sure whether we can test 
>> xattr without sparse.
>>     
>
> It should *not* depend on sparse. I'm pretty sure we discussed this
> already...
>   
Sorry for my bad memory :(, but I really can't recall it.
As for xattr tree, we should have a very large possibility that we will 
have a sparse tree because of the hash value.
So we don't allow the user to use extent tree when he doesn't set 
"sparse"? only large ea are supported then?
That also means I should add another bug fix to check whether the sparse 
is enabled when creating a xattr tree.

Regards,
Tao
