From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 24 Aug 2015 09:57:26 -0700
Subject: [Ocfs2-devel] [RFC] ocfs2: Idea to make ocfs2_search_chain high
 efficiency
In-Reply-To: <55DB0E6B.2000606@huawei.com>
References: <55DB0E6B.2000606@huawei.com>
Message-ID: <55DB4CF6.9030307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Norton,

while the localalloc bmp is enabled the chances of a particular gd 
ending with zero free bits is very minimal. local alloc bmp will pick 
next gd once min number of free bits falls below localalloc bmp size. So 
next gd is picked while the current gd still has free space.

Having said that, I understand the problem you are describing. Since we 
only move the gd with more free bits ahead of the previous unusable gd 
we end of rescanning unusable gds whenever the newly picked gd becomes 
unusable. This is inefficient and causes performance problem when fs 
gets fragmented

I am not sure if we will be allowed to use the bg_reserved2 ... but if 
we are then we could use it to remember  next gd we should look at.

For example, if we assume there are 'N' GDs and we are currently seeing 
that GD10 has more free space ... so the order of GDs are

GD10, GD1, GD2, ... GDN.

Now if we end up using most of the space in GD10, according to current 
logic we re-read GD1, GD2.. GD9 and then read GD11 and pick that 
(assuming it has free space). But instead if we had GD10 remembers GD11 
as the next one to look at ... then we can skip reading GD1..GD9.

Thanks,
--Srini


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
