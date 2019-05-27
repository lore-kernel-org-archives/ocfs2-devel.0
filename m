From: David Sterba <dsterba@suse.cz>
Date: Mon, 27 May 2019 15:10:41 +0200
Subject: [Ocfs2-devel] [PATCH 2/3] mm: remove cleancache.c
In-Reply-To: <20190527103207.13287-3-jgross@suse.com>
References: <20190527103207.13287-1-jgross@suse.com>
	<20190527103207.13287-3-jgross@suse.com>
Message-ID: <20190527131041.GH15290@twin.jikos.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-erofs@lists.ozlabs.org, devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, Gao Xiang <gaoxiang25@huawei.com>, Chao Yu <yuchao0@huawei.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com

On Mon, May 27, 2019 at 12:32:06PM +0200, Juergen Gross wrote:
> With the removal of tmem and xen-selfballoon the only user of
> cleancache is gone. Remove it, too.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  Documentation/vm/cleancache.rst  | 296 ------------------------------------
>  Documentation/vm/frontswap.rst   |  10 +-
>  Documentation/vm/index.rst       |   1 -
>  MAINTAINERS                      |   7 -
>  drivers/staging/erofs/data.c     |   6 -
>  drivers/staging/erofs/internal.h |   1 -
>  fs/block_dev.c                   |   5 -

For the btrfs part:

>  fs/btrfs/extent_io.c             |   9 --
>  fs/btrfs/super.c                 |   2 -

Acked-by: David Sterba <dsterba@suse.com>
