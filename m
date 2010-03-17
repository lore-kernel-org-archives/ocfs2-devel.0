From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 17 Mar 2010 12:29:05 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update i_blocks in reflink
	operations.
In-Reply-To: <1268186212-11949-1-git-send-email-tao.ma@oracle.com>
References: <1268186212-11949-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100317192905.GC2930@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 10, 2010 at 09:56:52AM +0800, Tao Ma wrote:
> In reflink, we need to upate i_blocks for the target inode.
> 
> Reported-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"To fall in love is to create a religion that has a fallible god."
        -Jorge Luis Borges

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
