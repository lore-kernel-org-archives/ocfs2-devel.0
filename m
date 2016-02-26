From: Felipe Balbi <balbi@kernel.org>
Date: Fri, 26 Feb 2016 14:43:00 +0200
Subject: [Ocfs2-devel] [PATCH] configfs: switch ->default groups to a
	linked list
In-Reply-To: <1456490031-7132-1-git-send-email-hch@lst.de>
References: <1456490031-7132-1-git-send-email-hch@lst.de>
Message-ID: <87y4a7fxrf.fsf@ti.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>, jlbec@evilplan.org
Cc: laurent.pinchart@ideasonboard.com, target-devel@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Replace the current NULL-terminated array of default groups with a linked
> list.  This gets rid of lots of nasty code to size and/or dynamically
> allocate the array.
>
> While we're at it also provide a conveniant helper to remove the default
> groups.
>

looks ok to my eyes. For drivers/usb/gadget:

Acked-by: Felipe Balbi <balbi@kernel.org>

-- 
balbi
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 818 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160226/0cdfe5b0/attachment.bin 
