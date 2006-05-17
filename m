From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 16 May 2006 18:36:28 -0700
Subject: [Ocfs2-devel] [-mm patch] fs/ocfs2/dlm/: cleanups
In-Reply-To: <20060516152641.GA5677@stusta.de>
References: <20060515005637.00b54560.akpm@osdl.org>
	<20060516152641.GA5677@stusta.de>
Message-ID: <20060517013628.GR21588@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, kurt.hackel@oracle.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Adrian,

On Tue, May 16, 2006 at 05:26:41PM +0200, Adrian Bunk wrote:
> This patch #if 0's the no longer used dlm_dump_lock_resources().
> 
> Since this makes dlmdebug.h empty, this patch also removes this header.
> 
> Additionally, the needlessly global dlm_is_node_recovered() is made 
> static.
Yeah, that all looks good - thanks for the patch!
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
