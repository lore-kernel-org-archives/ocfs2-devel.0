From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Apr 19 12:56:17 2004
Subject: [Ocfs2-devel] Patches to fix the OCFS2 bug 54, which cause crash
	in the second mount under kernel 2.6.
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65E68@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65E68@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040419175612.GI10471@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 16, 2004 at 03:40:58PM +0800, Zhang, Sonic wrote:
> Hi Mark,
> 
> 	I attach a new patch for ocfs based on your suggestion to walk
> 	around the bug in JBD before it is fixed in kernel.
Alright Sonic, this has been committed. Thanks for catching the #if case. I
re-added my comment which you removed :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
