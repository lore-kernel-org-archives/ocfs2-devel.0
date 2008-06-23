From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Mon, 23 Jun 2008 17:44:57 +0200
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080620223614.GD21416@mail.oracle.com>
References: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
	<20080618123134.GC30804@localhost>
	<20080618161215.GA16780@ca-server1.us.oracle.com>
	<20080618165101.GI30804@localhost>
	<20080618200713.GE16780@ca-server1.us.oracle.com>
	<20080619111357.GM30804@localhost>
	<20080619220739.GC10888@mail.oracle.com>
	<20080620124644.GQ30804@localhost>
	<20080620223614.GD21416@mail.oracle.com>
Message-ID: <20080623154457.GW30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Fri, Jun 20, 2008 at 03:36:14PM -0700, Joel Becker wrote:
> On Fri, Jun 20, 2008 at 02:46:44PM +0200, Louis Rilling wrote:
> > But keeping this last config_item_put() prevents the simplification that I'm
> > defending. And I think that the simplification is worth moving this
> > config_item_put() before client_drop_item().
> 
> 	I guess I'm not seeing what's simpler.  Four lines of
> try_module_get() aren't very complex, really.  Conversely, having some
> functions that *don't* do config_item_get_item() is weird.  Not invalid,
> just harder to read.

config_item_get_item() followed by config_item_put(), with a comment on why this
is correct, was my suggestion, not avoiding to call config_item_get_item().

> 	Let's put it on the shelf.  What I have with this patch is
> really no different in effective behavior.

I'm completely ok with your patch. I just thought that this was the occasion to
cleanup module pinning stuff.

Would you consider the last following argument?

Consider a very simple subsystem, implemented by a single module, that does
absolutely no config_item_get(). Currently, this module must provide a release()
operation for all user-created config_items, because the last reference is
dropped by configfs, right after dropping the item. With my simplification, the
module effectively drops the last reference in ->drop_item(), and could rely on
that to make the code simpler like below:

make_item()
	new_item = kmalloc();
	config_item_init_type_long_name();
	return new_item;

drop_item(item)
	config_item_put(item);
	kfree(item);

No need for a release() operation in that simple case, and one may find such
code more readable thanks to its symmetry.

Looking at some in-tree code, netconsole would be a candidate for such code
simplification. Indeed, netconsole does not look like needing config_item_get(),
because the target_list_lock already provides the necessary protection.

That said, thanks for the discussion, and for not forgetting the idea :)

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080623/8540dbea/attachment.bin 
