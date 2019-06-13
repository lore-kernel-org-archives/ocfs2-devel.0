From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 13 Jun 2019 07:51:31 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs: no need to check return value of
 debugfs_create functions
In-Reply-To: <23e08cff-6a97-b583-5dfb-652a51f92d8d@linux.alibaba.com>
References: <20190612152912.GA19151@kroah.com>
	<23e08cff-6a97-b583-5dfb-652a51f92d8d@linux.alibaba.com>
Message-ID: <20190613055131.GD19717@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 13, 2019 at 09:36:38AM +0800, Joseph Qi wrote:
> 
> 
> On 19/6/12 23:29, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> > 
> > Also, because there is no need to save the file dentry, remove all of
> > the variables that were being saved, and just recursively delete the
> > whole directory when shutting down, saving a lot of logic and local
> > variables.
> > 
> > Cc: Mark Fasheh <mark@fasheh.com>
> > Cc: Joel Becker <jlbec@evilplan.org>
> > Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Jia Guo <guojia12@huawei.com>
> > Cc: ocfs2-devel at oss.oracle.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  fs/ocfs2/blockcheck.c          | 54 +++++--------------
> >  fs/ocfs2/blockcheck.h          |  7 +--
> >  fs/ocfs2/cluster/heartbeat.c   | 98 +++++++++-------------------------
> >  fs/ocfs2/cluster/heartbeat.h   |  2 +-
> >  fs/ocfs2/cluster/netdebug.c    | 39 ++++----------
> >  fs/ocfs2/cluster/nodemanager.c |  4 +-
> >  fs/ocfs2/cluster/tcp.c         |  3 +-
> >  fs/ocfs2/cluster/tcp.h         |  5 +-
> >  fs/ocfs2/dlm/dlmdebug.c        | 44 ++-------------
> >  fs/ocfs2/dlm/dlmdebug.h        | 10 ++--
> >  fs/ocfs2/dlm/dlmdomain.c       | 10 +---
> >  fs/ocfs2/dlmglue.c             | 18 +------
> >  fs/ocfs2/super.c               | 29 ++--------
> >  13 files changed, 73 insertions(+), 250 deletions(-)
> > 
> > diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
> > index 005b813a56b6..08ef6c70fc68 100644
> > --- a/fs/ocfs2/blockcheck.c
> > +++ b/fs/ocfs2/blockcheck.c
> > @@ -242,57 +242,31 @@ static struct dentry *blockcheck_debugfs_create(const char *name,
> >  static void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
> >  {
> >  	if (stats) {
> > -		debugfs_remove(stats->b_debug_check);
> > -		stats->b_debug_check = NULL;
> > -		debugfs_remove(stats->b_debug_failure);
> > -		stats->b_debug_failure = NULL;
> > -		debugfs_remove(stats->b_debug_recover);
> > -		stats->b_debug_recover = NULL;
> > -		debugfs_remove(stats->b_debug_dir);
> > +		debugfs_remove_recursive(stats->b_debug_dir);
> >  		stats->b_debug_dir = NULL;
> >  	}
> >  }
> >  
> > -static int ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
> > -					  struct dentry *parent)
> > +static void ocfs2_blockcheck_debug_install(struct ocfs2_blockcheck_stats *stats,
> > +					   struct dentry *parent)
> >  {
> >  	int rc = -EINVAL;
> 
> Here rc is no longer be used, should be removed as well.

Sorry about those, I wonder how 0-day was ignoring those warning
messages.  I'll go fix this and post a v2, thanks for the review!

greg k-h
