From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Apr 28 23:03:02 2004
Subject: [Ocfs2-devel] R867 still crash on 2.4.20
Message-ID: <3ACA40606221794F80A5670F0AF15F84043218D6@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok, I've checked out newest 882, it can mount on 2.4.20 now.


>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Mark Fasheh
>Sent: 2004=C4=EA4=D4=C229=C8=D5 5:14
>To: ling-linux
>Cc: ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] R867 still crash on 2.4.20
>
>On Wed, Apr 28, 2004 at 09:48:05AM +0800, ling-linux wrote:
>> I've checked out the newest one rivision 867, on 2.4.20,=20
>when mounting,
>> it still crashs.
>My svn tree shows the latest revision at 873...
>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> <1> Unable to handle kernel NULL point dereference at virtual address
>> 0000000.
>> Have you ever tried on 2.4 kernel?  Can you reproduce this?
>I run it on a 2.4 kernel all the time! :)
>Do you have a full stack trace? As in, what's the kernel output!
>	--Mark
>
>--
>Mark Fasheh
>Software Developer, Oracle Corp
>mark.fasheh@oracle.com
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
