From: Chen, Yukun <yukun.chen@intel.com>
Date: Tue Jun 15 00:18:05 2004
Subject: [Ocfs2-devel] File missing on another node
Message-ID: <B44D37711ED29844BEA67908EAF36F0315E6C0@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yeah, after unmount and remount I can see all the 2000 files. It might =
be some broken on caching.=20

Thanx.

Aaron

-----Original Message-----
From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
Sent: 2004=C4=EA6=D4=C215=C8=D5 5:14
To: Chen, Yukun
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] File missing on another node

On Mon, Jun 14, 2004 at 02:17:10PM +0800, Chen, Yukun wrote:
> Hi all
>=20
>    I meet a consistency issue. Steps to duplicate:
If you unmount all volumes, then remount one of them, how many files do =
you
see? Hopefully you'll see all 2000 in which case, something in our =
caching
might be broken (i've seen similar things myself, but have been too busy
with other code to track it down).
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
