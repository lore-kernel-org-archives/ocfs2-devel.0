From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 3 Jul 2015 15:28:44 +0800
Subject: [Ocfs2-devel] [PATCH 0/4] ocfs2: add online file check feature
In-Reply-To: <1435123461-3525-1-git-send-email-ghe@suse.com>
References: <1435123461-3525-1-git-send-email-ghe@suse.com>
Message-ID: <559639AC.80602@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: mfasheh@suse.com, rgoldwyn@suse.de, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Gang,
Thank you and Goldwyn for posting this feature as well as its framework.
This patch set tries to fix inode related errors such as block no, valid
flag, generation, metaecc, etc. I think it may fit some cases but not all.
For example, valid flag not set readonly may be caused by an inode with
two entries, so I think it is not right to just reset it.
Moreover, in our environment, most readonly cases we have encountered are
related gd and entent tree/block. So do you have any consideration about
these cases?
For more details about gd and entent tree/block readonly cases, please
refer the previous mails:
https://oss.oracle.com/pipermail/ocfs2-devel/2015-April/010768.html
https://oss.oracle.com/pipermail/ocfs2-devel/2015-June/010873.html

Thanks,
Joseph

On 2015/6/24 13:24, Gang He wrote:
> When there are errors in the ocfs2 filesystem,
> they are usually accompanied by the inode number which caused the error.
> This inode number would be the input to fixing the file.
> One of these options could be considered:
> A file in the sys filesytem which would accept inode numbers.
> This could be used to communication back what has to be fixed or is fixed.
> You could write:
> $# echo "CHECK <inode>" > /sys/fs/ocfs2/devname/filecheck
> or
> $# echo "FIX <inode>" > /sys/fs/ocfs2/devname/filecheck
> 
> Gang He (4):
>   ocfs2: export ocfs2_kset for online file check
>   ocfs2: sysfile interfaces for online file check
>   ocfs2: create/remove sysfile for online file check
>   ocfs2: check/fix inode block for online file check
> 
>  fs/ocfs2/Makefile      |   3 +-
>  fs/ocfs2/filecheck.c   | 569 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/filecheck.h   |  48 +++++
>  fs/ocfs2/inode.c       | 196 ++++++++++++++++-
>  fs/ocfs2/inode.h       |   3 +
>  fs/ocfs2/ocfs2_trace.h |   2 +
>  fs/ocfs2/stackglue.c   |   3 +-
>  fs/ocfs2/stackglue.h   |   2 +
>  fs/ocfs2/super.c       |   5 +
>  9 files changed, 823 insertions(+), 8 deletions(-)
>  create mode 100644 fs/ocfs2/filecheck.c
>  create mode 100644 fs/ocfs2/filecheck.h
> 
