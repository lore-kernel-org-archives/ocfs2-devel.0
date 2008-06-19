From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Thu, 19 Jun 2008 13:13:57 +0200
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080618200713.GE16780@ca-server1.us.oracle.com>
References: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
	<20080618123134.GC30804@localhost>
	<20080618161215.GA16780@ca-server1.us.oracle.com>
	<20080618165101.GI30804@localhost>
	<20080618200713.GE16780@ca-server1.us.oracle.com>
Message-ID: <20080619111357.GM30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Wed, Jun 18, 2008 at 01:07:13PM -0700, Joel Becker wrote:
> On Wed, Jun 18, 2008 at 06:51:01PM +0200, Louis Rilling wrote:
> > On Wed, Jun 18, 2008 at 09:12:15AM -0700, Joel Becker wrote:
> > I suspect the common case to not need to pin the new item: if we assume that the
> > parent is already pinned, it will remain pinned until the new item is dropped.
> 
> 	We still want to pin the new item.  I'll discuss below.
> 
> > 4/ make_item()/make_group() pins the module of the new item/group if it differs
> >    from the current one, and at least until drop_item() (must check in-tree
> >    subsystems, but I suspect that module dependency tracking already does the
> >    job).
> 
> 	This is a silly rule, though.  Why "pin if it is different" when
> "always pin" is just as effective and much easier to understand?  You
> never have to ask "but was the item's module pinned?" when tracking a
> problem.

Not so silly, if you consider that this relieves in-tree users from having to
add try_module_get() in their code. Only special users (like me) who create
items implemented by other modules, without explicitly depending on symbols of
these modules or keeping references after ->drop_item(), have to deal with
such module pinning.

> 	In the end, though, it doesn't matter.  We need a reference on
> the item because we refer to it after calling client_drop_item().
> Specifically, we call config_item_put().  If we don't have a reference
> and trust make_item()/drop_item() to handle that for us, the module can
> go away between the call of client_drop_item() and config_item_put() in
> configfs_rmdir().

Ok, rule 4/ should say "until ->release()", whatever the means (as we discussed
earlier), the common case being that ->release() is called inside parent's
->drop_item() (see right below). This is needed anyway, because otherwise
failing to pin the module in mkdir() cannot recover safely by calling
client_drop_item().
	And I think that we can also get rid of the last config_item_put() (or
put it before client_drop_item()), because after client_drop_item() rmdir() does
not need the item anymore, and client_drop_item() is supposed to call
config_item_put() (in parent's drop_item() or directly). IOW, when entering
rmdir() configfs already holds the item's ref that was given by parent's
->make_item(), and rmdir() drops that ref in client_drop_item(). No need to hold
the extra one grabbed by configfs_get_config_item().

> 	In the end, we are holding a reference to the module while we
> are accessing it.  It's overkill for the common case (single module was
> safe before when we pinned item->owner, and it is safe if we only
> pin subsys->owner), but it provides the best proper safety if we allow
> multi-module subsystems.

As I said above, the way it is done currently, pinning the new item's module
does not provide any safety in multi-module subsystems.

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080619/738bbcae/attachment.bin 
