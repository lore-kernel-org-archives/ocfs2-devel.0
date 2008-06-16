From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 16 Jun 2008 11:06:43 -0700
Subject: [Ocfs2-devel] [RFC] configfs: module reference counting rules
In-Reply-To: <20080616123912.GR30804@localhost>
References: <20080612235410.GC4012@localdomain>
	<20080613033309.GE20581@mail.oracle.com>
	<20080613095159.GH30804@localhost>
	<20080613202605.GD20576@mail.oracle.com>
	<20080613222744.GB4153@localdomain>
	<20080614084701.GA9657@mail.oracle.com>
	<20080616123912.GR30804@localhost>
Message-ID: <20080616180643.GC9657@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 02:39:12PM +0200, Louis Rilling wrote:
> On Sat, Jun 14, 2008 at 01:47:01AM -0700, Joel Becker wrote:
> 	IMHO, what really hurts configfs is that the unregister_subsystem() vs
> mkdir() race is not solved unless mkdir() tries to grab a reference on the
> subsystem's module. And the current code of mkdir() does not ensure that in the
> "several modules" case.

	Valid point.  It really does assume that the owner is always the
same.  Have to think about whether that's a big deal.

> I do something like this (and this works):

	I believe it works.  It looks fine.  I'd personally do it more
like what I displayed, wrapping release() rather than creating a
separate operations abstraction and overriding item_operations, but as
you point out that's just implementation.

> > 	Why can't mod_b provide a ->release() that does
> > module_put(self)?
> 
> Because this is simply wrong. Doing module_put(self) exposes the modules's
> function to be run while another cpu unloads the module. Note how I solve this

	How so?  As long as the module_put() is the last thing, you're
fine.  That said, we both have better solutions with our wrappered
functions.

Joel

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
