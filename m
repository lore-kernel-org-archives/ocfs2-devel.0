From: Arjan van de Ven <arjan@infradead.org>
Date: Tue, 20 May 2008 22:36:11 -0000
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default
 groups lockdep-friendly
In-Reply-To: <20080520222702.GJ26609@mail.oracle.com>
References: <20080520163320.025971210@kerlabs.com>
	<20080520095810.1d50d247@infradead.org>
	<20080520215639.GG26609@mail.oracle.com>
	<20080520151341.058f2df4@infradead.org>
	<20080520222702.GJ26609@mail.oracle.com>
Message-ID: <20080520153543.4bafcac9@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, 20 May 2008 15:27:02 -0700
Joel Becker <Joel.Becker@oracle.com> wrote:

> On Tue, May 20, 2008 at 03:13:41PM -0700, Arjan van de Ven wrote:
> > > 	Louis, what about sticking the recursion level on
> > > configfs_dirent?  That is, you could add sd->s_level and then use
> > > it when needed.  THis would hopefully avoid having to pass the
> > > level as an argument to every function.  Then we can go back to
> > > your original scheme.  If they recurse too much and hit the
> > > lockdep limit, just rewind everything and return -ELOOP.
> > 
> > you can also make a new lockdep key for each level... not pretty
> > but it works
> 
> 	I think that's what we're talking about here.  The toplevel is
> I_MUTEX_PARENT, then each child has a class of (I_MUTEX_CHILD +
> depth), where depth is the value of s_level.  His original try passed
> depth everywhere.  I'm asking him to attach it to the configfs_dirent
> so that the code stays readable.  We run into a depth limit at
> (MAX_LOCKDEP_SUBCLASS - I_MUTEX_PARENT - 1 == 5), which I think is
> probably sane.
> 	Do you mean something else?  Perhaps not starting from
> I_MUTEX_PARENT/CHILD and instead creating CONFIGFS_MUTEX_XXX?

not quite what I meant; what I meant is more like how sched.c deals
with per cpu queues:

(from sched.c)

                spin_lock_init(&rq->lock);
                lockdep_set_class(&rq->lock, &rq->rq_lock_key); 


eg you can override the class (not just add a subclass) for a lock
based on a "key"..
