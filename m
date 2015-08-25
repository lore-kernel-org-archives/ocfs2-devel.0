From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Tue, 25 Aug 2015 11:49:55 -0700
Subject: [Ocfs2-devel] [RFC] ocfs2: Idea to make ocfs2_search_chain high
 efficiency
In-Reply-To: <55DB0E6B.2000606@huawei.com>
References: <55DB0E6B.2000606@huawei.com>
Message-ID: <55DCB8D3.7020809@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Another idea is to have a background thread to work in the background
scanning  chains to put the gd with optimum, not necessarily the maximum,
number of free clusters in the front (similar to what in-line alloc does 
today, but
do it in background).

While a chain is being worked upon by the bg thread, it will be markedi
"forbidden" to the normal in-line allocators, who will skip it.
Eventually a state will be reached when an allocation request will find 
the 1st
gd to satisfy alloc req, reducing and eliminating in-line traversal 
looking for
a gd with large enough free chunk. . The thread will continuously work
  in the background on every chain in an endless loop.
Thanks
-Tariq Saeed

On 08/24/2015 05:30 AM, Norton.Zhu wrote:
> In ocfs2_search_chain, I found it has low efficiency  while searching an available gd in some circumstances:
> 1) The lun has a great many gd(it reads lots of unavailable gd(free bits is zero));
> 2) Not too many gd, but the available gd is scattered in the unavailable gd(fragmentation);
>
> So I have an idea to optimize the search method:
> 1) Use the reserved member in the ocfs2_group_desc to make an available chain list(gds in the list are all available, free bits more than zero);
> 2) At the beginning, the chain list is the same with origin chain list;
> 3) While do allocation, it searches gd in the available chain list;
> 4) After each allocation, if some gd's free bits is zero, Remove it from the available chain list;
> 5) After each reclaim, if some gd's free bits change from zero to positive, Append it to the head of the available chain list;
>
> Once started with the basics outlined above, no unavailable gd will be read.
>
> Anyone has better ideas or advices?
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
