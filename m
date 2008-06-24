From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Tue, 24 Jun 2008 15:30:10 +0200
Subject: [Ocfs2-devel] [PATCH 0/5][BUGFIX] configfs: Fix deadlock of
	rename() vs	rmdir()
In-Reply-To: <20080623223450.GH592@mail.oracle.com>
References: <20080616170057.399713501@kerlabs.com>
	<20080616232657.GE6441@mail.oracle.com>
	<20080623223450.GH592@mail.oracle.com>
Message-ID: <20080624133010.GG7621@hawkmoon.kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jun 23, 2008 at 03:34:50PM -0700, Joel Becker wrote:
> On Mon, Jun 16, 2008 at 04:26:57PM -0700, Joel Becker wrote:
> > 	Ok, this is in-tree for the next merge.  Thanks.
> 
> 	Btw, we still need to solve the lockdep issue.  I'm leaning
> towards turning it off for attach/detach_groups(), because any CHILD+N
> level won't mesh with the VFS anyway.

Yes, and the same for depend_prep()/depend_rollback().

> 	We also need a comment on detach_group() pointing out its
> recursive locking.  It's there in the code, but it's not obvious.

Will do all of this after we are sure not to change things again (see my
separate email on a possible bug in attach_group()).

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080624/ad403db3/attachment.bin 
