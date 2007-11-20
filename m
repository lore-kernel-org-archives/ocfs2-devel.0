From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Nov 20 20:01:06 2007
Subject: [Ocfs2-devel] [PATCH 2/2] Add online resize support for ocfs2,
	take 1
In-Reply-To: <47439A32.6050406@oracle.com>
References: <20071116082736.GA3732@tma-pc1.cn.oracle.com>
	<20071116084153.GA3900@tma-pc1.cn.oracle.com>
	<20071121010812.GJ28607@ca-server1.us.oracle.com>
	<47438AF4.9060206@oracle.com>
	<20071121015258.GK28607@ca-server1.us.oracle.com>
	<47439A32.6050406@oracle.com>
Message-ID: <20071121040051.GL28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 21, 2007 at 10:38:42AM +0800, tao.ma wrote:
> Mark Fasheh wrote:
>> On Wed, Nov 21, 2007 at 09:33:40AM +0800, tao.ma wrote:
>>   
>>> Thanks for your review.
>>> Just one thing that I am not clear.
>>> Mark Fasheh wrote:
>>>     
>>>>> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
>>>>> index 4b32e09..ae08951 100644
>>>>> --- a/fs/ocfs2/journal.h
>>>>> +++ b/fs/ocfs2/journal.h
>>>>> @@ -278,6 +278,9 @@ int                  ocfs2_journal_dirty
>>>>>  /* simple file updates like chmod, etc. */
>>>>>  #define OCFS2_INODE_UPDATE_CREDITS 1
>>>>>  +/* onine resize. Just dinode + last group descriptor update. */
>>>>> +#define OCFS2_ONLINE_RESIZE_CREDITS (2)
>>>>> +
>>>>>  /* get one bit out of a suballocator: dinode + group descriptor +
>>>>>   * prev. group desc. if we relink. */
>>>>>  #define OCFS2_SUBALLOC_ALLOC (3)
>>>>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>>>>> index 6ef8767..099d984 100644
>>>>> --- a/fs/ocfs2/ocfs2_fs.h
>>>>> +++ b/fs/ocfs2/ocfs2_fs.h
>>>>> @@ -27,7 +27,7 @@ #define _OCFS2_FS_H
>>>>>   /* Version */
>>>>>  #define OCFS2_MAJOR_REV_LEVEL		0
>>>>> -#define OCFS2_MINOR_REV_LEVEL          	90
>>>>> +#define OCFS2_MINOR_REV_LEVEL          	91
>>>>>             
>>>> This isn't needed.
>>>>         
>>> This is needed. I'd like to copy your previous comments here.
>>>
>>> 1) This kind of change requires bumping the protocol version, because
>>> without it the value will get stale on other nodes. We're fine though 
>>> since
>>> you should be bumping protocol anyway to make sure non-resize capable 
>>> nodes
>>> don't mount at the same time.
>>> So maybe "the protocol version" your mentioned isn't here?     
>>
>> Yeah, I was referring to O2NET_PROTOCOL_VERSION in cluster/tcp_internal.h
>>
>> However, if we refuse a change to any file system if the disk bitmap_cpg 
>> is
>> wrong, then I don't think we need to bump the protocol version after all 
>> as
>> the value should never change past mount and thus won't ever be stale on 
>> any
>> node.
>>   
>
> As you have said, we have to bump protocol to make sure non-resize capable 
> nodes don't mount at the same time. ;) So do you think 2 node(one know 
> online-resize, one don't know it) can work happily with each other if we do 
> online resize in the one who knows it?

I think so - they don't ever care about the size of hte volume unless they
lock the global bitmap which means they've updated it from disk or lvb. This
should be pretty easy to test though, so you could do that to be sure.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
