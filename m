From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Apr  2 12:54:43 2004
Subject: [Ocfs2-devel] Can you check the patch for bug 48 and commit?
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65E4D@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65E4D@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040402185439.GG10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 31, 2004 at 12:10:22PM +0800, Zhang, Sonic wrote:
> Hi Mark,
> 
> 	OK, I made the same NPTL fix. 
> 	Please see the attachment.
You lost the if (signal_pending(current)) line! I fixed it myself.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
