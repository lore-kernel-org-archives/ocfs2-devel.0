From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Fri, 20 Jun 2008 14:46:44 +0200
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080619220739.GC10888@mail.oracle.com>
References: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
	<20080618123134.GC30804@localhost>
	<20080618161215.GA16780@ca-server1.us.oracle.com>
	<20080618165101.GI30804@localhost>
	<20080618200713.GE16780@ca-server1.us.oracle.com>
	<20080619111357.GM30804@localhost>
	<20080619220739.GC10888@mail.oracle.com>
Message-ID: <20080620124644.GQ30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Thu, Jun 19, 2008 at 03:07:39PM -0700, Joel Becker wrote:
> On Thu, Jun 19, 2008 at 01:13:57PM +0200, Louis Rilling wrote:
> > On Wed, Jun 18, 2008 at 01:07:13PM -0700, Joel Becker wrote:
> > > > 4/ make_item()/make_group() pins the module of the new item/group if it differs
> > > >    from the current one, and at least until drop_item() (must check in-tree
> > > >    subsystems, but I suspect that module dependency tracking already does the
> > > >    job).
> > > 
> > > 	This is a silly rule, though.  Why "pin if it is different" when
> > > "always pin" is just as effective and much easier to understand?  You
> > > never have to ask "but was the item's module pinned?" when tracking a
> > > problem.
> > 
> > Not so silly, if you consider that this relieves in-tree users from having to
> > add try_module_get() in their code. Only special users (like me) who create
> > items implemented by other modules, without explicitly depending on symbols of
> > these modules or keeping references after ->drop_item(), have to deal with
> > such module pinning.
> 
> 	With my rule ("always pin"), single-module users don't have to
> try_module_get() at all.  Just like today.  That's kind of my point.

With my rules, neither single-module users, nor in-tree multi-module users have
to try_module_get(). And, as I try to convince you of, configfs does not have
to try_module_get() on new items.

What I suggest is a *simplification* of configfs, and does not require to change
existing subsystems. I'm convinced that this does not lower the safety of
configfs, but instead this makes it clear that subsystems have to take care of
module pinning, as they always had to.

> 
> > 	And I think that we can also get rid of the last config_item_put() (or
> > put it before client_drop_item()), because after client_drop_item() rmdir() does
> > not need the item anymore, and client_drop_item() is supposed to call
> > config_item_put() (in parent's drop_item() or directly). IOW, when entering
> > rmdir() configfs already holds the item's ref that was given by parent's
> > ->make_item(), and rmdir() drops that ref in client_drop_item(). No need to hold
> > the extra one grabbed by configfs_get_config_item().
> 
> 	We could, but it's a much cleaner read to hold a reference for
> the duration of the function.  And since we hold a module reference
> anyway, I like simpler and clearer.

But keeping this last config_item_put() prevents the simplification that I'm
defending. And I think that the simplification is worth moving this
config_item_put() before client_drop_item().

> 
> > > 	In the end, we are holding a reference to the module while we
> > > are accessing it.  It's overkill for the common case (single module was
> > > safe before when we pinned item->owner, and it is safe if we only
> > > pin subsys->owner), but it provides the best proper safety if we allow
> > > multi-module subsystems.
> > 
> > As I said above, the way it is done currently, pinning the new item's module
> > does not provide any safety in multi-module subsystems.
> 
> 	We provide safety for ourselves.  We can't provide safety for
> the subsystem - we don't know how it is put together.  Once again, the
> module reference is just configfs saying "I know that I have a reference
> and that I'm safe to access this."

No, we do not provide safety for ourselves: remember the scenario I described
earlier in this thread [ Actually I'm able to show you a similar scenario with a
non-preemptible kernel on a single-processor system, because attach_group() may
block and schedule in a memory allocation. ]. This is the reason why I suggest
to get rid of the last config_item_put() above, and simply remove this new
item's module pinning which, again, does not provide any safety, even for
configfs alone.
	Note that I agree with your principle of providing safety for configfs
only, and let modules handle their specific module uses. I'm really keeping this
in mind, and also keeping in mind not to disturb subsystems with new rules. It
just happens that the rules that I'm proposing are already respected by in-tree
subsystems, and are even already respected by my own multi-modules use case.
	So, what do you think is really bad in my suggestion?

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080620/86c9c02d/attachment-0001.bin 
