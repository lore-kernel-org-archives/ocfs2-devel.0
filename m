From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Fri, 27 Aug 2010 16:07:06 -0500
Subject: [Ocfs2-devel] crash while creating a lot of files - jbd2
 assertion failure
In-Reply-To: <4C77305F.5030609@oracle.com>
References: <AANLkTi=qkpTn7+zvbvnjgNoXmva1sKkv5TB7Wur=R-Gb@mail.gmail.com>
	<4C77305F.5030609@oracle.com>
Message-ID: <AANLkTikKAAFGDcRkJx+oJ=pHp-O_oSydwETe=Gy_7e+g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tristan,

On Thu, Aug 26, 2010 at 10:26 PM, tristan <tristan.ye@oracle.com> wrote:
> Goldwyn Rodrigues wrote:
>>
>> Hi,
>>
>> ocfs2 crashes most of the times when I try to create a lot of files on
>> the filesystem. The details are:
>>
>> Arch: i686 (2 processors)
>> Kernel version: 2.6.35.3
>> Script to reproduce:
>> for i in `seq 1 1048576`; do echo $i > f.$i; done
>> Reproducible: most of the times
>> fs-features: indexed-dirs,local,noxattr
>
> Hi Goldwyn,
>
> Could you please verify if the issue could be solved by my recent patch:
>
> [PATCH 1/1] Ocfs2: Add missing ocfs2_journal_acces_*() for couple of funcs
> in dir.c
>
>

Yes, the patch works fine and fixes the issue. Thanks for the quick fix.

-- 
Goldwyn
