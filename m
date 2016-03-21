From: Christoph Hellwig <hch@lst.de>
Date: Mon, 21 Mar 2016 16:42:59 +0100
Subject: [Ocfs2-devel] HEADUP: generic FICLONE ioctl and ->clone_file_range
	method
Message-ID: <20160321154259.GA14392@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We made the btrfs clone support generic to add NFS support, and support
the future XFS reflink support.  It looks like ocfs2 could support
these as well, so it would be great to get the clone_file_range method
wired up.  xfstests has over 100 testcases for it, so it should be
easy to verify.
