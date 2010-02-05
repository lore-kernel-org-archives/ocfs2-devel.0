From: Christoph Hellwig <hch@lst.de>
Date: Fri, 5 Feb 2010 17:27:39 +0100
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add new OCFS2_IOC_INFO ioctl
	for	ocfs2 v6.
In-Reply-To: <1265363960-13329-2-git-send-email-tristan.ye@oracle.com>
References: <1265363960-13329-1-git-send-email-tristan.ye@oracle.com>
	<1265363960-13329-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100205162739.GA25027@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 05, 2010 at 05:59:20PM +0800, Tristan Ye wrote:
> Major changes from v4 to v5:
> 
> Fix a ptr passing bug on PPC machine, that is, 32bits binary running
> on 64bits kernel needs to use compat_ptr() to reterive the right ptr
> address from userspace if we use u64 as a pointer.
> 
> The reason why we need this ioctl is to offer the none-privileged
> end-user a possibility to get filesys info gathering.
> 
> We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
> structure to kernel containing an array of request pointers and request
> count, such as,
> 
> * From userspace:
> 
> struct ocfs2_info_blocksize brq = {
> 	.ir_request = {
> 		.ir_magic = OCFS2_INFO_MAGIC,
> 		.ir_code = OCFS2_INFO_BLOCKSIZE,
> 		...
> 	}

I think you've totally overshoot the target here.  Just add a normal
ioctls returning a structure with all interesting information without
all that crap around it.  If it needs to be revisited it's trivial to
just add another ioctl containing more fields.
