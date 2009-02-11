From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 11 Feb 2009 15:52:37 -0800
Subject: [Ocfs2-devel] Possible lock inversion in directory locking
In-Reply-To: <20090211175834.GD13817@duck.suse.cz>
References: <20090211175834.GD13817@duck.suse.cz>
Message-ID: <20090211235237.GE17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 11, 2009 at 06:58:34PM +0100, Jan Kara wrote:
>   I've been playing lately with lockdep annotations of OCFS2. I seem to
> have most of the false positives sorted out and currently I hit the report
> below.

Cool!


>   I've analyzed that ocfs2_extend_dir() does first lock local alloc inode
> in ocfs2_reserve_clusters() and then acquires ip_alloc_sem from the
> directory. The usual ordering e.g. in ocfs2_write_begin() is to first
> acquire ip_alloc_sem and then lock local alloc. Now these two paths
> obviously cannot deadlock against each other because one works only for
> directories and another only for files. But there are some code paths that
> are shared among all inodes and I see some potential for deadlock there. So
> my question: Is this locking difference between regular files and
> directories intentional? If not, would you agree with changing the lock
> ordering in ocfs2_extend_dir() (because I think different locking in this
> area will bite us sooner or later)?


It's not intentional, no. In fact, we didn't really use ip_alloc_sem for
directories much until recently when Joel standardized it. As far as fixing
this, I'd say it's best to re-order the locks properly.
	--Mark

--
Mark Fasheh
