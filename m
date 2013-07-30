From: Dong Fang <yp.fangdong@gmail.com>
Date: Tue, 30 Jul 2013 12:00:50 -0400
Subject: [Ocfs2-devel] [PATCH v2] fs/ocfs2: use list_for_each_entry()
	instead of list_for_each()
In-Reply-To: <20130729080606.GD5053@mwanda>
References: <1374931429-14062-1-git-send-email-yp.fangdong@gmail.com>
	<20130729074928.GB5053@mwanda> <20130729080606.GD5053@mwanda>
Message-ID: <51F7E332.5010708@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org, jeff.liu@oracle.com, viro@zeniv.linux.org.uk, sunil.mushran@gmail.com, tim.gardner@canonical.com, xuejiufei@huawei.com, shencanquan@huawei.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 07/29/2013 04:06 AM, Dan Carpenter wrote:
> Oh.  It appears that nothing changed between v1 and v2.  Only the CC
> list.
>
> It's probably that the list moderation on ocfs2-devel was confusing
> for non-native English speakers the patch submitter thought his
> patch was dropped.
>
> Also mailing lists should have a white list so that I don't get the
> message every single time.
>
> regards,
> dan carpenter
>
sorry about that, i just think i shoud send this patch to linux-fsdevel,
but ./get_maintainer.pl didn't tell me
