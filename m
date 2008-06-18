From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 18 Jun 2008 13:07:13 -0700
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080618165101.GI30804@localhost>
References: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
	<20080618123134.GC30804@localhost>
	<20080618161215.GA16780@ca-server1.us.oracle.com>
	<20080618165101.GI30804@localhost>
Message-ID: <20080618200713.GE16780@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Wed, Jun 18, 2008 at 06:51:01PM +0200, Louis Rilling wrote:
> On Wed, Jun 18, 2008 at 09:12:15AM -0700, Joel Becker wrote:
> I suspect the common case to not need to pin the new item: if we assume that the
> parent is already pinned, it will remain pinned until the new item is dropped.

	We still want to pin the new item.  I'll discuss below.

> 4/ make_item()/make_group() pins the module of the new item/group if it differs
>    from the current one, and at least until drop_item() (must check in-tree
>    subsystems, but I suspect that module dependency tracking already does the
>    job).

	This is a silly rule, though.  Why "pin if it is different" when
"always pin" is just as effective and much easier to understand?  You
never have to ask "but was the item's module pinned?" when tracking a
problem.
	In the end, though, it doesn't matter.  We need a reference on
the item because we refer to it after calling client_drop_item().
Specifically, we call config_item_put().  If we don't have a reference
and trust make_item()/drop_item() to handle that for us, the module can
go away between the call of client_drop_item() and config_item_put() in
configfs_rmdir().
	In the end, we are holding a reference to the module while we
are accessing it.  It's overkill for the common case (single module was
safe before when we pinned item->owner, and it is safe if we only
pin subsys->owner), but it provides the best proper safety if we allow
multi-module subsystems.

Joel

-- 

"Also, all of life's big problems include the words 'indictment' or
	'inoperable.' Everything else is small stuff."
	- Alton Brown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
