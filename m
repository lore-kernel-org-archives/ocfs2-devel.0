From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 25 Nov 2009 15:59:46 +0800
Subject: [Ocfs2-devel] what is global bitmap, block group, suballocator,
 etc
In-Reply-To: <4B0CE011.3030403@suse.de>
References: <4B0CE011.3030403@suse.de>
Message-ID: <4B0CE3F2.8040503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Coly,

Coly Li wrote:
> Hi list,
> 
> There are some ocfs2 terminologies that I don't understand very well. After checking the ocfs2 wiki and kernel/tools
> code, I am still not sure whether I understand them correctly.
> 
> - Global bitmap
>   What's the usage of global bitmap? Which kind of resource allocation will set global bitmap?
global bitmap is a system file which indicates the usage of clusters in 
  the whole volume. It is a chain file. So it has a ocfs2_chain_list in 
its ocfs2_dinode.id2. And the chain_list is a chain of many groups. A 
group is a range of clusters and the 1st block of a group has a bitmap 
to indicate which cluster(or block, cpg is used here) is allocated or not.
> 
> - Cluster group
>   It seems cluster group is similar to block group of ext3/4. Does each node of the cluster has its own data/metadata
> bitmap inode in every cluster group ?
See group above.
> 
> - Block group
>   From Tiger's slide, I don't find block group. But from fs/ocfs2 code, I see block group. Is it same to cluster group ?
you mean ocfs2_block_group_alloc? Actually we allocates clusters from 
the allocators(see ocfs2_claim_clusters) and then call 
ocfs2_block_group_fill to fill it into different system 
file(inode_alloc, extent_alloc).
> 
> - Suballocator & Suballocator slot
>   I don't find related document explains what is suballocator and how it works. I am checking the code now, but not
> clear to me yet.
suballocator is used so that when a node try to get some resource, it 
will try its own suballocator first. If it can't get the resource it 
wants, we have to lock the global_bitmap(there are some cases we can try 
local_alloc first and if it fails, then try global_bitmap) and ask from 
that(it will need a global lock which needs more time). We we the 
suballocator grows, it will request a large hunk from the global bitmap 
so that the next attempt can success in suballocator. There are 
inode_alloc for inode, extent_alloc for extent, and local_alloc(it can 
be used by extent_alloc allocation or cluster allocation).

Regards,
Tao
