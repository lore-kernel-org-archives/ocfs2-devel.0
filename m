From: Eric Ren <zren@suse.com>
Date: Fri, 22 Jan 2016 10:32:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlmglue: fix false deadlock caused
 by clearing UPCONVERT_FINISHING too early
In-Reply-To: <20160121150558.0f65f82afd7d38aa1df17b22@linux-foundation.org>
References: <1453222013-9425-1-git-send-email-zren@suse.com>
	<56A0845C.5050208@oracle.com> <20160121081054.GA19164@laptop.ha>
	<56A0945E.40206@oracle.com>
	<20160121150558.0f65f82afd7d38aa1df17b22@linux-foundation.org>
Message-ID: <20160122023246.GA8057@laptop.ha>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

On Thu, Jan 21, 2016 at 03:05:58PM -0800, Andrew Morton wrote: 
> On Thu, 21 Jan 2016 16:18:38 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
> 
> > On 01/21/2016 04:10 PM, Eric Ren wrote:
> > > Hi Junxiao,
> > > 
> > > On Thu, Jan 21, 2016 at 03:10:20PM +0800, Junxiao Bi wrote: 
> > >> Hi Eric,
> > >>
> > >> This patch should fix your issue.
> > >> "NFS hangs in __ocfs2_cluster_lock due to race with ocfs2_unblock_lock"
> > > 
> > > Thanks a lot for bringing up this patch! It hasn't been merged into mainline(
> > > at least 4.4), right?
> > Right, it is still in linux-next.
> 
> I'll be sending it to Linus today.

Thanks! This patch can also avoid the deadlock in my case. It make sense into mainline now.
But there still remains another problem, that is, it may not be fair enough for the node which
have more than one threads resting on mask-waiter list during OCFS2_LOCK_BUSY was set. Now,
it only give one of those waiters the chance of retry, then clear UPCONVERT_FINISHING, and
then start the downconvert thread.

I think it should be better to let every waiter retry beforing down conversion. However,
it's more complex. We could discuss and fix it in a new thread later;-)

THX,
Eric

> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
