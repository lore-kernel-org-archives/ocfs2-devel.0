From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 12 Jan 2010 22:30:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock()
	dead	lock
In-Reply-To: <20100112130129.GD3821@mail.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<20100112015946.GE20285@mail.oracle.com>
	<20100112035835.GA3675@laptop.oracle.com>
	<20100112111802.GB3821@mail.oracle.com>
	<20100112120419.GA4209@laptop.oracle.com>
	<20100112130129.GD3821@mail.oracle.com>
Message-ID: <20100112143050.GB4209@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-01-12 05:01, Joel Becker wrote:
> > so maybe you don't notice the lockres->l_ops->check_downconvert()?
> 
> 	I notice it.  I know what it checks.  If the lock is not
> currently taken it will return "go ahead and downconvert".  So we
> won't requeue, we'll downconvert.  Specifically, look at
> ocfs2_check_meta_downconvert().  It merely checks the caching info.  We
> can't have any cached data if we don't have the EX yet.

Is it a rule that If the lock is not currently taken it will return "go
ahead and downconvert"?

by checking ocfs2_check_meta_downconvert(), I think it ensures cache is
checkpointed by JBD(2) before returning "go ahead and downconvert".
maybe yes that you noticed that we can't have cache if we don't have
EX, I think the main purpose is that it ensures that we finish things which we
should finish before we release the lock. another evidence is that it
doesn't check the ex_holders.

another question is that you can find out ocfs2_check_meta_downconvert()
checks if lock is taken(not explicitly), can you make such a conclusion
that all check_downconvert() follows it? --sorry, I didn't check them
and pushed it to you :P --I will check them too later.

so still the question, is it a rule that check_downconvert() should 
return "go ahead and downconvert" if the lock is not currently taken?
and also, what means "currently taken"? --ocfs2 layer(after
ocfs2_cluster_lock() returns) or dlm level? though I guess you meant
ocfs2 layer.

regards,
wengang.
> 	Sunil has observed the livelock behavior (pinging between UC and
> DC) in the wild via traces.  The UC process never leaves
> ocfs2_cluster_lock().  Your change fixes that.
> 
