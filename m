From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 17 16:17:39 2004
Subject: [Ocfs2-devel] [Build PATCH]Add --enable-lockres-debug
In-Reply-To: <20040317210207.GA22346@penguin.co.intel.com>
References: <200403171825.i2HIPRIn022075@penguin.co.intel.com>
	<20040317195254.GJ20057@ca-server1.us.oracle.com>
	<20040317210207.GA22346@penguin.co.intel.com>
Message-ID: <20040317221733.GK20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 17, 2004 at 01:02:07PM -0800, Rusty Lynch wrote:
> yes.  On my 2.6 build there is a crash when I umount if ocfs_put_inode
> comes across a non-root inode that still has an oin associated with it.
> The problem is that in ocfs_release_cached_oin we try to use oin->lock_res
> which was already free'ed in ocfs_hash_destroy, and not set to null.
Ok, cool. I put this in SVN then. Btw, are you sure all your files are up to
date? I had to massage the configure.in stuff because it caused conflicts
with some code that been there for a while (or so I'm told)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
