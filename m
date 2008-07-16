From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 16 Jul 2008 19:56:54 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup
	after mkdir()	failure
In-Reply-To: <20080716172703.GA18105@ca-server1.us.oracle.com>
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
	<20080711220740.GC22577@mail.oracle.com>
	<20080716130821.GF3801@hawkmoon.kerlabs.com>
	<20080716172703.GA18105@ca-server1.us.oracle.com>
Message-ID: <20080716175654.GA19577@hawkmoon.kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Jul 16, 2008 at 10:27:03AM -0700, Joel Becker wrote:
> On Wed, Jul 16, 2008 at 03:08:21PM +0200, Louis Rilling wrote:
> > There is still a few things in flight:
> > - error handling in config_*_init_type_name(): has rather low priority in my
> >   TODO list, will come back to it probably in a few weeks.
> 
> 	I thought we did this already.  Perhaps I didn't include it?
> Did we have another change to make?

You requested me to move a BUG_ON() earlier (before the actual memory
allocation), and to update documentation. I'm quite in a hurry on other things,
so I'm delaying this (especially the documentation part for which I feel like a
new paragraph is needed).

> 
> > - a small locking cleanup in configfs_rmdir(): will do at the same time as
> >   lockdep stuff.
> 
> 	What sort of change?  I suppose I'll see it when it arrives.

You may look at the retry loop in configfs_rmdir() and see?that locks need only
to be taken inside the loop, not outside. This would result in fewer lines for
exactly the same behavior.

> 	I figure this new stuff will probably miss the .27 window, but
> it sounds like that's fine - nothing too serious, and it will make .28.

Sorry for not being responsive enough. As mentioned above, I have more urgent
things to work on right now.

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080716/28b50dbe/attachment.bin 
