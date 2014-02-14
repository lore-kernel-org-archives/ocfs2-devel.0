From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 14 Feb 2014 14:18:18 -0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: improve fsync efficiency and
	fix deadlock	between aio_write and sync_file
In-Reply-To: <20140214023234.GB8800@birch.djwong.org>
References: <20140214023234.GB8800@birch.djwong.org>
Message-ID: <20140214221818.GC5716@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 13, 2014 at 06:32:34PM -0800, Darrick J. Wong wrote:
> Currently, ocfs2_sync_file grabs i_mutex and forces the current
> journal transaction to complete.  This isn't terribly efficient, since
> sync_file really only needs to wait for the last transaction involving
> that inode to complete, and this doesn't require i_mutex.
> 
> Therefore, implement the necessary bits to track the newest tid
> associated with an inode, and teach sync_file to wait for that instead
> of waiting for everything in the journal to commit.  Furthermore, only
> issue the flush request to the drive if jbd2 hasn't already done so.
> 
> This also eliminates the deadlock between ocfs2_file_aio_write() and
> ocfs2_sync_file().  aio_write takes i_mutex then calls
> ocfs2_aiodio_wait() to wait for unaligned dio writes to finish.
> However, if that dio completion involves calling fsync, then we can
> get into trouble when some ocfs2_sync_file tries to take i_mutex.
> 
> v2: Update tid when updating mtime.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks Darrick, this looks good.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
