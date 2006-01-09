From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 9 Jan 2006 11:11:27 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix compilation on ia64
In-Reply-To: <20060109173640.GA25744@locomotive.unixthugs.org>
References: <20060109173640.GA25744@locomotive.unixthugs.org>
Message-ID: <20060109191126.GF3313@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Mahoney <jeffm@suse.com>
Cc: ocfs2-devel@oss.oracle.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Jan 09, 2006 at 12:36:40PM -0500, Jeff Mahoney wrote:
> 
>  Including <asm/signal.h> results in compilation failure on ia64 due to
>  not including <linux/compiler.h>
> 
>  Including <linux/signal.h> corrects the problem.
That looks good - thanks for the patch.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
