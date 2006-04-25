From: Christoph Hellwig <hch@lst.de>
Date: Tue, 25 Apr 2006 23:55:48 +0200
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <20060425183553.GB10524@ca-server1.us.oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
Message-ID: <20060425215548.GB16170@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 25, 2006 at 11:35:53AM -0700, Mark Fasheh wrote:
> -Htree support

Please not.  htree is just the worst possible directory format around.
Do some nice hashed or btree directories, but don't try this odd hack
again. Especially as the only reason it was developed for in ext2/3
doesn't work very well in a cluster filesystem anyway - to access the
new htree all nodes would have to support the format anyway, so the
whole easy up/downgrade thing doesn't matter at all.

> -Extended attributes: This might be another area where we
>  steal^H^H^H^H^Hcopy some good code from Ext3 :) On top of this one can
>  trivially implement posix acls. We're not likely to support EA block
>  sharing though as it becomes difficult to manage across the cluster.

again the ext3 implementation might not be the best.  I'd say look at
jfs or xfs (in the latter case of course with a less monsterous btree
implementation)
