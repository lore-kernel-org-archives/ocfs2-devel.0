From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 3 May 2009 04:03:25 -0400
Subject: [Ocfs2-devel] [PATCH 2/3] fs: Add vfs_reflink() and the
	->reflink() inode	operation.
In-Reply-To: <1241331303-23753-3-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-3-git-send-email-joel.becker@oracle.com>
Message-ID: <20090503080324.GB27287@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

> +int vfs_reflink(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
>
>+{

Would be nice to have a little kerneldoc comment for it.  Also please
avoid the > 80 har lines

> +EXPORT_SYMBOL(vfs_reflink);

No really good reason to export this.  Most vfs_ helpers are exported
for nfsd, and I can't really see nfsd use this anytime soon.
