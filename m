From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Sun May  9 04:30:33 2004
Subject: [Ocfs2-devel] buffer not mapped?
Message-ID: <3ACA40606221794F80A5670F0AF15F8404407878@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Both ocfs2nm and kupdated will trigger the bug.  kupdated will delay =
some seconds.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
# kernel BUG at ll_rw_blk.c:937!
invalid operand: 0000
CPU:    0
EIP:    0010:[<c01c369e>]    Not tainted
EFLAGS: 00010246
eax: 00000800   ebx: 00000000   ecx: db8aaba0   edx: 00000001
esi: 00000001   edi: 003e823f   ebp: c037dbc4   esp: db6abdf4
ds: 0018   es: 0018   ss: 0018
Process ocfs2nm-0 (pid: 1861, stackpage=3Ddb6ab000)
Stack: db6aa000 5d700000 000007f9 e0882e2d db8a95e0 dece80a0 c01120dc =
e0882e2d
       db8a9e20 00000800 c037dbec db6aa000 00000000 00000001 0000002a =
00000000
       db8aaba0 00000001 003e823f 0000002a c01c3caa c037dbc4 00000000 =
db8aaba0
Call Trace:    [<e0882e2d>] [<c01120dc>] [<e0882e2d>] [<c01c3caa>] =
[<c01c3d59>]
  [<e0891e44>] [<e0882904>] [<e08a86e9>] [<c01073d2>] [<c010578e>] =
[<e08a81d8>]

Code: 0f 0b a9 03 99 7c 2c c0 8b 44 24 5c 0f b7 48 14 c7 44 24 20
 kernel BUG at ll_rw_blk.c:937!
invalid operand: 0000
CPU:    0
EIP:    0010:[<c01c369e>]    Not tainted
EFLAGS: 00010246
eax: 00000800   ebx: 00000001   ecx: db6c33e0   edx: 00002000
esi: 00000001   edi: 003e823f   ebp: c037dbc4   esp: db6a9c40
ds: 0018   es: 0018   ss: 0018
Process ocfs2cmt-0 (pid: 1862, stackpage=3Ddb6a9000)
Stack: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000
       00000000 00002000 c037dbec 00000000 00000000 00000001 00001271 =
00000000
       db6c33e0 00000001 003e823f 00001271 c01c3caa c037dbc4 00000001 =
db6c33e0
Call Trace:    [<c01c3caa>] [<c01c3d59>] [<c01c3e76>] [<c016a595>] =
[<c016a7bc>]
  [<c01120dc>] [<c016bec8>] [<c016cf22>] [<e089c344>] [<e089d1de>] =
[<c01120dc>]
  [<e089ba5b>] [<e089bfa1>] [<e08bf8f0>] [<c01073d2>] [<c010578e>] =
[<e089b6dc>]

Code: 0f 0b a9 03 99 7c 2c c0 8b 44 24 5c 0f b7 48 14 c7 44 24 20
 kernel BUG at ll_rw_blk.c:937!
invalid operand: 0000
CPU:    0
EIP:    0010:[<c01c369e>]    Not tainted
EFLAGS: 00010246
eax: 00000800   ebx: 00000001   ecx: db6c3380   edx: 00002000
esi: 00000001   edi: 003e823f   ebp: c037dbc4   esp: c1779e84
ds: 0018   es: 0018   ss: 0018
Process kupdated (pid: 6, stackpage=3Dc1779000)
Stack: 00000305 00000001 dfe7eec0 df27e240 00000001 00000080 00000008 =
00000001
       00000080 00002000 c037dbec dfe7f720 00000000 00000001 00001272 =
dfe7d660
       db6c3380 00000001 003e823f 00001272 c01c3caa c037dbc4 00000001 =
db6c3380
Call Trace:    [<c01c3caa>] [<c020008c>] [<c01c3d59>] [<c013610c>] =
[<c0136190>]
  [<c0139544>] [<c0139821>] [<c0105000>] [<c0105000>] [<c010578e>] =
[<c0139750>]

Code: 0f 0b a9 03 99 7c 2c c0 8b 44 24 5c 0f b7 48 14 c7 44 24 20
>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Ling, Xiaofeng
>Sent: 2004=C4=EA5=D4=C29=C8=D5 16:27
>To: wim.coekaerts@oracle.com
>Cc: ocfs2-devel@oss.oracle.com
>Subject: RE: [Ocfs2-devel] buffer not mapped?
>
>I use a script to run, so although it shows it begin to unload module,
>the module is not really unloaded, it is still in memory.
>The ocfs2 partition is already umounted, but the module=20
>referece show as "1".
>
>
>>-----Original Message-----
>>From: wim.coekaerts@oracle.com [mailto:wim.coekaerts@oracle.com]=20
>>Sent: 2004=C4=EA5=D4=C29=C8=D5 16:17
>>To: Ling, Xiaofeng
>>Cc: ocfs2-devel@oss.oracle.com
>>Subject: Re: [Ocfs2-devel] buffer not mapped?
>>
>>intresting, why is the nm thread still going on afer unload module ?
>>
>>how long after the umount do you do this ?
>>
>>On Sun, May 09, 2004 at 04:13:27PM +0800, Ling, Xiaofeng wrote:
>>> This is what I found on svn 907
>>>=20
>>> 2.4.20-UP kernel
>>> Steps:
>>> 1.format
>>> 2.mount
>>> 3.read/write
>>> 4.umount
>>> 5.unload module
>>> system show as follows, some times it may delay some seconds and=20
>>> it shows in kupdated.
>>> --------------------------------
>>>  BUG at ll_rw_blk.c:937!
>>> invalid operand: 0000
>>> CPU:    0
>>> EIP:    0010:[<c01c369e>]    Not tainted
>>> EFLAGS: 00010246
>>> eax: 00000800   ebx: 00000000   ecx: d0098a80   edx: 00000001
>>> esi: 00000001   edi: 003e823f   ebp: c037dbc4   esp: cc001df4
>>> ds: 0018   es: 0018   ss: 0018
>>> Process ocfs2nm-0 (pid: 3273, stackpage=3Dcc001000)
>>> Stack: cc000000 5d700000 000007f9 e0882e2d d4d765e0=20
>de6f51a0 c01120dc
>>> e0882e2d
>>>        d4d76e20 00000800 c037dbec cc000000 00000000=20
>00000001 0000002a
>>> 00000000
>>>        d0098a80 00000001 003e823f 0000002a c01c3caa=20
>c037dbc4 00000000
>>> d0098a80
>>> Call Trace:    [<e0882e2d>] [<c01120dc>] [<e0882e2d>] [<c01c3caa>]
>>> [<c01c3d59>]
>>>   [<e0891e44>] [<e0882904>] [<e08a86e9>] [<c012320b>] [<c011432b>]
>>> [<c01182ba>]
>>>   [<c01073d2>] [<c010578e>] [<e08a81d8>]
>>>=20
>>> Code: 0f 0b a9 03 99 7c 2c c0 8b 44 24 5c 0f b7 48 14 c7 44 24 20
>>>  .SH
>>>=20
>>> ll_rw_blk.c:937 is in function __make_request()
>>> as:
>>> if (!buffer_mapped(bh))
>>>    BUG();
>>>=20
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel@oss.oracle.com
>>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
