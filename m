From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Mon, 16 Jun 2008 14:39:12 +0200
Subject: [Ocfs2-devel] [RFC] configfs: module reference counting rules
In-Reply-To: <20080614084701.GA9657@mail.oracle.com>
References: <20080612235410.GC4012@localdomain>
	<20080613033309.GE20581@mail.oracle.com>
	<20080613095159.GH30804@localhost>
	<20080613202605.GD20576@mail.oracle.com>
	<20080613222744.GB4153@localdomain>
	<20080614084701.GA9657@mail.oracle.com>
Message-ID: <20080616123912.GR30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 01:47:01AM -0700, Joel Becker wrote:
> On Sat, Jun 14, 2008 at 12:27:44AM +0200, Louis Rilling wrote:
> > 1/ taking the module reference is only needed if mkdir() is called under
> > a subsystem root or one of its default group, right? Of course this is a
> > bit complex to check for this condition, and it does not hurt to take
> > module references in all cases of mkdir().
> 
> 	Correct, but it's much cleaner to always take the module ref.
> 
> > 2/ this module reference counting makes unregister_subsystem() win
> > against mkdir(), but only if unregister_subsystem() is called in
> > module_cleanup(), because otherwise try_module_get() would succeed,
> > right? If so, this means that after having called register_subsystem(),
> > a module_init() cannot cleanly fail. Perhaps this should be documented
> > in that case.
> 
> 	Correct again, mkdir can race a failing module_init().  This is
> the same as register_filesystem().  A module that needed to protect
> against this could have a mutex they release right before module_init()
> succeeds.  They'd check it in make_item().  But most everyone can safely
> make configfs_register_subsystem() the last thing in their
> module_init().

Agreed. I have examples of similar issues (but not configfs related) where
a single module module_init() failing needs several cleanup that can only
safely be done in module_cleanup(), but I cannot claim that this is general
case :)

> 
> > 3/ to make unregister_subsystem() win against mkdir(), mkdir() should
> > try_module_get() on the subsystem's owner, not on the new item owner (as
> > is done by the current code), right? Maybe there is a bug here...
> 
> 	Nope.  You can build a subsystem out of multiple modules if you
> like.  The module that owns the newly created object needs to be pinned,
> and that's new_item->type->owner.  If a subsystem lives within one
> module, then subsys->type->owner == new_item->type->owner, and it
> doesn't matter.

In the "several modules" case, the module is pinned too late to protect against
module unloading. This does probably not hurt configfs since the only
problematic call is config_item_cleanup(), where the new item's release()
operation is called. For such subsystems, the only way to protect against module
unloading is to grab a reference on the new item's module in the make_item()
operation, and find a way to ensure that the reference is dropped after the last
config_item_put().
	IMHO, what really hurts configfs is that the unregister_subsystem() vs
mkdir() race is not solved unless mkdir() tries to grab a reference on the
subsystem's module. And the current code of mkdir() does not ensure that in the
"several modules" case.

> 
> > > 	So for the simple case, we provide plenty of protection.  If
> > > someone wants to do something fancier, they have to provide their own
> > > protection, but they would anyway.  And we can't know their complex
> > > lifecycle, so we can't really help anyway.
> > 
> > Actually, I'm developing a framework based on configfs, with which many
> > modules can be linked together through mkdir() and symlink() operations.
> > So I'm already managing such reference holding, but the fact that
> > configfs does not hold a reference until the last config_item_put()
> > imposes limitations (with which I can live though) to the framework:
> 
> 	Think about it this way: the try_module_get() isn't to protect
> the client module, it is to protect configfs.  It makes sure that if
> someone calls a VFS operation on a configfs inode, configfs can follow
> the config_*_operations safely.  Once a config_item is removed from the
> filesystem view, configfs is done with it.
> 	Look at it the other way around.  A config_item is not a
> structure owned by configfs.  It is a part of the larger object, which
> is owned by the module that created it.  The config_item portion just
> lets configfs display it to userspace.

Yes, this is what I realized in your previous email.

