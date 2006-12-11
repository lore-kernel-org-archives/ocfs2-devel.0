From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 11 14:26:41 2006
Subject: [Ocfs2-devel] Re: [RFC: -mm patch] OCFS2: make code static
In-Reply-To: <20061211191001.GF28443@stusta.de>
References: <20061211005807.f220b81c.akpm@osdl.org>
	<20061211191001.GF28443@stusta.de>
Message-ID: <20061211222636.GC6831@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, kurt.hackel@oracle.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Adrian,

On Mon, Dec 11, 2006 at 08:10:01PM +0100, Adrian Bunk wrote:
> On Mon, Dec 11, 2006 at 12:58:07AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.19-rc6-mm2:
> >...
> >  git-ocfs2.patch
> >...
> >  git trees.
> >...
> 
> This patch makes needlessly global code static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

I hand-merged the tcp.c change as the patch introducing that variable is
going upstream soon. Would you mind sending me the dlm/* stuff as a seperate
patch?

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
