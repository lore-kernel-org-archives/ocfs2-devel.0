From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Sep  6 11:34:10 2007
Subject: [Ocfs2-devel] [patch] Fix a wrong cluster calculation.
In-Reply-To: <20070906000225.GA4698@tma-pc1.cn.oracle.com>
References: <20070905235808.031850823@oracle.com>
	<20070906000225.GA4698@tma-pc1.cn.oracle.com>
Message-ID: <20070906183408.GI31390@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 06, 2007 at 08:02:25AM +0800, tao.ma wrote:
> In ocfs2_alloc_write_write_ctxt, the written clusters length is calculated
> by the byte length only. This may cause some problems if we start to write
> at some position in the end of one cluster and last to a second cluster
> while the "len" is smaller than a cluster size. In that case, we have to
> write 2 clusters actually.
> So we have to take the start position into consideration also.

Good catch Tao, thanks.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
