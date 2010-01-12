From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 12 Jan 2010 11:14:34 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock() dead
 lock
In-Reply-To: <20100112143050.GB4209@laptop.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>	<20100107020005.GC20095@mail.oracle.com>	<20100109180521.GA5148@laptop.oracle.com>	<20100112015946.GE20285@mail.oracle.com>	<20100112035835.GA3675@laptop.oracle.com>	<20100112111802.GB3821@mail.oracle.com>	<20100112120419.GA4209@laptop.oracle.com>	<20100112130129.GD3821@mail.oracle.com>
	<20100112143050.GB4209@laptop.oracle.com>
Message-ID: <4B4CCA1A.2050403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> Is it a rule that If the lock is not currently taken it will return "go
> ahead and downconvert"?

In short, yes, because of fairness.

Not having holders is one of the checks. If there are incompatible
holders then it will requeue the lockres in the blocked queue. The
lockres will be re-processed when the dc thread is kicked the
next time. If there are no holders and the journal is checkpointed
(or check_downconvert succeeds), then yes, it will be downconvert.

> by checking ocfs2_check_meta_downconvert(), I think it ensures cache is
> checkpointed by JBD(2) before returning "go ahead and downconvert".
> maybe yes that you noticed that we can't have cache if we don't have
> EX, I think the main purpose is that it ensures that we finish things which we
> should finish before we release the lock. another evidence is that it
> doesn't check the ex_holders.

check_downconvert() is an additional check. The holders check tells the fs
whether it can and whether it needs to down convert or not. If answer to
both qs is yes, then it sees whether there are any lock type specific
checks. M and T lock types want the journal check pointed before a dc.

> another question is that you can find out ocfs2_check_meta_downconvert()
> checks if lock is taken(not explicitly), can you make such a conclusion
> that all check_downconvert() follows it? --sorry, I didn't check them
> and pushed it to you :P --I will check them too later.
>
> so still the question, is it a rule that check_downconvert() should 
> return "go ahead and downconvert" if the lock is not currently taken?
> and also, what means "currently taken"? --ocfs2 layer(after
> ocfs2_cluster_lock() returns) or dlm level? though I guess you meant
> ocfs2 layer.

I am confused by your qs. Have you read the description of 
check_downconvert()?


        /*
         * Allow a lock type to add checks to determine whether it is
         * safe to downconvert a lock. Return 0 to re-queue the
         * downconvert at a later time, nonzero to continue.
         *
         * For most locks, the default checks that there are no
         * incompatible holders are sufficient.
         *
         * Called with the lockres spinlock held.
         */
        int (*check_downconvert)(struct ocfs2_lock_res *, int);

Sunil
