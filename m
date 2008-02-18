From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 18 11:36:26 2008
Subject: [Ocfs2-devel] Re: [PATCH 3/6] fs/ocfs2: Use DIV_ROUND_UP
In-Reply-To: <Pine.LNX.4.58.0802141614400.1185@pc-041.diku.dk>
References: <Pine.LNX.4.58.0802141614400.1185@pc-041.diku.dk>
Message-ID: <20080218193611.GY22671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, Feb 14, 2008 at 04:15:17PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
> (d)) but is perhaps more readable.
> 
> An extract of the semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @haskernel@
> @@
> 
> #include <linux/kernel.h>
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> (
> - (n + d - 1) / d
> + DIV_ROUND_UP(n,d)
> |
> - (n + (d - 1)) / d
> + DIV_ROUND_UP(n,d)
> )
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> - DIV_ROUND_UP((n),d)
> + DIV_ROUND_UP(n,d)
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> - DIV_ROUND_UP(n,(d))
> + DIV_ROUND_UP(n,d)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Mark Fasheh <mark.fasheh@oracle.com>
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
