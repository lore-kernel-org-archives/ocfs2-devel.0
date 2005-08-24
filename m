From: Manish Singh <manish.singh@oracle.com>
Date: Wed Aug 24 11:06:28 2005
Subject: [Ocfs2-devel] Minor fs/Kconfig cleanup
In-Reply-To: <200508231800.00580.agruen@suse.de>
References: <200508231800.00580.agruen@suse.de>
Message-ID: <20050824160633.GA21175@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 23, 2005 at 06:00:00PM +0200, Andreas Gruenbacher wrote:
> Hello,
> 
> the current ocfs2 code nicely adds "select JBD" for EXT3_FS, but doesn't 
> remove the following line, which is obsolete after that. Here's a patch:

Nice catch. The change will be incorporated next time we spin mainline
patches.

-Manish
