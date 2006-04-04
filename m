From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 3 Apr 2006 21:28:34 -0700
Subject: [Ocfs2-devel] [2.6 patch] fs/ocfs2/dlm/dlmrecovery.c: make
	dlm_lockres_master_requery() static
In-Reply-To: <20060331145355.GF3893@stusta.de>
References: <20060331145355.GF3893@stusta.de>
Message-ID: <20060404042834.GZ25194@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Fri, Mar 31, 2006 at 04:53:55PM +0200, Adrian Bunk wrote:
> dlm_lockres_master_requery() became global without any external usage.
Looks good, thanks.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
