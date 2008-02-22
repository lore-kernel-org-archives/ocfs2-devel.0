From: Tao Ma <tao.ma@oracle.com>
Date: Fri Feb 22 16:11:47 2008
Subject: [Ocfs2-devel] [PATCH 0/3] Add inode stealing for ocfs2.V1
In-Reply-To: <20080222230738.GH27865@ca-server1.us.oracle.com>
References: <20080222084149.GA29738@tma-pc1.cn.oracle.com>
	<20080222230738.GH27865@ca-server1.us.oracle.com>
Message-ID: <47BF64BC.3010207@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh Wrote:
> On Fri, Feb 22, 2008 at 04:41:49PM +0800, tao.ma wrote:
>   
>> 	This patch set improve the method for inode allocation. Now they
>> are divided into 3 small patches, but I think maybe they can be merged
>> together as one. Any comments are welcomed.
>>     
>
> Thank you for the thorough description. One thing that was left out - could
> you give me a short description of how these changes were tested?
>   
I have created a test script. It will create some inode in other nodes, 
then use up all the spaces in the volume and all the inodes in the this 
node's local inode_alloc. Then it will try to allocate from other nodes. 
I am using debugfs.ocfs2 to check whether the "i_suballoc_slot" for the 
new created inode is in the right slot and then delete it to be sure 
kernel can handle it successfully. In the end, the volume will be 
umounted and fscked for any possible error.
Since this patch is only V1, I'm ready for any comments and will modify 
the test scripts according to the new modification.
>
>   
>> In OCFS2, we allocate the inodes from slot specific inode_alloc to avoid
>> inode creation congestion. The local alloc file grows in a large contiguous
>> chunk. As for a 4K bs, it grows 4M every time. So 1024 inodes will be
>> allocated at a time.
>>
>> Over time, if the fs gets fragmented enough(e.g, the user has created many
>> small files and also delete some of them), we can end up in a situation,
>> whereby we cannot extend the inode_alloc as we don't have a large chunk
>> free in the global_bitmap even if df shows few gigs free. More annoying is
>> that this situation will invariably mean that while one cannot create inodes
>> on one node but can from another node. Still more annoying is that an unused
>> slot may have space for plenty of inodes but is unusable as the user may not
>> be mounting as many nodes anymore.
>>
>> This patch series implement a solution which is to steal inodes from another
>> slot. Now the whole inode allocation process looks like this:
>> 1. Allocate from its own inode_alloc:000X
>>    1) If we can reserve, OK.
>>    2) If fails, try to allocate a large chunk and reserve once again.
>>     
>
> Do you have a mechanism in place to remember which inode alloc file you were
> last able to sucessfully allocate from? If you did that, then we could avoid
> needlessly searching our own slot every time.
>
> You could even reset your "last inode alloc slot" pointer to the local slot
> when space is freed from the local allocator.
>   
You are right. I don't have this mechanism. I will investigate on it and 
see how it can works. Thanks.
>
>   
>> 2. If 1 fails, try to allocate from the last node's inode_alloc. This time,
>>    Just try to reserve, we don't go for global_bitmap if this inode also
>>    can't allocate the inode.
>>     
>
> Does every node go to the same inode allocator after it's own? Wouldn't this
> create a lot of traffic in one slot?
>
> Why not search inode alloc in the next slot and loop back until you reach
> yours again? So, if the nodes slot is '3' and max slots is 6, it'd search
> 4, 5, 0, 1, 2 before giving up.
>   
Not sure whether your suggestion is reasonable. I start from the last 
node because:
1. It is not often used like others.
2. If there is only one node whose inode alloc is full, it will only 
contact the last node so that the congestion will be mainly between this 
one and the last one.
3. If there is more nodes whose inode allocs are full, there is a very 
large chance that all the mounted one are full, so the very first times 
of inode alloc may just fail until it reach a really empty node. And I 
think the node which has the largest chance of "being empty" is the last 
node.
Make sense?
So I think maybe if I add the mechanism of recording "last inode alloc 
slot", it should work OK.
Comments?
>
>   
>> 3. If 2 fails, try the node before it until we reach inode_alloc:0000.
>>    In the process, we will skip its own inode_alloc.
>>     
>
>   
>> 4. If 3 fails, try to allocate from its own inode_alloc:000X once again. Here
>>    is a chance that the global_bitmap may has a large enough chunk now during
>>    the inode iteration process.
>>     
>
> What are the chances that the global bitmap emptied enough in the time it
> took us to search the other allocators? It doesn't seem like that would
> happen very much, so I wouldn't bother with this last step unless we had
> evidence that it would make a real difference.
>   
OK, I will try to find out whether there is a real scenario. If none, I 
wil remove this.

Regards,
Tao
