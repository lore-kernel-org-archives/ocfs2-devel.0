From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Apr 26 16:13:45 2004
Subject: [Ocfs2-devel] Patch to fix OCFS2 bug 58 "system halt when
	unmountavolumeimmediately after read/write"
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65E82@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65E82@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040426211056.GU10471@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 26, 2004 at 05:19:06PM +0800, Zhang, Sonic wrote:
> Hi,
> 
> 	I changed a little to my original patch. I also send signal in
> 	ocfs_rename() and ocfs_unlink(). 
Can you explain why we need this?

> ... This new patch is against the
> 	latest svn version 867. I have run xiaofeng's test suite many times
> 	and got no problems by now.
Ok, if it's for a bug that you're hitting on shutdown, could you explain
also what exactly that bug is?

Thakns for all the work debugging this.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
