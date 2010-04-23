From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 23 Apr 2010 14:44:33 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update VFS inode's id info after
	reflink.
In-Reply-To: <1271829955-3994-1-git-send-email-tao.ma@oracle.com>
References: <1271829955-3994-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100423214433.GA8330@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 21, 2010 at 02:05:55PM +0800, Tao Ma wrote:
> In reflink we update the id info in the disk but forget to update
> the corresponding information in the VFS inode. So update them
> accordingly in case we want to preserve the attributes.
> 
> Reported-by: Jeff Liu <jeff.liu@oracle.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
