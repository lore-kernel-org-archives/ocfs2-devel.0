From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Mar 16 18:37:46 2004
Subject: [Ocfs2-devel] Re: [PATCH]bugfix for unlinking on 2.6 kernel
In-Reply-To: <200403150058.i2F0wnIc001649@penguin.co.intel.com>
References: <200403150058.i2F0wnIc001649@penguin.co.intel.com>
Message-ID: <20040317003741.GG20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Mar 14, 2004 at 04:58:49PM -0800, Rusty Lynch wrote:
> On a 2.6 kernel, sys_unlink will wrap the call to the filesystem
> unlink function with atomic_inc/atomic_dec of the inode->i_count.
> 
> The following minimal patch fixes ocfs_unlink to take this into
> consideration.  (Without this patch attempting to delete any file
> on a ocfs2 volume from a 2.6 bases system would result in an -EBUSY
> error.)
Looks good.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
