From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 13 Jan 2010 17:36:49 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock()
	dead	lock
In-Reply-To: <20100113093148.GA25367@mail.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<20100112015946.GE20285@mail.oracle.com>
	<20100113032049.GA4045@laptop.oracle.com>
	<20100113075752.GA23372@mail.oracle.com>
	<20100113092332.GB4390@laptop.oracle.com>
	<20100113093148.GA25367@mail.oracle.com>
Message-ID: <20100113093649.GC4390@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-01-13 01:31, Joel Becker wrote:
> > > > before update_holders, the lock could be DCed(since no BUSY flag set by
> > > > here).
> > > > 
> > > > and even after update_holders, the lock could be DCed too.
> > > > 
> > > > so that we get ocfs2_cluster_lock()(with holders increased) returned sucessfully
> > > > but actually we don't hold the dlm lock. --thus more than one node is
> > > > considering that they have the (EX) lock.
> > > 
> > > 	You make a good point.  I don't like the solution you propose,
> > > though.  Another flag that's almost the same?  Eww!  There's got to be a
> > > better way.
> > cool! expecting your patch...
> 
> 	Don't have one yet.  We can't rely on the spinlock, because we
> have to sleep on BUSY.  We relied on the spinblock before because we
> allowed the UC->DC->UC->DC livelock to happen.
> 
then I feel it's going to be a big change.
so that the author shouldn't be me, add me as something like bug-found-by if you like
:)

regards,
wengang.
