From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Jan  2 19:01:29 2008
Subject: [Ocfs2-devel] Re: [Ocfs2-tools-devel] [PATCH 1/6] Move resize
 function out of	tunefs.c, take 3
In-Reply-To: <20071218011219.GA23419@tma-pc1.cn.oracle.com>
References: <20071218011219.GA23419@tma-pc1.cn.oracle.com>
Message-ID: <477C4F99.20004@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> We will add online resize in tunefs.ocfs2, and it will be complicated.
> so add a new file resize.c in it and move all resize function out of
> tunefs.c.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> --
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
