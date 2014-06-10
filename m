From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jun 2014 15:51:04 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: correctly check the return value
 of ocfs2_search_extent_list
In-Reply-To: <5397047B.6030406@huawei.com>
References: <5397047B.6030406@huawei.com>
Message-ID: <20140610155104.6a9d3e412377ef4d569b1e3f@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 10 Jun 2014 21:13:31 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> ocfs2_search_extent_list may return -1, so we should check the return
> value in ocfs2_split_and_insert, otherwise it may cause array index out
> of bound.
> And ocfs2_search_extent_list can only return value less than
> el->l_next_free_rec, so check if it is equal or larger than
> le16_to_cpu(el->l_next_free_rec) is meaningless.

So I need to decide which kernel version(s) need this patch.  3.16? 
3.15?  -stable?

But the changelog did not provide the information needed to make this
decision.  Please always provide this information when fixing bugs! 
ie: describe the end-user visible impact of the bug.

Thanks.
