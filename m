From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Aug 19 21:41:56 2004
Subject: [Ocfs2-devel] LTP system call test all pass!
Message-ID: <3ACA40606221794F80A5670F0AF15F84053D9991@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

=20

>-----Original Message-----
>From: joel.becker@oracle.com [mailto:joel.becker@oracle.com]=20
>Sent: 2004=C4=EA8=D4=C220=C8=D5 10:31
>To: Ling, Xiaofeng; ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] LTP system call test all pass!
>
>On Thu, Aug 19, 2004 at 07:19:31PM -0700, Joel Becker wrote:
>> On Fri, Aug 20, 2004 at 10:16:33AM +0800, Ling, Xiaofeng wrote:
>> > Does ocfs support loop device now?
>> > LSB test need loop device and maybe  a small loop device. =20
>>=20
>> 	"Why wouldn't it", is the question, I guess.  What was=20
>the problem
>> before?  Worth trying out, it might just work.
>
>	I just created a file on ocfs2, ran mkfs.ext3, and mounted it
>with loopback ("mount -o loop /ocfs2/loopme /mnt/tmp").  It=20
>worked fine.
>If you have any problems, let us know.
>
In fact, what I mean is LSB is trying to use loop device to test the =
file system API so if ocfs can be make on the
loop device, then the API can be tested.
I've tried before, the format is not successful for the raw device, seem =
now it can.
