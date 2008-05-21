From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 21 May 2008 11:20:00 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default
	groups	lockdep-friendly
In-Reply-To: <20080520235138.GL26609@mail.oracle.com>
References: <20080520163320.025971210@kerlabs.com>
	<20080520095810.1d50d247@infradead.org>
	<20080520215639.GG26609@mail.oracle.com>
	<20080520151341.058f2df4@infradead.org>
	<20080520222702.GJ26609@mail.oracle.com>
	<20080520153543.4bafcac9@infradead.org>
	<20080520235138.GL26609@mail.oracle.com>
Message-ID: <1211361600.6463.65.camel@lappy.programming.kicks-ass.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, 2008-05-20 at 16:51 -0700, Joel Becker wrote:
> On Tue, May 20, 2008 at 03:35:43PM -0700, Arjan van de Ven wrote:
> > not quite what I meant; what I meant is more like how sched.c deals
> > with per cpu queues:
> > 
> > (from sched.c)
> > 
> >                 spin_lock_init(&rq->lock);
> >                 lockdep_set_class(&rq->lock, &rq->rq_lock_key); 
> 
> 	Looking at this, it's taking the address of the struct
> lock_class_key as the actual key.  Thus, if we tie one of these guys to
> the structure we're representing, we get lock safety...except that we're
> talking about i_mutex here, and we want to interact with the VFS's use
> thereof.

Also bear in mind that the lock_class_key structure must be in static
storage.
