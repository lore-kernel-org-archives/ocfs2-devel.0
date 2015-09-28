From: David Teigland <teigland@redhat.com>
Date: Mon, 28 Sep 2015 09:49:49 -0500
Subject: [Ocfs2-devel] [Cluster-devel] [PATCH 17/23] dlm: use
 per-attribute show and store methods
In-Reply-To: <1443189000-13398-18-git-send-email-hch@lst.de>
References: <1443189000-13398-1-git-send-email-hch@lst.de>
	<1443189000-13398-18-git-send-email-hch@lst.de>
Message-ID: <20150928144949.GA30917@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Pratyush Anand <pratyush.anand@gmail.com>, netdev@vger.kernel.org, linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>, cluster-devel@redhat.com, target-devel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com

On Fri, Sep 25, 2015 at 06:49:54AM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dlm/config.c | 288 +++++++++++++++-----------------------------------------
>  1 file changed, 74 insertions(+), 214 deletions(-)

Looks good to me.
Dave
