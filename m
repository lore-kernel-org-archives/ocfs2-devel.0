From: Norton.Zhu <norton.zhu@huawei.com>
Date: Mon, 24 Aug 2015 20:30:35 +0800
Subject: [Ocfs2-devel] [RFC] ocfs2: Idea to make ocfs2_search_chain high
 efficiency
Message-ID: <55DB0E6B.2000606@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_search_chain, I found it has low efficiency  while searching an available gd in some circumstances:
1) The lun has a great many gd(it reads lots of unavailable gd(free bits is zero));
2) Not too many gd, but the available gd is scattered in the unavailable gd(fragmentation);

So I have an idea to optimize the search method:
1) Use the reserved member in the ocfs2_group_desc to make an available chain list(gds in the list are all available, free bits more than zero);
2) At the beginning, the chain list is the same with origin chain list;
3) While do allocation, it searches gd in the available chain list;
4) After each allocation, if some gd's free bits is zero, Remove it from the available chain list;
5) After each reclaim, if some gd's free bits change from zero to positive, Append it to the head of the available chain list;

Once started with the basics outlined above, no unavailable gd will be read.

Anyone has better ideas or advices?
