From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Mar 17 04:05:57 2004
Subject: [Ocfs2-devel] [Bug] mmap fail for ocfs2-1.9.9 in 2.4.20
Message-ID: <3ACA40606221794F80A5670F0AF15F84039757B5@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: ocfs2-devel@oss.oracle.com

The test is from Open Posix Test Suite. http://openposix.sf.net
attach is the failed case.
mount /tmp with ocfs2 and run the case will fail.

> -----Original Message-----
> From: Mark Fasheh [mailto:mark.fasheh@oracle.com] 
> Sent: 2004��3��17�� 9:03
> To: Ling, Xiaofeng
> Cc: ocfs2-devel@oss.oracle.com
> Subject: Re: [Ocfs2-devel] [Bug] mmap fail for ocfs2-1.9.9 in 2.4.20
> 
> 
> On Tue, Mar 16, 2004 at 05:45:07PM +0800, Ling, Xiaofeng wrote:
> > do the follow steps, on ext2, it is ok. but on ocfs2, it fails,
> > 
> >  Test Steps:
> >   1. Create a file, while it is open call unlink().
> What sort of return code do you get from unlink? We don't 
> support delete while a file is still open, so it's not 
> surpise that the file is still there after all this -- we 
> can't delete it!
> 	--Mark
> 
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com
> 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 12-1.c
Type: application/octet-stream
Size: 3204 bytes
Desc: 12-1.c
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040317/bfc5cefb/12-1.obj
