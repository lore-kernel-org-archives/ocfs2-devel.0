From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Thu, 19 Jun 2008 11:28:42 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH 3/3] configfs: Fix failing
	symlink() making	rmdir() fail
In-Reply-To: <20080618201107.GF16780@ca-server1.us.oracle.com>
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
	<1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com>
	<20080617221528.GA29091@mail.oracle.com>
	<20080618114043.GB30804@localhost>
	<20080618201107.GF16780@ca-server1.us.oracle.com>
Message-ID: <20080619092842.GK30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 18, 2008 at 01:11:07PM -0700, Joel Becker wrote:
> On Wed, Jun 18, 2008 at 01:40:43PM +0200, Louis Rilling wrote:
> > The problem is rmdir() of the target item (see below). ATTACHING only protects
> > us from rmdir() of the parent. This is the exact reason why I attach the link to
> > the target in last place, where we know that we won't have to rollback.
> 
> 	Why wouldn't it protect the target, given that detach_prep()
> will be called against the target if it's being rmdir'd?

Because
1/ setting and clearing ATTACHING could badly interact with mkdir()/symlink()
inside the target item (for instance clear the flag before mkdir() has finished
attaching a new item); to avoid this we could use a different flag, but
2/ rmdir() of the target cannot lock the inode of the new symlink's parent like
it does for mkdir(), otherwise we would risk a deadlock with other symlink() and
sys_rename(). This means that rmdir() should retry aggressively, in a busy
waiting loop, or replacing mutex_lock()/mutex_unlock() with yield().

> 
> > 	And AFAICS, creating a VFS object can not hurt as long as we hold the
> > parent i_mutex, right? Otherwise there already is a problem in
> > configfs_attach_item() where a failure in populate_attrs() leads to rollback the
> > creation of the VFS object already created for the item.
> 
> 	We *can* do that, but we try to isolate it - hand-building VFS
> objects is complex and error prone, and I try to isolate that to
> specific cases.  I'd rather avoid it when not necessary.

In the case of symlink(), building a new inode is what all filesystems must do.
The only "bad" side-effect I can figure out of having to rollback is that the
new entry will be visible for a short time until it is removed.

Anyway, do you think that the "solutions" above are more acceptable?

> 
> > > 		spin_lock(&configfs_dirent_lock);
> > > 		parent_sd->s_type &= ~CONFIGFS_USET_ATTACHING;
> > > 		if (ret) {
> > 
> > Here, if detach_prep() of the target failed because of the link attached above,
> > it had no means to retry. rmdir() of the target fails because of this
> > temporary link, which results in a failing symlink() making rmdir() of the
> > target fail.
> 
> 	How so?  It sees ATTACHING, it gets -EAGAIN, it tries again,
> just like before.  What's different?

See above the reasons for not using ATTACHING on the target.

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080619/c0ac9aab/attachment.bin 
