From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 6 Dec 2010 17:07:46 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <1289902422-3315-3-git-send-email-tristan.ye@oracle.com>
References: <1289902422-3315-1-git-send-email-tristan.ye@oracle.com>
	<1289902422-3315-3-git-send-email-tristan.ye@oracle.com>
Message-ID: <20101207010746.GM16687@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 16, 2010 at 06:13:41PM +0800, Tristan Ye wrote:
> +	if (inode_alloc)
> +		iput(inode_alloc);

	Do the iput up in the calling function where it matches the
get_system_file_inode() call.  This just makes it easier to spot the
get/put pair.

Joel

-- 

"Under capitalism, man exploits man.  Under Communism, it's just 
   the opposite."
				 - John Kenneth Galbraith

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
