From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sun, 15 Jan 2006 22:28:44 -0800
Subject: [Ocfs2-devel] [-mm patch] fs/ocfs2/dlm/dlmrecovery.c must
	#include <linux/delay.h>
In-Reply-To: <20060114195510.GQ29663@stusta.de>
References: <20060114195510.GQ29663@stusta.de>
Message-ID: <20060116062844.GE6373@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sat, Jan 14, 2006 at 08:55:10PM +0100, Adrian Bunk wrote:
> fs/ocfs2/dlm/dlmrecovery.c does now use msleep(), and does therefore 
> need to #include <linux/delay.h> for getting the prototype of this 
> function.
That looks good - thanks Adrian.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
