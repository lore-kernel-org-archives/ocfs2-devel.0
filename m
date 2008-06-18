From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 18 Jun 2008 18:51:01 +0200
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080618161215.GA16780@ca-server1.us.oracle.com>
References: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
	<20080618123134.GC30804@localhost>
	<20080618161215.GA16780@ca-server1.us.oracle.com>
Message-ID: <20080618165101.GI30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Wed, Jun 18, 2008 at 09:12:15AM -0700, Joel Becker wrote:
> On Wed, Jun 18, 2008 at 02:31:34PM +0200, Louis Rilling wrote:
> > On Tue, Jun 17, 2008 at 03:41:00PM -0700, Joel Becker wrote:
> > > However, if the subsystem is made up of multiple modules, this may not
> > > pin the subsystem.  Thus, it would be possible to unload the toplevel
> > > subsystem module while there is still a child item.  Thus, we now
> > > try_module_get() the subsystem's module.  This only really affects
> > > children of the toplevel subsystem group.  Deeper children already have
> > > their parents pinned.
> > 
> > Looks good to me.
> > 
> > What about new item module pinning versus a concurrent sys_delete_module() in a
> > preemptible kernel? AFAICS new_item pinning is just done too late to protect
> > anybody against sys_delete_module(). Shouldn't we remove new item module pinning
> > and let the subsystem do it?
> 
> 	Good catch.  Preempt doesn't matter - it could just be another
> CPU.
> 	Certainly if there are multiple modules the make_item() will
> have to pin the submodule before calling it.  But the common case isn't
> multiple modules.  What we absolutely don't want is making the common
> case have to pin itself.

I suspect the common case to not need to pin the new item: if we assume that the
parent is already pinned, it will remain pinned until the new item is dropped.
	I think that the following rules ensure that the parent's module is
always pinned:

1/ The subsystem root is pinned before creating any other subdir under a default
   group of its module (ok with your patch).

2/ A subsystem root having default groups in other modules pins these modules
   before register() and until unregister() (ok with in-tree subsystems I think,
   thanks to automatic module dependency tracking). This should mostly be done
   implicitly thanks to the module dependency tracking based on used symbols.

3/ Same as 2 but for a new group between allocation and release(). Here again,
   module dependency tracking should do the job most of the time.

4/ make_item()/make_group() pins the module of the new item/group if it differs
   from the current one, and at least until drop_item() (must check in-tree
   subsystems, but I suspect that module dependency tracking already does the
   job).

If you agree with these rules, which seem to be just reasonable, we should be
able to get rid of the new item's module pinning inside configfs.

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080618/1c7afc12/attachment.bin 
