From: Ankit Jain <me@ankitjain.org>
Date: Fri, 19 Dec 2008 02:31:05 +0530
Subject: [Ocfs2-devel] [PATCH][RFC] fs: Add new pre-allocation ioctls to
 vfs for compatibility with legacy xfs ioctls
In-Reply-To: <20081217202815.GE8791@wotan.suse.de>
References: <49460F88.2080408@ankitjain.org>
	<20081217202815.GE8791@wotan.suse.de>
Message-ID: <494ABA11.2050205@ankitjain.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

Mark Fasheh wrote:
> On Mon, Dec 15, 2008 at 01:34:24PM +0530, Ankit Jain wrote:
>> 2. Should the corresponding ioctls be removed from ocfs2?
> 
> Well, a small amount of the code in fs/ocfs2/ioctl.c can certainly go away.
> Shouldn't we be talking about doing the same for xfs too?

Reading the code a bit, my understanding is that as compat_ioctl is also
supported and that just delegates to ioctl (ocfs2_ioctl), so we can't
remove the *_RESVSP* handling.
Same goes for xfs also.

Does that sound fair or did I not understand it correctly?

-Ankit
