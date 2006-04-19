From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 18 Apr 2006 21:42:43 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] Remove redundant NULL checks before
	[kv]free - in fs/
In-Reply-To: <200604170329.11589.jesper.juhl@gmail.com>
References: <200604170329.11589.jesper.juhl@gmail.com>
Message-ID: <20060419044243.GJ25194@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Kurt Hackel <kurt.hackel@oracle.com>, ocfs2-devel@oss.oracle.com, Jan Engelhardt <jengelh@linux01.gwdg.de>

On Mon, Apr 17, 2006 at 03:29:11AM +0200, Jesper Juhl wrote:
> Remove redundant NULL checks before kfree
> for fs/
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Mark Fasheh <mark.fasheh@oracle.com>
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
