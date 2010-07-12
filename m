From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 11:32:45 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove the redundant cpu_to_le64.
In-Reply-To: <1278558671-18125-1-git-send-email-tao.ma@oracle.com>
References: <1278558671-18125-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100712183245.GC12179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 08, 2010 at 11:11:11AM +0800, Tao Ma wrote:
> In ocfs2_block_group_alloc, we set c_blkno by bg->bg_blkno.
> But actually bg->bg_blkno is already changed to little endian
> in ocfs2_block_group_fill. So remove the extra cpu_to_le64.
> 
> Reported-by: Marcos Matsunaga <Marcos.Matsunaga@oracle.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

	f/8 and be there.

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
