From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 13 Jun 2008 13:19:46 -0700
Subject: [Ocfs2-devel] [PATCH 1/3][BUGFIX] configfs: Introduce
	configfs_dirent_lock
In-Reply-To: <20080613120923.GJ30804@localhost>
References: <20080612133126.335618468@kerlabs.com>
	<20080612134203.763166823@kerlabs.com>
	<20080612191348.GE5377@mail.oracle.com>
	<20080612222558.GA4012@localdomain>
	<20080613024130.GD20581@mail.oracle.com>
	<20080613104513.GI30804@localhost>
	<20080613120923.GJ30804@localhost>
Message-ID: <20080613201946.GC20576@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 13, 2008 at 02:09:23PM +0200, Louis Rilling wrote:
> Oh, should probably provide some d_revalidate() also, which would return
> -ENOENT for a dentry under a directory flagged with USET_DROPPING. But I'm
> realizing that such "inconsistencies" (some default groups being valid in the
> d_cache and some other ones not) already happen between the time detach_prep()
> has flagged a default group with USET_DROPPING and the default
> group is actually detached. Am I wrong?

	We don't need d_revalidate().  As I stated at the end of my last
email, USET_DROPPING does not mean 'It already went away'.  It just
means we're safe to do so, because we prevent new children.  We actually
make it go away underneath i_mutex.
	The VFS handles inconsistencies between lookup and action.  It's
part of normal operation.  Otherwise, they'd have to hold all the
i_mutexes around lookup and action.

Joel

-- 

"When choosing between two evils, I always like to try the one
 I've never tried before."
        - Mae West

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
