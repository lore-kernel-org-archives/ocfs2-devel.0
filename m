From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 17 17:36:40 2007
Subject: [Ocfs2-devel] [PATCH 1/6] Move resize function out of
	tunefs.c, take 3
In-Reply-To: <20071218011219.GA23419@tma-pc1.cn.oracle.com>
References: <47671D39.6090509@oracle.com>
	<20071218011219.GA23419@tma-pc1.cn.oracle.com>
Message-ID: <20071218013442.GB13821@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 18, 2007 at 09:12:19AM +0800, tao.ma wrote:
> We will add online resize in tunefs.ocfs2, and it will be complicated.
> so add a new file resize.c in it and move all resize function out of
> tunefs.c.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
