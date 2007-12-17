From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 17 17:34:44 2007
Subject: [Ocfs2-devel] Re: [Ocfs2-tools-devel] [PATCH 5/6] Modify fsck to
	trust global bitmap than super block.take 3
In-Reply-To: <20071218011410.GA23473@tma-pc1.cn.oracle.com>
References: <47671D39.6090509@oracle.com>
	<20071218011410.GA23473@tma-pc1.cn.oracle.com>
Message-ID: <20071218013307.GA13821@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 18, 2007 at 09:14:10AM +0800, tao.ma wrote:
> In resize, we update the global_bitmap first and then the super block.
> So if there is any corruption between these 2 steps, there will be a
> inconsistence. In kernel we use the information in global_bitmap,
> so fsck.ocfs2 should also trust it during the check.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
