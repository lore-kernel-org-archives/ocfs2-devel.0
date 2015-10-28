From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed, 28 Oct 2015 09:34:58 -0700
Subject: [Ocfs2-devel] [PATCH v2 0/4] Add online file check feature
In-Reply-To: <1446013561-22121-1-git-send-email-ghe@suse.com>
References: <1446013561-22121-1-git-send-email-ghe@suse.com>
Message-ID: <5630F932.8050701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, mfasheh@suse.com, rgoldwyn@suse.de
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Gang,

thank you for implementing this. I would like to understand this better 
on where and how it helps ... would you mind sharing couple 
examples(real scenarios).

Thanks,
--Srini


On 10/27/2015 11:25 PM, Gang He wrote:
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
> Compare with first version, I use strncasecmp instead of double strncmp
> functions. Second, update the source file contribution vendor.
>
> Gang He (4):
>    ocfs2: export ocfs2_kset for online file check
>    ocfs2: sysfile interfaces for online file check
>    ocfs2: create/remove sysfile for online file check
>    ocfs2: check/fix inode block for online file check
>
>   fs/ocfs2/Makefile      |   3 +-
>   fs/ocfs2/filecheck.c   | 566 +++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/ocfs2/filecheck.h   |  48 +++++
>   fs/ocfs2/inode.c       | 196 ++++++++++++++++-
>   fs/ocfs2/inode.h       |   3 +
>   fs/ocfs2/ocfs2_trace.h |   2 +
>   fs/ocfs2/stackglue.c   |   3 +-
>   fs/ocfs2/stackglue.h   |   2 +
>   fs/ocfs2/super.c       |   5 +
>   9 files changed, 820 insertions(+), 8 deletions(-)
>   create mode 100644 fs/ocfs2/filecheck.c
>   create mode 100644 fs/ocfs2/filecheck.h
>
