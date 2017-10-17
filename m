From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 17 Oct 2017 16:20:15 -0700
Subject: [Ocfs2-devel] [patch] ocfs2: fix qs_holds may could not be zero
In-Reply-To: <7F50894FD17BEC45AAC26E5BADA6CE330C60F99A@H3CMLB12-EX.srv.huawei-3com.com>
References: <7F50894FD17BEC45AAC26E5BADA6CE330C60F99A@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <20171017162015.b2f8faecc23ecd25eb5139f8@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 21 Sep 2017 02:09:33 +0000 Zhangyang <zhang.yangB@h3c.com> wrote:

> In our test, We fond that , when the network down, qs->qs_holds could not be reduce to zero, it will lead to the node can't do fence.
> 
> 
> 
> o2net_idle_timer -> o2quo_conn_err -> qs->qs_holds++, after O2NET_QUORUM_DELAY_MS if qs_holds could be subtract to zero, it could do make_decision.
> 
> But if there are many nodes, when one node network down which contains o2net connections may not do o2net_idle_timer at the same time.
> 
> So when a o2net_node have done nn->nn_still_up, but the qs_holds is not zero. because the other o2net_node have not done nn->nn_still_up.
> 
> So the first o2net_node will do o2net_idle_timer again, and the qs_holds could be add again. And the qs_holds is global variable, so it formed a loop, the node could not do o2quo_make_decision, because of qs_holds never be zero.
> 
> 
> 
> I alter the function o2quo_conn_err, take o2quo_set_hold under control of the bit map qs_conn_bm.

I merged this, subject to review by the ocfs2 maintainers.

The changelog and the comment are really hard to understand.  Perhaps
one of the ocfs2 developers could suggest some more clear words to use?

Thanks.
