From: Ryan Ding <ryan.ding@oracle.com>
Date: Wed, 05 Aug 2015 12:40:10 +0800
Subject: [Ocfs2-devel] [PATCH 0/9 v6] ocfs2: support append O_DIRECT
	write
In-Reply-To: <55C07FFA.4060701@huawei.com>
References: <55C058D6.9030809@oracle.com> <55C07FFA.4060701@huawei.com>
Message-ID: <55C193AA.5020508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,


On 08/04/2015 05:03 PM, Joseph Qi wrote:
> Hi Ryan,
>
> On 2015/8/4 14:16, Ryan Ding wrote:
>> Hi Joseph,
>>
>> Sorry for bothering you with the old patches. But I really need to know what this patch is for.
>>
>> https://oss.oracle.com/pipermail/ocfs2-devel/2015-January/010496.html
>>
>>  From above email archive, you mentioned those patches aim to reduce the host page cache consumption. But in my opinion, after append direct io, the page used for buffer is clean. System can realloc those cached pages. We can even call invalidate_mapping_pages to fast that process. Maybe more pages will be needed during direct io. But direct io size can not be too large, right?
>>
> We introduced the append direct io because originally ocfs2 would fall
> back to buffer io in case of thin provision, which was not the actual
> behavior that user expect.
direct io has 2 semantics:
1. io is performed synchronously, data is guaranteed to be transferred 
after write syscall return.
2. File I/O is done directly to/from user space buffers. No page buffer 
involved.
But I think #2 is invisible to user space, #1 is the only thing that 
user space is really interested in.
We should balance the benefit and disadvantage to determine whether #2 
should be supported.
The disadvantage is: bring too much complexity to the code, bugs will 
come along. And involved a incompatible feature.
For example, I did a single node sparse file test, and it failed.
The original way of ocfs2 handling direct io(turn to buffer io when it's 
append write or write to a file hole) has 2 consideration:
1. easier to support cluster wide coherence.
2. easier to support sparse file.
But it seems that your patch handle #2 not very well.
There may be more issues that I have not found.
> I didn't get you that more pages would be needed during direct io. Could
> you please explain it more clearly?
I mean the original way of handle append-dio will consume some page 
cache. The page cache size it consume depend on the direct io size. For 
example, 1MB direct io will consume 1MB page cache.But since direct io 
size can not be too large, the page cache it consume can not be too 
large also. And those pages can be freed after direct io finished by 
calling invalidate_mapping_pages().
>
> Thanks,
> Joseph
>
>> Thanks,
>> Ryan
>>
>>
>
