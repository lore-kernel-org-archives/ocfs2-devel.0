From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 19 Dec 2008 09:00:12 -0000
Subject: [Ocfs2-devel] [PATCH v2] fs: Add new pre-allocation ioctls to
	vfs for	compatibility with legacy xfs ioctls
In-Reply-To: <20081219043744.GC17177@disturbed>
References: <494ABEBC.8060101@ankitjain.org> <20081219043744.GC17177@disturbed>
Message-ID: <20081219085912.GA30293@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ankit Jain <me@ankitjain.org>, Al Viro <viro@zeniv.linux.org.uk>, mfasheh@suse.com, linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-ma

On Fri, Dec 19, 2008 at 03:37:44PM +1100, Dave Chinner wrote:
> XFS_IOC_RESVSP supports invisible I/O, and that means
> XFS_IOC_RESVSP needs to be passed through to vfs_ioctl()
> to vector to XFS to handle.

When the current XFS git tree gets merged to mainline before this
patch.  invisible I/O handling is now FMODE_NOCMTIME in file->f_flags
which this patch will pass through to the filesystem.  We just need
to chage xfs_vn_fallocate ot honour it.