> 
> > 	For instance, A is a group of the framework, and mkdir A/B creates an
> > object implemented by module "mod_b". Before calling mod_b's
> > constructor, A's make_item() has to grab a reference on mod_b, and fail
> > if not successful. Then this reference cannot be dropped before B's last
> > reference is dropped, which can happen a long time after rmdir A/B. So
> > A's drop_item() cannot drop mod_b's reference, and A has to provide
> > the release() config_item_operation for B, which will call B's
> > destructor and finally drop mod_b's reference.
> 
> 	Wow, so A->make_item() does something like:
> 
>     submod = lookup_which_mod();
>     if (!strcmp(submod, "mod_a"))
>         new_thing = mod_a->alloc();
>     else if (!strcmp(submod, "mod_b"))
>         new_thing = mod_b->alloc();
> 
>     return &new_thing->config_item;
> 
> That's pretty complicated, I agree.  But certainly doable.

I do something like this (and this works):

struct mod_type {
	struct list_head type_list;
	struct config_item_type item_type;
	const char *name;
	struct config_item *new_item(const char *name);
	void destroy_item(struct config_item *item);
};

void my_release(struct config_item *item)
{
	struct mod_type *type = container_of(item->ci_type, struct mod_type,
					item_type);
	type->destroy_item(item);
	module_put(type->item_type.ct_owner);
}

struct configfs_item_operations my_item_ops = {
	.release = my_release,
};

void register(struct mod_type *mod_type)
{
	mod_type->item_type.ct_item_ops = &my_item_ops;
	spin_lock(&type_list);
	list_add(&mod_type->type_list, &mod_type_head);
	spin_unlock(&type_list);
}

/* Must only be called inside module_cleanup() */
void unregister(struct mod_type *mod_type)
{
	spin_lock(&type_list);
	list_del(&mod_type->type_list);
	spin_unlock(&type_list);
}

struct mod_type *lookup(const char *name)
{
	/* return mod_type having mod_type->name == name in the list */ 
}

make_item(struct config_group *group, const char *name)
{
	spin_lock(&mod_type_list);
	mod_type = lookup(name);
	if (mod_type)
		if (!try_module_get(mod_type->item_type.ct_owner))
			mod_type = NULL;
	spin_unlock(&mod_type_list);

	new_item = NULL;
	if (mod_type) {
		new_item = mod_type->new_item(name);
		if (!new_item)
			module_put(mod_type->item_type.ct_owner);
	}
	return new_item;
}

drop_item(struct config_group *group, struct config_item *item)
{
	config_item_put(item);
}

------

mod_a_init()
	register(mod_type_a);

mod_a_cleanup()
	unregister(mod_type_a);

> 	Why can't mod_b provide a ->release() that does
> module_put(self)?

Because this is simply wrong. Doing module_put(self) exposes the modules's
function to be run while another cpu unloads the module. Note how I solve this
by doing try_module_get() while still having mod_type_list locked, and doing
module_put() only after having destroyed the module's item. This lock
actually protects item creation against concurrent removal of the module
implementing that item.

> Or are you trying to hide that detail from the person
> who is implementing mod_b?  Even better, use the chained release scheme
> that is used by bio_endio().  Have mod_b control its own
> config_item_operations.  In make_item, copy off the type and operations,
> then put in your own.  In drop, put them back.
> 
> struct my_item_type {
> 	struct config_item_type *original_type;
> 	struct config_item_type type;
> 	struct config_item_operations ops;
> };
> 
> make_item()
> {
> 	mod_b = alloc_mod_b();
> 	my_type = kzalloc(struct my_item_type);
> 	my_type->original_type = mod_b->item->ci_type;
> 	my_type->ops = *my_type->original_type->ct_item_ops;
> 	my_type->ops.release = my_item_release();
> 	my_type->type = *my_type->original_type;
> 	my_type->type.ops = &my_type->ops;
> 	mod_b->item->ci_type = &my_type->type;
> 
> 	return &mod_b->item;
> }
> 
> my_item_release(struct config_item *item)
> {
> 	my_type = to_my_type(item->type);
> 	item->ci_type = my_type->original_type;
> 	kfree(my_type);
> 	item->ci_type->ct_ops->release(item);
> }

I already do something like this, replacing the item_operations instead of the
whole item_type. And I find it ugly. Only a matter of taste, I agree.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080616/7588f9f1/attachment-0001.bin 
