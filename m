From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Apr  8 21:52:38 2004
Subject: [Ocfs2-devel] ltp test result for ocfs2 for 2.4
Message-ID: <3ACA40606221794F80A5670F0AF15F8403E4332E@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: ocfs2-devel@oss.oracle.com

This is the test result on 2.4.20 kernel, it is much like the result on 2.6.3 kernel.
Both hang on rmdir03.
Anther result is when on a SMP kernel of 2.4.20 on UP machine, the test crashs on "create" test.

> -----Original Message-----
> From: ocfs2-devel-bounces@oss.oracle.com 
> [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of 
> Ling, Xiaofeng
> Sent: 2004��4��8�� 16:35
> To: Ocfs2-Devel
> Subject: [Ocfs2-devel] ltp test result for ocfs2 for 2.6
> 
> 
> Hi
>        I tried to run the LTP test cases that related with 
> system call of file system, The result is attached. 
>      comparing with ext3 file system, the test on ocfs stoped 
> on rmmdir03  and 
> there is also many fail cases.
> 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-2.4.zip
Type: application/x-zip-compressed
Size: 15752 bytes
Desc: ocfs2-2.4.zip
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040409/2a1cfe92/ocfs2-2.4.bin
