From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 13 Mar 2019 09:37:34 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix inode bh swapping mixup in
 ocfs2_reflink_inodes_lock
In-Reply-To: <20190312214910.GK20533@magnolia>
References: <20190312214910.GK20533@magnolia>
Message-ID: <20190313093734.b924a6a8f07afd277ab96e14@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, mark@fasheh.com, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>, Joseph Qi <joseph.qi@huawei.com>, Mark Fasheh <mfasheh@versity.com>

On Tue, 12 Mar 2019 14:49:10 -0700 "Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ocfs2_reflink_inodes_lock can swap the inode1/inode2 variables so that
> we always grab cluster locks in order of increasing inode number.
> Unfortunately, we forget to swap the inode record buffer head pointers
> when we've done this, which leads to incorrect bookkeepping when we're
> trying to make the two inodes have the same refcount tree.
> 
> This has the effect of causing filesystem shutdowns if you're trying to
> reflink data from inode 100 into inode 97, where inode 100 already has a
> refcount tree attached and inode 97 doesn't.  The reflink code decides
> to copy the refcount tree pointer from 100 to 97, but uses inode 97's
> inode record to open the tree root (which it doesn't have) and blows up.
> This issue causes filesystem shutdowns and metadata corruption!

Sounds serious.

> Fixes: 29ac8e856cb369 ("ocfs2: implement the VFS clone_range, copy_range, and dedupe_range features")]

November 2016.  Should we be adding cc:stable?

Folks, could we please get prompt review of this one?

> mark at fasheh.com

hm, I have mfasheh at versity.com but MAINTAINERS says mark at fasheh.com. 
Mark, can you please clarify?
