From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 09 Mar 2009 13:42:48 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: two bug fixes about xattr and
 inline-data
In-Reply-To: <1236575084.6816.35.camel@tristan-laptop.cn.oracle.com>
References: <49ADF2FB.6060503@oracle.com>	
	<20090305023617.GA18729@mail.oracle.com>	
	<1236572226.6816.30.camel@tristan-laptop.cn.oracle.com>	
	<49B4A1B8.10806@oracle.com>
	<1236575084.6816.35.camel@tristan-laptop.cn.oracle.com>
Message-ID: <49B4AC58.4090400@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



tristan.ye wrote:
> On Mon, 2009-03-09 at 12:57 +0800, Tao Ma wrote:
>> Hi tristan,
>> 	the first bug should happen when you create a directory with acl. So do 
>> you have the test case for that?
> 
> Yes, I can add this.
>> 	The second one should happen when you try to try to the inline file and 
>> then you will lose the xattr entry you set.
> 
> Actually, I've had similar testcase, and it never failed to me, that
> means a previously set xattr entry which has reserved 256 bytes in inode
> never be affected or overwriten by the following inline-data writing
> attempt when i_size > MAX_INLINE_SIZE - 256.
Just go through the code and guess  ;) the process should be:
1. fill in some inline data.
2. set entry
3. write i_size > MAX_INLINE_SIZE - 256.

I guess your case miss step 1.

Tiger,
	Can bug 2 reproduced by my guess steps?

Regards,
Tao
> 
> 
> Regards,
> Tristan
> 
> 
> 
> 
>> Regards,
>> Tao
>>
>> tristan.ye wrote:
>>> On Wed, 2009-03-04 at 18:36 -0800, Joel Becker wrote:
>>>> On Wed, Mar 04, 2009 at 11:18:19AM +0800, Tiger Yang wrote:
>>>>> I found two serious bugs about xattr and inline-data.
>>>> Tristan,
>>>> 	Can you add tests for this in the xattr suite?  Thanks!
>>> Of course, I'll be looking back to my testcases, and add these if
>>> missed.
>>>
>>> Actually, I've already had inline-data&inline-xattr combination tests in
>>> xattr testing suite, how can I misse such boundary cases?
>>>
>>> Tiger,
>>>
>>> Thanks for posting the cases:)
>>>
>>> Regards,
>>> Tristan
>>>
>>>
>>>
>>>> Joel
>>>>
>>>>> the first bug:
>>>>> in ocfs2_mknod(), we check and found the ACL or security xattr entry  
>>>>> could be set into inode in ocfs2_calc_xattr_init(), then don't reserve  
>>>>> block for them. But in ocfs2_mknod_locked(), if we found ocfs2 support  
>>>>> inline-data, then set id_count with the max_inline_data. After that, we  
>>>>> set acl/security xattr entry in ocfs2_init_acl() or  
>>>>> ocfs2_init_security_set(), but in there we found inode is full, then  
>>>>> panic at ocfs2_claim_metadata in ocfs2_xattr_block_set.
>>>>>
>>>>> the second bug:
>>>>> we don't check inline xattr in ocfs2_try_to_write_inline_data(), so the  
>>>>> inline data may overwrite the xattr entries which have already in inode.
>>>>>
>>>>>
>>>>> thanks,
>>>>> tiger
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
