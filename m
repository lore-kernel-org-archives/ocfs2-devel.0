From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Date: Sun, 28 Feb 2016 12:58:42 +0200
Subject: [Ocfs2-devel] [PATCH] configfs: switch ->default groups to a
	linked list
In-Reply-To: <1456490031-7132-1-git-send-email-hch@lst.de>
References: <1456490031-7132-1-git-send-email-hch@lst.de>
Message-ID: <56D2D2E2.3000200@dev.mellanox.co.il>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>, jlbec@evilplan.org
Cc: balbi@kernel.org, laurent.pinchart@ideasonboard.com, target-devel@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 26/02/2016 14:33, Christoph Hellwig wrote:
> Replace the current NULL-terminated array of default groups with a linked
> list.  This gets rid of lots of nasty code to size and/or dynamically
> allocate the array.
>
> While we're at it also provide a conveniant helper to remove the default
> groups.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Nice!

> -As a consequence of this, default_groups cannot be removed directly via
> +As a consequence of this, default groups cannot be removed directly via
>   rmdir(2).  They also are not considered when rmdir(2) on the parent
>   group is checking for children.
>

What's changed here?

Other than that, looks good

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
