From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Mon Apr 19 23:21:35 2004
Subject: [Ocfs2-devel] Patches to fix the OCFS2 bug 54, which cause
	crashin the second mount under kernel 2.6.
Message-ID: <3ACA40606221794F80A5670F0AF15F84040429F7@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I check out the newest, and test on kernel.2.4.20, it oops.
step:
mkfs.ocfs2 -L ocfs -m /ocfs -b 4 /dev/hda4
load_ocfs2
mount /dev/hda4 /ocfs -t ocfs2

Oracle Cluster FileSystem 1.9.93-BETA4 Wed Apr 21 11:38:20 CST 2004 =
(build c17df377bd4e7908fd011136b15b0d27)
ocfs2: hostname is xling
Unable to handle kernel paging request at virtual address 00001b59
 printing eip:
e08c8d43
*pde =3D 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<e08c8d43>]    Not tainted
EFLAGS: 00010212
eax: 00000000   ebx: dd2dbc74   ecx: 0000001f   edx: 00000000
esi: 00001b59   edi: dd2dbc75   ebp: dd2dbc00   esp: dcd8fc58
ds: 0018   es: 0018   ss: 0018
Process mount (pid: 1646, stackpage=3Ddcd8f000)
Stack: 00000246 dce2de60 00000000 00000000 00000200 dd2dbe00 dd2dbc00 =
e08c80b4=20
       dd2dbc00 000001f0 00001000 00000000 0000dc00 00000000 dd4b0000 =
00000000=20
       dd4b0000 dce2ddf0 dd4b0000 e08ca033 dd4b0000 0000dc00 00000000 =
00000000=20
Call Trace:    [<e08c80b4>] [<e08ca033>] [<e08b50a2>] [<c012ea05>] =
[<e08bde9a>]
  [<e08bb4ee>] [<e08bb8a5>] [<c013a50b>] [<c0139c4c>] [<e08dba04>] =
[<c013a861>]
  [<e08dba04>] [<c014cbb3>] [<c014cee0>] [<c014cd29>] [<c014d301>] =
[<c010741f>]

Code: ac aa 84 c0 75 f7 f3 aa 83 05 e8 83 8f e0 01 83 15 ec 83 8f=20
=20
> -----Original Message-----
> From: ocfs2-devel-bounces@oss.oracle.com=20
> [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Mark Fasheh
> Sent: 2004=C4=EA4=D4=C220=C8=D5 1:56
> To: Zhang, Sonic
> Cc: Ocfs2-Devel
> Subject: Re: [Ocfs2-devel] Patches to fix the OCFS2 bug 54,=20
> which cause crashin the second mount under kernel 2.6.
>=20
>=20
> On Fri, Apr 16, 2004 at 03:40:58PM +0800, Zhang, Sonic wrote:
> > Hi Mark,
> >=20
> > 	I attach a new patch for ocfs based on your suggestion to walk
> > 	around the bug in JBD before it is fixed in kernel.
> Alright Sonic, this has been committed. Thanks for catching=20
> the #if case. I re-added my comment which you removed :)
> 	--Mark
>=20
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com=20
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>=20
