From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Sun May  9 03:26:42 2004
Subject: [Ocfs2-devel] buffer not mapped?
Message-ID: <3ACA40606221794F80A5670F0AF15F8404407866@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I use a script to run, so although it shows it begin to unload module,
the module is not really unloaded, it is still in memory.
The ocfs2 partition is already umounted, but the module referece show as =
"1".


>-----Original Message-----
>From: wim.coekaerts@oracle.com [mailto:wim.coekaerts@oracle.com]=20
>Sent: 2004=C4=EA5=D4=C29=C8=D5 16:17
>To: Ling, Xiaofeng
>Cc: ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] buffer not mapped?
>
>intresting, why is the nm thread still going on afer unload module ?
>
>how long after the umount do you do this ?
>
>On Sun, May 09, 2004 at 04:13:27PM +0800, Ling, Xiaofeng wrote:
>> This is what I found on svn 907
>>=20
>> 2.4.20-UP kernel
>> Steps:
>> 1.format
>> 2.mount
>> 3.read/write
>> 4.umount
>> 5.unload module
>> system show as follows, some times it may delay some seconds and=20
>> it shows in kupdated.
>> --------------------------------
>>  BUG at ll_rw_blk.c:937!
>> invalid operand: 0000
>> CPU:    0
>> EIP:    0010:[<c01c369e>]    Not tainted
>> EFLAGS: 00010246
>> eax: 00000800   ebx: 00000000   ecx: d0098a80   edx: 00000001
>> esi: 00000001   edi: 003e823f   ebp: c037dbc4   esp: cc001df4
>> ds: 0018   es: 0018   ss: 0018
>> Process ocfs2nm-0 (pid: 3273, stackpage=3Dcc001000)
>> Stack: cc000000 5d700000 000007f9 e0882e2d d4d765e0 de6f51a0 c01120dc
>> e0882e2d
>>        d4d76e20 00000800 c037dbec cc000000 00000000 00000001 0000002a
>> 00000000
>>        d0098a80 00000001 003e823f 0000002a c01c3caa c037dbc4 00000000
>> d0098a80
>> Call Trace:    [<e0882e2d>] [<c01120dc>] [<e0882e2d>] [<c01c3caa>]
>> [<c01c3d59>]
>>   [<e0891e44>] [<e0882904>] [<e08a86e9>] [<c012320b>] [<c011432b>]
>> [<c01182ba>]
>>   [<c01073d2>] [<c010578e>] [<e08a81d8>]
>>=20
>> Code: 0f 0b a9 03 99 7c 2c c0 8b 44 24 5c 0f b7 48 14 c7 44 24 20
>>  .SH
>>=20
>> ll_rw_blk.c:937 is in function __make_request()
>> as:
>> if (!buffer_mapped(bh))
>>    BUG();
>>=20
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel@oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
