From: Ankit Jain <me@ankitjain.org>
Date: Thu, 18 Dec 2008 09:55:26 -0000
Subject: [Ocfs2-devel] [PATCH][RFC] fs: Add new pre-allocation ioctls to
 vfs for compatibility with legacy xfs ioctls
In-Reply-To: <9D2593C9-08EB-486C-AAF5-E83A1EAEE9B9@sgi.com>
References: <49460F88.2080408@ankitjain.org>
	<9D2593C9-08EB-486C-AAF5-E83A1EAEE9B9@sgi.com>
Message-ID: <494A1DE3.5090203@ankitjain.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Felix Blyakher <felixb@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

Felix Blyakher wrote:
> 
>> This patch adds ioctls to vfs for compatibility with legacy XFS
>> pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
>> effectively invokes sys_fallocate for the new ioctls.
> 
> I don't think we can use sys_fallocate for XFS_IOC_UNRESVSP*
> commands, which suppose to release currently allocated file
> blocks.
> See more comments below.

My bad :( I'll drop the *UNRESV* completely from the new ioctl and
post an updated patch.

-Ankit
