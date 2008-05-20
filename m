From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 20 May 2008 16:51:38 -0700
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default
	groups	lockdep-friendly
In-Reply-To: <20080520153543.4bafcac9@infradead.org>
References: <20080520163320.025971210@kerlabs.com>
	<20080520095810.1d50d247@infradead.org>
	<20080520215639.GG26609@mail.oracle.com>
	<20080520151341.058f2df4@infradead.org>
	<20080520222702.GJ26609@mail.oracle.com>
	<20080520153543.4bafcac9@infradead.org>
Message-ID: <20080520235138.GL26609@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjan van de Ven <arjan@infradead.org>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, May 20, 2008 at 03:35:43PM -0700, Arjan van de Ven wrote:
> not quite what I meant; what I meant is more like how sched.c deals
> with per cpu queues:
> 
> (from sched.c)
> 
>                 spin_lock_init(&rq->lock);
>                 lockdep_set_class(&rq->lock, &rq->rq_lock_key); 

	Looking at this, it's taking the address of the struct
lock_class_key as the actual key.  Thus, if we tie one of these guys to
the structure we're representing, we get lock safety...except that we're
talking about i_mutex here, and we want to interact with the VFS's use
thereof.

Joel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
