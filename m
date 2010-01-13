From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 13 Jan 2010 01:31:48 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock() dead
 lock
In-Reply-To: <20100113092332.GB4390@laptop.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<20100112015946.GE20285@mail.oracle.com>
	<20100113032049.GA4045@laptop.oracle.com>
	<20100113075752.GA23372@mail.oracle.com>
	<20100113092332.GB4390@laptop.oracle.com>
Message-ID: <20100113093148.GA25367@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 13, 2010 at 05:23:32PM +0800, Wengang Wang wrote:
> On 10-01-12 23:57, Joel Becker wrote:
> > On Wed, Jan 13, 2010 at 11:20:49AM +0800, Wengang Wang wrote:
> > > before update_holders, the lock could be DCed(since no BUSY flag set by
> > > here).
> > > 
> > > and even after update_holders, the lock could be DCed too.
> > > 
> > > so that we get ocfs2_cluster_lock()(with holders increased) returned sucessfully
> > > but actually we don't hold the dlm lock. --thus more than one node is
> > > considering that they have the (EX) lock.
> > 
> > 	You make a good point.  I don't like the solution you propose,
> > though.  Another flag that's almost the same?  Eww!  There's got to be a
> > better way.
> cool! expecting your patch...

	Don't have one yet.  We can't rely on the spinlock, because we
have to sleep on BUSY.  We relied on the spinblock before because we
allowed the UC->DC->UC->DC livelock to happen.

Joel

-- 

"Up and down that road in our worn out shoes,
 Talking bout good things and singing the blues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
