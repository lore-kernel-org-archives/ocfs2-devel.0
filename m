From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Apr 29 12:34:24 2004
Subject: [Ocfs2-devel] What's your opinion on the patch to fix bug 58 for
	kernel 2.6 porting?
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65E90@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65E90@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040429173135.GC9043@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Well, to be perfectly honest I don't think this is the right solution.
Instead of peppering the code with signal stuff, why not try to figure out
what the timing issue is (it seems that the umount thread should wait on
pending operations) and fix it that way?
	--Mark

On Thu, Apr 29, 2004 at 10:10:56AM +0800, Zhang, Sonic wrote:
> Hi Mark,
> 
> 	Do you have any opinion on the patch to fix bug 58 for kernel
> 2.6 porting?
> 	Could you add the patch into the source tree? 
> 
> 	Thank you.
> 
> 
> *********************************************
> Sonic Zhang
> Software Engineer
> Intel China Software Lab
> Tel: (086)021-52574545-1667
> iNet: 752-1667
> ********************************************* 
> 


> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
