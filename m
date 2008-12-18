From: Ankit Jain <me@ankitjain.org>
Date: Thu, 18 Dec 2008 09:51:10 -0000
Subject: [Ocfs2-devel] [xfs-masters] [PATCH][RFC] fs: Add new
 pre-allocation ioctls to vfs for compatibility with legacy xfs ioctls
In-Reply-To: <20081217211550.GF8791@wotan.suse.de>
References: <49460F88.2080408@ankitjain.org>
	<20081217202815.GE8791@wotan.suse.de>
	<494969C6.4090500@sandeen.net>
	<20081217211550.GF8791@wotan.suse.de>
Message-ID: <494A1CE5.8020007@ankitjain.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Wed, Dec 17, 2008 at 03:06:14PM -0600, Eric Sandeen wrote:
> 
> Actually, yeah agreed - I take that back. Old users are already getting them
> from file system headers, new ones should use fallocate. So there's no need
> to expose the ioctls to userspace, at least not if all we're talking about
> is the RESVP ioctls.

Makes sense. So I can just keep them in falloc.h in a #ifdef __KERNEL__ ? Or
should this be in a new ioctl.h ?

-Ankit

> 	--Mark
> 
> --
> Mark Fasheh
