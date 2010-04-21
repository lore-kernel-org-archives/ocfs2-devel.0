From: Jan Kara <jack@suse.cz>
Date: Wed, 21 Apr 2010 02:04:38 +0200
Subject: [Ocfs2-devel] Ocfs2 leaking inodes on failed allocation
In-Reply-To: <20100420190407.GB15504@mail.oracle.com>
References: <20100420180053.GD3885@quack.suse.cz>
	<20100420190407.GB15504@mail.oracle.com>
Message-ID: <20100421000437.GA4128@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 20-04-10 12:04:08, Joel Becker wrote:
> On Tue, Apr 20, 2010 at 08:00:54PM +0200, Jan Kara wrote:
> > the following errors:
> > 1163.522931] (4774,1):ocfs2_query_inode_wipe:898 ERROR: bug expression:
> > !(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))
> > [ 1163.522938] (4774,1):ocfs2_query_inode_wipe:898 ERROR: Inode 77233
> > (on-disk 77233) not orphaned! Disk flags  0x1, inode flags 0x0
> 
> 	See the thread starting "Subject: [Ocfs2-devel] [PATCH] ocfs2:
> alloc orphaned inode in ocfs2_symlink".  I'll sum up here.
  Ah, thanks. I didn't know Dongyang has already raised this in this list.
Sorry for the duplicate question.

> > The easiest solution would be to always create inodes in the orphan
> > directory (we even have a function ocfs2_create_inode_in_orphan for this).
> > The downside this has would be that I expect we would start contending on
> > orphan dir i_mutex quite early and thus fs scalability would suffer a lot.
> > Also there's some additional IO and CPU cost involved...
> 
> 	Yeah, this is a non-starter.
> 
> > The last idea I have is that we could "undo" the inode allocation and
> > other operations we did in the transaction so far. But looking at the code
> > it would get nasty quickly - all the xattr handling which gets inode locks,
> > starts & stops transactions, etc...
> 
> 	This is the "best" solution, but it requires some thought and
> care.  We'd love to get here someday.
  Hmm, in principle I agree it should be doable. But I've actually went
through xattr paths etc. and I'm bit skeptical we are able to ever get all
the paths right ;).

> > Any other ideas? What would make things much easier would be if orphan
> > handling was more lightweight like it is e.g. in ext3 / ext4 - there we
> > have just linked list of orphaned inodes and so if we decide an inode needs
> > to be orphaned, we just have to modify the superblock (orphan list head)
> > and the inode (to point at the current orphan list head)... In OCFS2 we
> > could have a per-slot lists like this but a change like this would probably
> > be an overkill for the above bug so it would make sence only if there would
> > be other benefits from this.
> 
> 	We're not going to change our orphan storage, either.  This
> still needs locking in the cluster, and that's just a pain.
  Well, if we'd have node-local lists of orphaned inodes, I don't think any
additional cluster locking would be needed. But maybe I miss something.
Anyway I'm mostly happy with the workaround you describe below.

> 	Near the end of the referenced thread, Mark told Dong Yang to
> implement the OCFS2_INODE_SKIP_ORPHAN_DIR flag.  This flag merely lets
> delete_inode know that we never orphaned the sucker.  delete_inode can
> do the rest of its work without triggering the above warning.
  OK. That should be a reasonable hack to get out of problems in most
cases. Now I wonder why Dongyang was poking me today about other solutions
of the problem which made me send the original email ;)

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
