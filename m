From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 22 16:52:18 2004
Subject: [Ocfs2-devel] Re: [PATCH]Fix for 2.6 unmount crash
In-Reply-To: <200403181614.i2IGEMH1028597@penguin.co.intel.com>
References: <200403181614.i2IGEMH1028597@penguin.co.intel.com>
Message-ID: <20040322225214.GD22829@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 18, 2004 at 08:14:22AM -0800, Rusty Lynch wrote:
> This patch catches the scenario where a dismount has already
> been started, and a ocfs_release_cached_oin() has been kicked
> off as a result of ocfs_inode_hash_destroy() calling iput()
> on any remaining inodes.
It took me a few days, but this is in there now.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
