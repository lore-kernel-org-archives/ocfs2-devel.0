From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 29 16:40:05 2004
Subject: [Ocfs2-devel] Re: [PATCH] correctly set inode->i_rdev
In-Reply-To: <200403270516.i2R5Gpac012997@penguin.co.intel.com>
References: <200403270516.i2R5Gpac012997@penguin.co.intel.com>
Message-ID: <20040329224000.GX10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 26, 2004 at 09:16:51PM -0800, Rusty Lynch wrote:
> The following minimal patch fixes bug #52.  For some reason we were
> always setting the inode->i_rdev to the super block's dev while 
> populating the inode.
Ok, I like this approach better than my original one. 
It also means that OCFS_SET_INODE_DEV isn't used anymore so I'll take that
out too.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
