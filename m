From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Mar 16 19:02:54 2004
Subject: [Ocfs2-devel] [Bug] mmap fail for ocfs2-1.9.9 in 2.4.20
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8403975495@PDSMSX403.ccr.corp.intel.com>
References: <3ACA40606221794F80A5670F0AF15F8403975495@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040317010249.GH20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 16, 2004 at 05:45:07PM +0800, Ling, Xiaofeng wrote:
> do the follow steps, on ext2, it is ok. but on ocfs2, it fails, 
> 
>  Test Steps:
>   1. Create a file, while it is open call unlink().
What sort of return code do you get from unlink? We don't support delete
while a file is still open, so it's not surpise that the file is still there
after all this -- we can't delete it!
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
