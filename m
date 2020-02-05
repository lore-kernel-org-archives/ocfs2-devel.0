From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Wed, 5 Feb 2020 16:40:33 +0800
Subject: [Ocfs2-devel] [PATCH] OCFS2: remove useless err
In-Reply-To: <2550e871-f930-92d1-4c75-fcd84fc20021@linux.alibaba.com>
References: <1579577836-251879-1-git-send-email-alex.shi@linux.alibaba.com>
	<5aa17eac-60ee-5360-81f9-7bff2cb76eb3@linux.alibaba.com>
	<f5c1b5cd-6fd2-f198-97e3-a4f34e990ba8@linux.alibaba.com>
	<2550e871-f930-92d1-4c75-fcd84fc20021@linux.alibaba.com>
Message-ID: <cab8dfcf-e254-694a-9993-c20388a9e9b6@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 20/2/4 19:34, Joseph Qi wrote:
> 
> 
> On 20/2/4 18:59, Alex Shi wrote:
>>
>>
>> ? 2020/1/26 ??9:52, Joseph Qi ??:
>>>
>>
>>>>  
>>>> @@ -708,7 +708,7 @@ static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
>>>>  				num++;
>>>>  
>>>>  				bh = NULL;
>>>> -				err = ocfs2_read_dir_block(dir, b++, &bh,
>>>> +				ocfs2_read_dir_block(dir, b++, &bh,
>>>>  							   OCFS2_BH_READAHEAD);
>>>
>>> Umm... missing error checking here?
>>
>>
>> /*
>>  * This function forces all errors to -EIO for consistency with its
>>  * predecessor, ocfs2_bread().  We haven't audited what returning the
>>  * real error codes would do to callers.  We log the real codes with
>>  * mlog_errno() before we squash them.
>>  */
>> static int ocfs2_read_dir_block(struct inode *inode, u64 v_block,
>>                                 struct buffer_head **bh, int flags)
>>
>> According to ocfs2_read_dir_block comments, caller don't care the err value, func will log it.
>>
>> So is this patch ok? :)
>>
> If we got error here, it means the buffer head is invalid.
> So how about mark it as NULL and skip it?
> 

Okay, in this case, bh is already NULL and will skip below,
so it looks fine to me.
