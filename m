From: Massimo Cetra <ctrixk@navynet.it>
Date: Thu, 13 Jan 2011 20:19:39 +0100
Subject: [Ocfs2-devel] Problems with fsck
In-Reply-To: <4D2DD3E0.7080509@oracle.com>
References: <4D2DCCF1.4080303@navynet.it> <4D2DD3E0.7080509@oracle.com>
Message-ID: <4D2F504B.7010404@navynet.it>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/01/2011 17:16, Sunil Mushran wrote:
> fsck is failing because it is encountering block(s) with incorrect
> checksums. An easy solution is to disable checksums and rerun
> fsck. Checksums can be renabled later.
>
Uh. I noticed that CRC32 errors from the kernel but i didn't 
rearealizedlly  that it was related to the problem.
fsck reporting I/O errors was driving me to something more serious 
(broken disks) but obviously i didn't find anything about it on the 
controller.

I would suggest to modify that error about I/O indicating some causes of 
the problem

I would also ask how to disable checksums as i don't find it in the docs 
(hope this informations will help others).

> The problem started with the segfault when activating indexed-dirs.
> Do you have the coredump?
No sorry, i wish i had.

Max
