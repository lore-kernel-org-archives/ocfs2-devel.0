From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 01 Aug 2013 11:57:16 -0700
Subject: [Ocfs2-devel] Why ocfs2 haven't implemented "steal" for
 local_alloc system files?
In-Reply-To: <51FA1E77.8060207@huawei.com>
References: <51F3A091.4090605@huawei.com>
	<CAEeiSHVsUGvBRR3iN4TpQqHVN4+KD6aV+e2nEGZ7ouYOWJEhpw@mail.gmail.com>
	<20130801072008.GA15266@localhost> <51FA1E77.8060207@huawei.com>
Message-ID: <51FAAF8C.9090006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 08/01/2013 01:38 AM, Younger Liu wrote:
> On 2013/8/1 15:20, Joel Becker wrote:
>> Basically, there's so little in the cache that stealing would be too
>> complex.  Really we just want to fall back to the global, and if that is
>> empty, you're near enough ENOSPC that it doesn't much matter.
>>
>> Joel
>>
> Localalloc is a mount option. When mounting an ocfs2 volume, localalloc can
> be set a larger size. For example, 2G or a larger number.
>
> In a multi-nodes cluster, all nodes mount ocfs2 volume with localalloc=2048
Is there a proof that localalloc=2048 performs better than default 256Mb 
? local alloc currently looks for contiguous chunks. setting it to 2gb 
means it has to scan the whole bitmap to find that big of a chunk which 
in itself defeats the purpose of setting it to 2gb. I mean it might work 
well for a filesystem that just got formatted but as it gets used 
finding 2gb chunks is hard.

> for performance consideration, if a node claims space for a file, but there
> is no space in the local_alloc and global_bitmap. It would return ENOSPC.
> However, other nodes may have lots of space which have been claimed
> in local_alloc, so ENOSPC cannot reflect the actual situation.
>
> IMO, if there is no space both in the local_alloc and global_bitmap,
> it should steal space from other nodes local_alloc.
>
> Thx,
> Younger.
>
>> On Wed, Jul 31, 2013 at 08:33:48PM -0700, Sunil Mushran wrote:
>>> Because it makes no sense. Unlike inode/extent allocs, local_alloc is a
>>> temporary cache. If you fail to allocate, you fallback to the global bitmap.
>>>
>>>
>>> On Sat, Jul 27, 2013 at 3:27 AM, Younger Liu <younger.liu@huawei.com> wrote:
>>>
>>>> Hi,
>>>>    While analyzing ocfs2 block allocation, I found:
>>>>    When claiming space from inode_alloc (or extent_alloc) system files,
>>>> if there is no enough space in inode_alloc (or extent_alloc) and
>>>> global_bitmap, it could steal space from other slots.
>>>>    But when claiming space from local_alloc system files, and no
>>>> enough space in local_alloc and global_bitmap, it returns -ENOSPC.
>>>>
>>>>    Why ocfs2 haven't implemented "steal" for local_alloc system files?
>>>>    Is there any some reasons?
>>>>
>>>>
>>>> _______________________________________________
>>>> Ocfs2-devel mailing list
>>>> Ocfs2-devel at oss.oracle.com
>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
