From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Apr  8 10:09:20 2004
Subject: [Ocfs2-devel] Fail to mount an OCFS volume for the second time
	under kernel 2.6.
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65E51@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65E51@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040408150912.GN10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 07, 2004 at 05:24:46PM +0800, Zhang, Sonic wrote:
> Hi,
> 
> 	After check out the latest svn source, I found I fail to mount
> an OCFS volume for the second time under kernel 2.6. The system will
> halt if I do so. But, I remember I did it successfully in the former
> version. I submitted it into the bugzilla.
>
> See following details.
> 
> Steps:
> 1. create ocfs volume.
> 2. mount this volume.
> 3. umount this volume.
> 4. mount this volume again.
> 
> Results:
> System halt with error information.
> JBD: no valid journal superblock found
> (1342) ERROR: status=-22, fs/ocfs2/osb.c, 407
> (1342) ERROR: status=-22, fs/ocfs2/super.c, 1032
So does this happen every time, even on a fresh file system? I wonder if the
1st mount of that filesystem was somehow interrupted...
	--Mark  (hoping we didn't break the 2.6 stuff somehow :)


--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
