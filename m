From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Sun May  9 03:13:34 2004
Subject: [Ocfs2-devel] buffer not mapped?
Message-ID: <3ACA40606221794F80A5670F0AF15F8404407863@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is what I found on svn 907

2.4.20-UP kernel
Steps:
1.format
2.mount
3.read/write
4.umount
5.unload module
system show as follows, some times it may delay some seconds and 
it shows in kupdated.
--------------------------------
 BUG at ll_rw_blk.c:937!
invalid operand: 0000
CPU:    0
EIP:    0010:[<c01c369e>]    Not tainted
EFLAGS: 00010246
eax: 00000800   ebx: 00000000   ecx: d0098a80   edx: 00000001
esi: 00000001   edi: 003e823f   ebp: c037dbc4   esp: cc001df4
ds: 0018   es: 0018   ss: 0018
Process ocfs2nm-0 (pid: 3273, stackpage=cc001000)
Stack: cc000000 5d700000 000007f9 e0882e2d d4d765e0 de6f51a0 c01120dc
e0882e2d
       d4d76e20 00000800 c037dbec cc000000 00000000 00000001 0000002a
00000000
       d0098a80 00000001 003e823f 0000002a c01c3caa c037dbc4 00000000
d0098a80
Call Trace:    [<e0882e2d>] [<c01120dc>] [<e0882e2d>] [<c01c3caa>]
[<c01c3d59>]
  [<e0891e44>] [<e0882904>] [<e08a86e9>] [<c012320b>] [<c011432b>]
[<c01182ba>]
  [<c01073d2>] [<c010578e>] [<e08a81d8>]

Code: 0f 0b a9 03 99 7c 2c c0 8b 44 24 5c 0f b7 48 14 c7 44 24 20
 .SH

ll_rw_blk.c:937 is in function __make_request()
as:
if (!buffer_mapped(bh))
   BUG();
