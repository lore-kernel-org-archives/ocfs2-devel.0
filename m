From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 14 Jun 2008 01:47:01 -0700
Subject: [Ocfs2-devel] [RFC] configfs: module reference counting rules
In-Reply-To: <20080613222744.GB4153@localdomain>
References: <20080612235410.GC4012@localdomain>
	<20080613033309.GE20581@mail.oracle.com>
	<20080613095159.GH30804@localhost>
	<20080613202605.GD20576@mail.oracle.com>
	<20080613222744.GB4153@localdomain>
Message-ID: <20080614084701.GA9657@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 12:27:44AM +0200, Louis Rilling wrote:
> 1/ taking the module reference is only needed if mkdir() is called under
> a subsystem root or one of its default group, right? Of course this is a
> bit complex to check for this condition, and it does not hurt to take
> module references in all cases of mkdir().

	Correct, but it's much cleaner to always take the module ref.

> 2/ this module reference counting makes unregister_subsystem() win
> against mkdir(), but only if unregister_subsystem() is called in
> module_cleanup(), because otherwise try_module_get() would succeed,
> right? If so, this means that after having called register_subsystem(),
> a module_init() cannot cleanly fail. Perhaps this should be documented
> in that case.

	Correct again, mkdir can race a failing module_init().  This is
the same as register_filesystem().  A module that needed to protect
against this could have a mutex they release right before module_init()
succeeds.  They'd check it in make_item().  But most everyone can safely
make configfs_register_subsystem() the last thing in their
module_init().

> 3/ to make unregister_subsystem() win against mkdir(), mkdir() should
> try_module_get() on the subsystem's owner, not on the new item owner (as
> is done by the current code), right? Maybe there is a bug here...

	Nope.  You can build a subsystem out of multiple modules if you
like.  The module that owns the newly created object needs to be pinned,
and that's new_item->type->owner.  If a subsystem lives within one
module, then subsys->type->owner == new_item->type->owner, and it
doesn't matter.

> > 	So for the simple case, we provide plenty of protection.  If
> > someone wants to do something fancier, they have to provide their own
> > protection, but they would anyway.  And we can't know their complex
> > lifecycle, so we can't really help anyway.
> 
> Actually, I'm developing a framework based on configfs, with which many
> modules can be linked together through mkdir() and symlink() operations.
> So I'm already managing such reference holding, but the fact that
> configfs does not hold a reference until the last config_item_put()
> imposes limitations (with which I can live though) to the framework:

	Think about it this way: the try_module_get() isn't to protect
the client module, it is to protect configfs.  It makes sure that if
someone calls a VFS operation on a configfs inode, configfs can follow
the config_*_operations safely.  Once a config_item is removed from the
filesystem view, configfs is done with it.
	Look at it the other way around.  A config_item is not a
structure owned by configfs.  It is a part of the larger object, which
is owned by the module that created it.  The config_item portion just
lets configfs display it to userspace.

> 	For instance, A is a group of the framework, and mkdir A/B creates an
> object implemented by module "mod_b". Before calling mod_b's
> constructor, A's make_item() has to grab a reference on mod_b, and fail
> if not successful. Then this reference cannot be dropped before B's last
> reference is dropped, which can happen a long time after rmdir A/B. So
> A's drop_item() cannot drop mod_b's reference, and A has to provide
> the release() config_item_operation for B, which will call B's
> destructor and finally drop mod_b's reference.

	Wow, so A->make_item() does something like:

    submod = lookup_which_mod();
    if (!strcmp(submod, "mod_a"))
        new_thing = mod_a->alloc();
    else if (!strcmp(submod, "mod_b"))
        new_thing = mod_b->alloc();

    return &new_thing->config_item;

That's pretty complicated, I agree.  But certainly doable.
	Why can't mod_b provide a ->release() that does
module_put(self)?  Or are you trying to hide that detail from the person
who is implementing mod_b?  Even better, use the chained release scheme
that is used by bio_endio().  Have mod_b control its own
config_item_operations.  In make_item, copy off the type and operations,
then put in your own.  In drop, put them back.

struct my_item_type {
	struct config_item_type *original_type;
	struct config_item_type type;
	struct config_item_operations ops;
};

make_item()
{
	mod_b = alloc_mod_b();
	my_type = kzalloc(struct my_item_type);
	my_type->original_type = mod_b->item->ci_type;
	my_type->ops = *my_type->original_type->ct_item_ops;
	my_type->ops.release = my_item_release();
	my_type->type = *my_type->original_type;
	my_type->type.ops = &my_type->ops;
	mod_b->item->ci_type = &my_type->type;

	return &mod_b->item;
}

my_item_release(struct config_item *item)
{
	my_type = to_my_type(item->type);
	item->ci_type = my_type->original_type;
	kfree(my_type);
	item->ci_type->ct_ops->release(item);
}

Joel

-- 

"Ninety feet between bases is perhaps as close as man has ever come
 to perfection."
	- Red Smith

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
