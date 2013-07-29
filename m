From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 29 Jul 2013 10:49:28 +0300
Subject: [Ocfs2-devel] [PATCH v2] fs/ocfs2: use list_for_each_entry()
 instead of list_for_each()
In-Reply-To: <1374931429-14062-1-git-send-email-yp.fangdong@gmail.com>
References: <1374931429-14062-1-git-send-email-yp.fangdong@gmail.com>
Message-ID: <20130729074928.GB5053@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dong Fang <yp.fangdong@gmail.com>
Cc: mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org, jeff.liu@oracle.com, viro@zeniv.linux.org.uk, sunil.mushran@gmail.com, tim.gardner@canonical.com, xuejiufei@huawei.com, shencanquan@huawei.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sat, Jul 27, 2013 at 09:23:49AM -0400, Dong Fang wrote:
> 
> Signed-off-by: Dong Fang <yp.fangdong@gmail.com>
> ---

Put a note here what changed between v1 and v2.  Also no one replied
to the v1 patch to say that it was obsolete.  I will take care of it
this time but please handle it yourself in the future.

Anyway, please reply to let us know what changed between v1 and v2.


>  fs/ocfs2/cluster/heartbeat.c |   14 +++++---------
>  fs/ocfs2/dlm/dlmast.c        |    8 +++-----
>  fs/ocfs2/dlm/dlmcommon.h     |    4 +---
>  fs/ocfs2/dlm/dlmconvert.c    |   11 +++--------
>  fs/ocfs2/dlm/dlmdebug.c      |   15 ++++-----------
>  fs/ocfs2/dlm/dlmdomain.c     |   20 +++++---------------
>  fs/ocfs2/dlm/dlmlock.c       |    9 ++-------
>  fs/ocfs2/dlm/dlmmaster.c     |   17 ++++-------------
>  fs/ocfs2/dlm/dlmthread.c     |   19 +++++--------------
>  fs/ocfs2/dlm/dlmunlock.c     |    4 +---
>  10 files changed, 33 insertions(+), 88 deletions(-)
> 

regards,
dan carpenter
