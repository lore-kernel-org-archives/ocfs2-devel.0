From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Mar 11 20:10:20 2004
Subject: [Ocfs2-devel] FW: A patch to remove compile warnings and errors
	if enable memory debugging(OCFS_LINUX_MEM_DEBUG).
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E5A30DD@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E5A30DD@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040312021015.GF7836@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 11, 2004 at 03:59:06PM +0800, Zhang, Sonic wrote:
> 
> Hi,
> 
> 	If I turn on memory debugging by "configure --enable-memdebug",
> the make process fails. So I revised several code lines in file ocfs.h
> and proc.c and generate this patch file.
> 
> 	Could you please take a look at this patch and tell me if it is
> suitable to be applied to the source tree.
Looks good. It didn't apply cleanly, but it was a one-liner to fix so I
did. In the future, can you please include patches inlined into your e-mail?
It's much easier to look at that way.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
