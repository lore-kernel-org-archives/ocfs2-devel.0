From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 20 Mar 2009 08:41:28 +0800
Subject: [Ocfs2-devel] [RFC] metadata alloc fix in machines which has
	PAGE_SIZE > CLUSTER_SIZE
In-Reply-To: <20090320003022.GC13065@wotan.suse.de>
References: <49C0FDDC.2030704@oracle.com>
	<20090320003022.GC13065@wotan.suse.de>
Message-ID: <49C2E638.4090109@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

Mark Fasheh wrote:
>> So my thought is that can we reuse the freed extent block? I guess we 
>> can. We just need to store the pointer of ocfs2_cached_dealloc_ctxt in 
>> ocfs2_alloc_context. So whenever we allocate a new metadata, we try to 
>> search ocfs2_cached_dealloc_ctxt first, if there is some, we use it 
>> directly and delete it from ocfs2_cached_dealloc_ctxt. The same can go 
>> for cluster allocation I guess although I don't know whether we have 
>> such case for clusters.
>>
>> make sense?
> 
> Yes, but I think a better approach is to fix the core problem, instead of
> working around it. What we want to do then is make ocfs2_lock_allocators
> smart enough to catch this case so that it can reserve the proper amount of
> meta data. The good news is that we already do a scan of the writeable area
> in ocfs2_populate_write_desc(). It seems to me that scan is a good place
> where we could store some information about contiguous extents which will be
> merged. The only thing that'd be left for ocfs2_lock_allocators to do is
> look at the remaining extent block counts.
actually this bug is found in reflink implementations. And in that case, 
it is more complicated. Since we are CoW at most 1M bytes in one 
transaction, that means 256 clusters at most, so we will have a very 
great chance to meet with many steps like this. And my simple test case 
has met with 6 (delete and add) for just one CoW. So I don't think we 
can make ocfs2_lock_allocators that smart enough to overcome it.

And if you look at my patch sent yesterday afternoon, it is very 
straightforward, and it only begin to work in the old BUG_ON scenario. 
So I think it is acceptable.

Regards,
Tao
