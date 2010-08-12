From: Joel Becker <Joel.Becker@Oracle.COM>
Date: Wed, 11 Aug 2010 17:31:28 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove obscure error handling in
	direct_write.
In-Reply-To: <1276073339-7427-1-git-send-email-tao.ma@oracle.com>
References: <1276073339-7427-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100812003127.GC8985@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 09, 2010 at 04:48:59PM +0800, Tao Ma wrote:
> In ocfs2, actually we don't allow any direct write pass i_size,
> see the function ocfs2_prepare_inode_for_write. So we don't
> need the bogus simple_setsize.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

        This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
