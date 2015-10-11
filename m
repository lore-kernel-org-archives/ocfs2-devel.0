From: Christoph Hellwig <hch@lst.de>
Date: Sun, 11 Oct 2015 15:10:22 +0200
Subject: [Ocfs2-devel] [PATCH 02/23] usb-gadget: use per-attribute show
	and store	methods
In-Reply-To: <87io6fu4ci.fsf@saruman.tx.rr.com>
References: <1443879179-22280-1-git-send-email-hch@lst.de>
	<1443879179-22280-3-git-send-email-hch@lst.de>
	<87io6fu4ci.fsf@saruman.tx.rr.com>
Message-ID: <20151011131022.GB3890@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Felipe Balbi <balbi@ti.com>
Cc: Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Tejun Heo <tj@kernel.org>, Pratyush Anand <pratyush.anand@gmail.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, target-devel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org

On Fri, Oct 09, 2015 at 04:19:57PM -0500, Felipe Balbi wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> 
> I suppose this depends on other fs/configfs changes ?

The whole series should be applied in order, but doesn't have any
other dependencies.
