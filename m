From: Massimo Cetra <ctrixk@navynet.it>
Date: Tue, 28 Dec 2010 13:06:26 +0100
Subject: [Ocfs2-devel] disk full when it shouldn't
In-Reply-To: <4D19CC38.9030703@navynet.it>
References: <4CD813D3.4080106@navynet.it>
	<4CD89E86.5010404@oracle.com>	<4CF7D578.1060201@navynet.it>
	<4CF84658.8040002@oracle.com> <4D18A327.7030709@navynet.it>
	<4D18B54E.1030203@tao.ma> <4D19CC38.9030703@navynet.it>
Message-ID: <4D19D2C2.5000601@navynet.it>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Il 28/12/2010 12:38, Massimo Cetra ha scritto:

> Oh perfect.
> Thanks, i really didn't realize that fs_discontig was a flag.
> The old tools didn't report it in the docs so i didn't find it anywhere.
>
> Now: sorry to be so annoying but i have googled without success ( i
> only found the patch that adds the following error).
>
> I cannot find nor the reason for this error:
>
> tunefs.ocfs2: Chain allocator is corrupt while opening device
> "/dev/drbd2"
>
> Nor the cause, anywhere.
> fsck doesn't seems to find the problem.
>
Ok, silly me.

fsck.ocfs2 -f device solved the problem.

Thanks for your help and i hope that the proboblem won't show again.

Massimo
