From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Thu Mar 11 20:58:34 2004
Subject: [Ocfs2-devel] FW: A patch to remove compile warnings and errors
	if enable memory debugging(OCFS_LINUX_MEM_DEBUG).
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E5A30DF@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

	OK, I will try to send the patch inline. But, I have to fix the =
auto-wrap problem in my outlook email client first. Who know how to =
disable auto-wrap in outlook?

	Thanks.

*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
Sent: 2004=C4=EA3=D4=C212=C8=D5 10:10
To: Zhang, Sonic
Cc: Ocfs2-Devel
Subject: Re: [Ocfs2-devel] FW: A patch to remove compile warnings and =
errors if enable memory debugging(OCFS_LINUX_MEM_DEBUG).

On Thu, Mar 11, 2004 at 03:59:06PM +0800, Zhang, Sonic wrote:
>=20
> Hi,
>=20
> 	If I turn on memory debugging by "configure --enable-memdebug",
> the make process fails. So I revised several code lines in file ocfs.h
> and proc.c and generate this patch file.
>=20
> 	Could you please take a look at this patch and tell me if it is
> suitable to be applied to the source tree.
Looks good. It didn't apply cleanly, but it was a one-liner to fix so I
did. In the future, can you please include patches inlined into your =
e-mail?
It's much easier to look at that way.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
