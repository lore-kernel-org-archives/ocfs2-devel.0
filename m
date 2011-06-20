From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 20 Jun 2011 09:32:50 -0700
Subject: [Ocfs2-devel] How can ecc be corrected?
In-Reply-To: <BANLkTin7CFffpzcMLtzXbXkwxP8KkgwUzQ@mail.gmail.com>
References: <BANLkTi=SHS1W7umXmY9egUrGK0SWeOjQ7w@mail.gmail.com>	<4DFB8694.6080303@oracle.com>	<BANLkTi=Ar_iixpHfu+O53optr37=oj2q+Q@mail.gmail.com>	<4DFBA79C.8060405@oracle.com>
	<BANLkTin7CFffpzcMLtzXbXkwxP8KkgwUzQ@mail.gmail.com>
Message-ID: <4DFF7632.3040108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/18/2011 09:13 PM, Goldwyn Rodrigues wrote:
> I suppose it is still in the correctable limits. By failing I meant a
> "stat" output in debugfs gives a "FAILED CHECKSUM" error.
>
> On reading more I found we are not writing the superblock anywhere in
> kernel module and perhaps the reason the block_check values remain
> unchanged. PCMIIW.
>
> This brings me to the next question: Why don't we use mnt_count? The
> fact that it is distributed makes life complicated, but still...

Yeah.. Mark had added the failed checksum check in debugfs.
Without that we were running blind. Hard to compute it in the head. ;)

mnt count was originally added in extN to force fsck after N mounts.
That has never worked for us because fsck is a offline process. And it
could take time. It is prudent to let users control when it's run.

FWIW, extN has also changed its default behaviour to ignore mnt count.
