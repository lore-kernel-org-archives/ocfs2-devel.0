From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 16 Jul 2008 15:08:21 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup
	after mkdir()	failure
In-Reply-To: <20080711220740.GC22577@mail.oracle.com>
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
	<20080711220740.GC22577@mail.oracle.com>
Message-ID: <20080716130821.GF3801@hawkmoon.kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jul 11, 2008 at 03:07:40PM -0700, Joel Becker wrote:
> On Fri, Jul 04, 2008 at 04:56:04PM +0200, Louis Rilling wrote:
> > This patchset fixes two kinds of bugs happening when
> > configfs_attach_group()/configfs_attach_item() fail and userspace races with
> > mkdir() or symlink().
> 
> 	Ok, I've merged all this work.  Please check out my configfs-ALL
> branch and make sure I have everything we've worked on.
> 
> http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=configfs-ALL
> git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-ALL

Looks complete.

There is still a few things in flight:
- error handling in config_*_init_type_name(): has rather low priority in my
  TODO list, will come back to it probably in a few weeks.
- silencing lockdep: hope to get something in the next few days.
- a small locking cleanup in configfs_rmdir(): will do at the same time as
  lockdep stuff.

Thanks,

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080716/c8deb933/attachment.bin 
