From: Eric Sandeen <sandeen@sandeen.net>
Date: Wed, 17 Dec 2008 21:06:24 -0000
Subject: [Ocfs2-devel] [xfs-masters] [PATCH][RFC] fs: Add new
 pre-allocation ioctls to vfs for compatibility with legacy xfs ioctls
In-Reply-To: <20081217202815.GE8791@wotan.suse.de>
References: <49460F88.2080408@ankitjain.org>
	<20081217202815.GE8791@wotan.suse.de>
Message-ID: <494969C6.4090500@sandeen.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Ankit Jain <me@ankitjain.org>, linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Mon, Dec 15, 2008 at 01:34:24PM +0530, Ankit Jain wrote:
>> This patch adds ioctls to vfs for compatibility with legacy XFS
>> pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
>> effectively invokes sys_fallocate for the new ioctls.
>> Note: These legacy ioctls are also implemented by OCFS2.
>>
>> There are some things that I'm not sure about:
>> 1. Should the struct space_resv be exposed to user-space? If not,
>> then what would be the right place to put it? And the ioctl
>> definitions?
> 
> Yes. As far as where to put it, I'm not sure. Maybe falloc.h?

I'd sort of rather not; why should that legacy struct space_resv be
available in a header... I thought this was for people already using the
xfs ioctl, in which case they are already using the xfs header... and if
they want preallocation in any new work, they should use fallocate()
instead, yes?

I mean it wouldn't hurt anything but it sort of confuses the interface
story IMHO.

-Eric
