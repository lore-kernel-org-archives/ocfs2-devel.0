From: Paul Taysom <Paul.Taysom@novell.com>
Date: Thu, 11 May 2006 14:40:46 -0600
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <446398D3.7010508@suse.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<446398D3.7010508@suse.com>
Message-ID: <44634CAB.C8CD.0002.0@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

What make the online file system resize tricky is updating all the
allocation chains.  The last block of each of the existing chains needs
to be updated to point to the new blocks in the chains.

Would it be possible to get rid of chains and just compute the next
block in the chain?

Paul

>>Online file system resize

>This would be nice, and I think easily done in the same manner ext3
>does. Anything outside the file system's current view of the block
>device can be initialized in userspace, and the last block group,
>bitmaps, and superblock would be adjusted by an ioctl in kernelspace.

 
>>> Jeff Mahoney <jeffm@suse.com> 05/11/06 2:04 pm >>> 
