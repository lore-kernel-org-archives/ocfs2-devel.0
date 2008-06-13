From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 13 Jun 2008 13:26:05 -0700
Subject: [Ocfs2-devel] [RFC] configfs: module reference counting rules
In-Reply-To: <20080613095159.GH30804@localhost>
References: <20080612235410.GC4012@localdomain>
	<20080613033309.GE20581@mail.oracle.com>
	<20080613095159.GH30804@localhost>
Message-ID: <20080613202605.GD20576@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 11:51:59AM +0200, Louis Rilling wrote:
> On Thu, Jun 12, 2008 at 08:33:12PM -0700, Joel Becker wrote:
> Ok, got it. The race is between unregister_subsystem() and mkdir() at the root
> of the subsystem (or one of its default groups). In deeper, user-created groups,
> this would be a design bug of the subsystem if this race could occur.

	Exactly.

> > 	This is hard logic, and not something we want each and every
> > client module to have to figure out.  Your change has them explicitly
> > __module_get() in ->make_item/group(), which isn't safe because of this
> > race!
> 
> Well, this remains hard logic for the modules. But I agree that they should not
> impact the logic that deals with racing mkdir() and unregister_subsystem().

	It is, but most modules don't have to deal with it.  Most
modules (all in-kernel configfs users) have a single refrence on it.
When they take an additional one, it's for the duration of a function
call.  They have to make sure that it's safe to call the function in the
first place, so it's clearly safe to get/put the item.
	Forget about the configfs view that is presented to userspace.
If you were a module with inter-linked structures, you'd have to make
sure they were freed cleanly.  For simple things, you create and drop
them.  If a module has a complex interlinkage, they have a mechanism to
handle it.
	Example: filesystems can hang whatever they want off of VFS
structures like inodes and superblocks - a mounted filesystem prevents
rmmod.  Everything is safe, *everything*, as long as it is all cleaned
up when put_super() returns.
	So for the simple case, we provide plenty of protection.  If
someone wants to do something fancier, they have to provide their own
protection, but they would anyway.  And we can't know their complex
lifecycle, so we can't really help anyway.

> Sure. I was thinking that configfs helped subsystems with such module reference
> counting issues, but I was wrong.

	We only help with the ones we have enough information to help
with.

> Thanks for these explanations.

	No problem.  The more questions you ask, the more I refresh my
memory.  And as you've seen on other points, we sometimes find bugs :-)

Joel


-- 

"The trouble with being punctual is that nobody's there to
 appreciate it."
	- Franklin P. Jones

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
