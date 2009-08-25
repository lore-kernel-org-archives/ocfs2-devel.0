From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Aug 2009 15:13:25 +0200
Subject: [Ocfs2-devel] [PATCH 12/17] ocfs2: Update syncing
	after	splicing to match generic version
In-Reply-To: <20090824184009.GC7698@mail.oracle.com>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-13-git-send-email-jack@suse.cz>
	<20090824183543.GF2818@wotan.suse.de>
	<20090824184009.GC7698@mail.oracle.com>
Message-ID: <20090825131325.GE405@duck.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon 24-08-09 11:40:09, Joel Becker wrote:
> On Mon, Aug 24, 2009 at 11:35:43AM -0700, Mark Fasheh wrote:
> > On Fri, Aug 21, 2009 at 07:24:02PM +0200, Jan Kara wrote:
> > > Update ocfs2 specific splicing code to use generic syncing helper. The sync now
> > > does not happen under rw_lock because generic_write_sync() acquires i_mutex
> > > which ranks above rw_lock. That should not matter because standard fsync path
> > > does not hold it either.
> > 
> > Thanks Jan,
> > 
> > Acked-by: Mark Fasheh <mfasheh@suse.com>
> 
> <aol>Me too!</aol>
> Acked-by: Joel Becker <joel.becker@oracle.com>
  Thanks. BTW: There's also the patch
ocfs2: Use __generic_file_aio_write instead of generic_file_aio_write_nolock
  in the series you might want to have a look at. Actually, I did a
straightforward opencoding of generic_osync_inode() but if you agree it's
a good thing to do, I can move the whole sync to the end of the function
out of i_mutex because AFAICS there's no real reason why
filemap_fdatawrite_range() or jbd2_journal_force_commit() should need any
cluster lock or mutex. We probably only need to decide under those locks,
whether we need to call jbd2_journal_force_commit() or not.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
