From: Christoph Hellwig <hch@lst.de>
Date: Fri, 25 Sep 2015 06:49:37 -0700
Subject: [Ocfs2-devel] simplify configfs attributes
Message-ID: <1443189000-13398-1-git-send-email-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org, Pratyush Anand <pratyush.anand@gmail.com>, Felipe Balbi <balbi@ti.com>, cluster-devel@redhat.com, target-devel@vger.kernel.org, Tejun Heo <tj@kernel.org>, ocfs2-devel@oss.oracle.com

This series consolidates the code to implement configfs attributes
by providing the ->show and ->store method in common code and using
container_of in the methods to access the containing structure.

This reduces source and binary size of configfs consumers a lot.
