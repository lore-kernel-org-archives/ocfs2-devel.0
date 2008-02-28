From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Feb 28 15:06:28 2008
Subject: [Ocfs2-devel] [PATCH 1/3] Add a new parameter for
	ocfs2_reserve_suballoc_bits.V2
In-Reply-To: <20080228065904.GA29259@tma-pc1.cn.oracle.com>
References: <20080228063438.GA27318@tma-pc1.cn.oracle.com>
	<20080228065904.GA29259@tma-pc1.cn.oracle.com>
Message-ID: <20080228230559.GU27865@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 28, 2008 at 02:59:04PM +0800, tao.ma wrote:
> In some cases(Inode stealing from other nodes), we may not want
> ocfs2_reserve_suballoc_bits to allocate new groups from the
> global_bitmap since it may already be full. So add a new parameter
> for this.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
