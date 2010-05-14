From: Jan Kara <jack@suse.cz>
Date: Fri, 14 May 2010 10:06:58 +0200
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Do not map blocks from local
 quota file on each write
In-Reply-To: <20100513234453.GD13692@mail.oracle.com>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
	<1273780683-3638-3-git-send-email-jack@suse.cz>
	<20100513234453.GD13692@mail.oracle.com>
Message-ID: <20100514080658.GA3488@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu 13-05-10 16:44:53, Joel Becker wrote:
> On Thu, May 13, 2010 at 09:57:58PM +0200, Jan Kara wrote:
> > There is no need to map offset of local dquot structure to on disk block
> > in each quota write. It is enough to map it just once and store the physical
> > block number in quota structure in memory. Moreover this simplifies locking
> > as we do not have to take ip_alloc_sem from quota write path.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 	Am I correct that quota files cannot be shrunk in a running
> filesystem?
  Yes, quota files are only grown when the filesystem is mounted. Shrinking
is done only by fsck.ocfs2.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
