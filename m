From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Sat, 14 Jun 2008 00:27:44 +0200
Subject: [Ocfs2-devel] [RFC] configfs: module reference counting rules
In-Reply-To: <20080613202605.GD20576@mail.oracle.com>
References: <20080612235410.GC4012@localdomain>
	<20080613033309.GE20581@mail.oracle.com>
	<20080613095159.GH30804@localhost>
	<20080613202605.GD20576@mail.oracle.com>
Message-ID: <20080613222744.GB4153@localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 01:26:05PM -0700, Joel Becker wrote:
> On Fri, Jun 13, 2008 at 11:51:59AM +0200, Louis Rilling wrote:
> > On Thu, Jun 12, 2008 at 08:33:12PM -0700, Joel Becker wrote:
> > Ok, got it. The race is between unregister_subsystem() and mkdir() at the root
> > of the subsystem (or one of its default groups). In deeper, user-created groups,
> > this would be a design bug of the subsystem if this race could occur.
> 
> 	Exactly.

A few more thoughts:

1/ taking the module reference is only needed if mkdir() is called under
a subsystem root or one of its default group, right? Of course this is a
bit complex to check for this condition, and it does not hurt to take
module references in all cases of mkdir().

2/ this module reference counting makes unregister_subsystem() win
against mkdir(), but only if unregister_subsystem() is called in
module_cleanup(), because otherwise try_module_get() would succeed,
right? If so, this means that after having called register_subsystem(),
a module_init() cannot cleanly fail. Perhaps this should be documented
in that case.

3/ to make unregister_subsystem() win against mkdir(), mkdir() should
try_module_get() on the subsystem's owner, not on the new item owner (as
is done by the current code), right? Maybe there is a bug here...

> 
> > > 	This is hard logic, and not something we want each and every
> > > client module to have to figure out.  Your change has them explicitly
> > > __module_get() in ->make_item/group(), which isn't safe because of this
> > > race!
> > 
> > Well, this remains hard logic for the modules. But I agree that they should not
> > impact the logic that deals with racing mkdir() and unregister_subsystem().
> 
> 	It is, but most modules don't have to deal with it.  Most
> modules (all in-kernel configfs users) have a single refrence on it.
> When they take an additional one, it's for the duration of a function
> call.  They have to make sure that it's safe to call the function in the
> first place, so it's clearly safe to get/put the item.
> 	Forget about the configfs view that is presented to userspace.
> If you were a module with inter-linked structures, you'd have to make
> sure they were freed cleanly.  For simple things, you create and drop
> them.  If a module has a complex interlinkage, they have a mechanism to
> handle it.
> 	Example: filesystems can hang whatever they want off of VFS
> structures like inodes and superblocks - a mounted filesystem prevents
> rmmod.  Everything is safe, *everything*, as long as it is all cleaned
> up when put_super() returns.
> 	So for the simple case, we provide plenty of protection.  If
> someone wants to do something fancier, they have to provide their own
> protection, but they would anyway.  And we can't know their complex
> lifecycle, so we can't really help anyway.

Actually, I'm developing a framework based on configfs, with which many
modules can be linked together through mkdir() and symlink() operations.
So I'm already managing such reference holding, but the fact that
configfs does not hold a reference until the last config_item_put()
imposes limitations (with which I can live though) to the framework:
plugins of the framework provide custom config_item_types, but cannot define
their own config_item_operations (especially release()), because
release() must be called with a reference held on the module, and once
release() is called somebody (not the module itself) has to drop this reference.
	For instance, A is a group of the framework, and mkdir A/B creates an
object implemented by module "mod_b". Before calling mod_b's
constructor, A's make_item() has to grab a reference on mod_b, and fail
if not successful. Then this reference cannot be dropped before B's last
reference is dropped, which can happen a long time after rmdir A/B. So
A's drop_item() cannot drop mod_b's reference, and A has to provide
the release() config_item_operation for B, which will call B's
destructor and finally drop mod_b's reference.
	So I'd hoped that configfs could help me with this reference
counting, for instance by keeping a reference until last
config_item_cleanup(). But I can live without it, so don't care.

Louis

-- 
Dr Louis Rilling			Kerlabs - IRISA
Skype: louis.rilling			Campus Universitaire de Beaulieu
Phone: (+33|0) 2 99 84 71 52		Avenue du General Leclerc
Fax: (+33|0) 2 99 84 71 71		35042 Rennes CEDEX - France
http://www.kerlabs.com/
