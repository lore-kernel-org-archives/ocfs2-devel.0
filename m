From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Jul 23 18:41:06 2004
Subject: [Ocfs2-devel] A patch to improve the metadata reading
	throughput(a gainst svn1267)
Message-ID: <3ACA40606221794F80A5670F0AF15F8404F680EA@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

=20

>-----Original Message-----
>From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
>Sent: 2004=C4=EA7=D4=C222=C8=D5 21:46
>To: Ling, Xiaofeng
>Cc: Zhang, Sonic; Fu, Michael; Yang, Elton; Ocfs2-Devel
>Subject: Re: [Ocfs2-devel] A patch to improve the metadata=20
>reading throughput(a gainst svn1267)

>Actually, the bug (which I just fixed) was that we weren't=20
>telling the other
>node to wait *on* the journal flush for a busy directory. Once=20
>I fixed it, I
>haven't had any directory contents consistency issues. See svn=20
>revision 1302
>for the patch.
Yes, I've run test, it's ok now.
So currently, when the node get READONLY message, it will=20
flush the journal and then answer it. Is my description correct?
