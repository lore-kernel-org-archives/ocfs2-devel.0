From: tao.ma <tao.ma@oracle.com>
Date: Tue Nov 20 17:32:53 2007
Subject: [Ocfs2-devel] [PATCH 2/2] Add online resize support for ocfs2,
	take 1
In-Reply-To: <20071121010812.GJ28607@ca-server1.us.oracle.com>
References: <20071116082736.GA3732@tma-pc1.cn.oracle.com>
	<20071116084153.GA3900@tma-pc1.cn.oracle.com>
	<20071121010812.GJ28607@ca-server1.us.oracle.com>
Message-ID: <47438AF4.9060206@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for your review.
Just one thing that I am not clear.
Mark Fasheh wrote:
>> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
>> index 4b32e09..ae08951 100644
>> --- a/fs/ocfs2/journal.h
>> +++ b/fs/ocfs2/journal.h
>> @@ -278,6 +278,9 @@ int                  ocfs2_journal_dirty
>>  /* simple file updates like chmod, etc. */
>>  #define OCFS2_INODE_UPDATE_CREDITS 1
>>  
>> +/* onine resize. Just dinode + last group descriptor update. */
>> +#define OCFS2_ONLINE_RESIZE_CREDITS (2)
>> +
>>  /* get one bit out of a suballocator: dinode + group descriptor +
>>   * prev. group desc. if we relink. */
>>  #define OCFS2_SUBALLOC_ALLOC (3)
>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>> index 6ef8767..099d984 100644
>> --- a/fs/ocfs2/ocfs2_fs.h
>> +++ b/fs/ocfs2/ocfs2_fs.h
>> @@ -27,7 +27,7 @@ #define _OCFS2_FS_H
>>  
>>  /* Version */
>>  #define OCFS2_MAJOR_REV_LEVEL		0
>> -#define OCFS2_MINOR_REV_LEVEL          	90
>> +#define OCFS2_MINOR_REV_LEVEL          	91
>>     
>
> This isn't needed.
>   
This is needed. I'd like to copy your previous comments here.

1) This kind of change requires bumping the protocol version, because
without it the value will get stale on other nodes. We're fine though since
you should be bumping protocol anyway to make sure non-resize capable nodes
don't mount at the same time.
So maybe "the protocol version" your mentioned isn't here? 
