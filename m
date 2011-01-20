From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 20 Jan 2011 11:30:55 -0800
Subject: [Ocfs2-devel] useless tools - tunefs.ocfs2,fsck.ocfs2
In-Reply-To: <4D383BDC.4050400@mp.pl>
References: <4D383BDC.4050400@mp.pl>
Message-ID: <4D388D6F.8070609@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Please file a bugzilla on the nometaecc issue.

On 01/20/2011 05:42 AM, Pawel wrote:
>    One of ocfs2 filesystem has some errors.
> 1. fsck.ocfs2  informs me that :    "I/O error on channel while reading
> .. " It was NOT TRUE - I was able to read and write  entire storage over
> the network multiple times.
> 2. becouse of CRC  errors and suggestion to disable metaecc I run
> tunefs.ocfs2 --fs-features=nometaecc /dev/xxx
> funefs allocate 9,89 GB of virtual memory and 95% of phisical memory
> (4GB). After 4 hours process has been killed - because of out of memory.
>
> I have to recreate new filesystem and restore data from backup.
>
> I try to use tools in version 1.4  and 1.6 (newest)
> Filesystem is quite small 250GB and less than 10 000 files, exported by aoe.
> Additionally  on the new clean FS -  running tunefs.ocfs2
> --fs-features=nosparse behave in the same way
>
> It seems that the tools are not "perfect"
> Could   anyone confirm?
>
> Pawel
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
