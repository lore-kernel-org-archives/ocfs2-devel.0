From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Tue, 17 Jun 2008 14:56:50 +0200
Subject: [Ocfs2-devel] [PATCH][BUGFIX] configfs: Fix symlink() to a
	removing item
In-Reply-To: <20080617104259.GX30804@localhost>
References: <20080616180911.GV30804@localhost>
	<20080616222900.GD6441@mail.oracle.com>
	<20080617104259.GX30804@localhost>
Message-ID: <20080617125650.GY30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Jun 17, 2008 at 12:42:59PM +0200, Louis Rilling wrote:
> On Mon, Jun 16, 2008 at 03:29:00PM -0700, Joel Becker wrote:
> > On Mon, Jun 16, 2008 at 08:09:11PM +0200, Louis Rilling wrote:
> > > This patch introduces a similar (weird?) behavior as with mkdir failures making
> > > rmdir fail: if symlink() races with rmdir() of the parent directory (or its
> > > youngest user-created ancestor if parent is a default group) or rmdir() of the
> > > target directory, and then fails in configfs_create(), this can make the racing
> > > rmdir() fail despite the concerned directory having no user-created entry (resp.
> > > no symlink pointing to it or one of its default groups) in the end.
> > > If this behavior is found unacceptable, I'll submit a fix in the same spirit as
> > > the racing mkdir() fix.
> > 
> > 	Ahh, but you can't wait on the mutex like you do in mkdir(),
> > because they're not ordered - it can race rename again.
> 
> Yes I can. In the mkdir() case, rmdir() waits on the mutex of one of the default
> groups. The symlink case will be handled the same. The difference is that while
> mkdir() tags the parent with CONFIGFS_USET_IN_MKDIR, symlink() will tag both the
> parent and the target with CONFIGFS_USET_IN_SYMLINK. [ We can actually merge the
> two flags in something like CONFIGFS_USET_ATTACHING. ] Since tagging requires
> only to take configfs_dirent_lock, there will be no deadlock.

Hm, you were right, sorry. We can only solve the race with rmdir() removing the
item where the symlink is created. For the target item, I don't know yet...

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080617/bd80833f/attachment-0001.bin 
