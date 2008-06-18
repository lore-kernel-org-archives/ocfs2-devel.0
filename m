From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 18 Jun 2008 14:31:34 +0200
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
References: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20080618123134.GC30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Tue, Jun 17, 2008 at 03:41:00PM -0700, Joel Becker wrote:
> configfs_mkdir() creates a new item by calling its parent's
> ->make_item/group() functions.  Once that object is created,
> configfs_mkdir() calls try_module_get() on the new item's module.  If it
> succeeds, the module owning the new item cannot be unloaded, and
> configfs is safe to reference the item.
> 
> If the item and the subsystem it belongs to are part of the same module,
> the subsystem is also pinned.  This is the common case.
> 
> However, if the subsystem is made up of multiple modules, this may not
> pin the subsystem.  Thus, it would be possible to unload the toplevel
> subsystem module while there is still a child item.  Thus, we now
> try_module_get() the subsystem's module.  This only really affects
> children of the toplevel subsystem group.  Deeper children already have
> their parents pinned.

Looks good to me.

What about new item module pinning versus a concurrent sys_delete_module() in a
preemptible kernel? AFAICS new_item pinning is just done too late to protect
anybody against sys_delete_module(). Shouldn't we remove new item module pinning
and let the subsystem do it?

	process 1: 				process 2:
	confifs_mkdir()
	  item = make_item()

	--- preemption schedule ---
						sys_delete_module()
						  ok
	--- end of preemption   ---

	  new_item_owner = item->ci_type.ct_owner
Possible access to freed memory if type statically allocated!
	  try_module_get(new_item_owner)
Access to freed memory of the module metadata!

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080618/ffb59622/attachment.bin 
