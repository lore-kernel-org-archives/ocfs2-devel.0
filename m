From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 30 Jul 2013 13:51:56 +0300
Subject: [Ocfs2-devel] [PATCH v2] fs/ocfs2: use list_for_each_entry()
 instead of list_for_each()
In-Reply-To: <51F84172.50408@gmail.com>
References: <1374931429-14062-1-git-send-email-yp.fangdong@gmail.com>
	<20130729074928.GB5053@mwanda> <20130729080606.GD5053@mwanda>
	<51F84172.50408@gmail.com>
Message-ID: <20130730105156.GE29160@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dong Fang <yp.fangdong@gmail.com>
Cc: akpm@linux-foundation.org, jeff.liu@oracle.com, xuejiufei@huawei.com, shencanquan@huawei.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jul 30, 2013 at 06:42:58PM -0400, Dong Fang wrote:
> On 07/29/2013 04:06 AM, Dan Carpenter wrote:
> >Oh.  It appears that nothing changed between v1 and v2.  Only the CC
> >list.
> >
> >It's probably that the list moderation on ocfs2-devel was confusing
> >for non-native English speakers the patch submitter thought his
> >patch was dropped.
> >
> >Also mailing lists should have a white list so that I don't get the
> >message every single time.
> >
> >regards,
> >dan carpenter
> >
> hi, dan carpenter.
> 
> i am not a member of Ocfs2-devel mailing list, after i send this patch,
> it notice me "Your message to Ocfs2-devel awaits moderator approval".
> i subscribe this mailing list just now, do you think i need to resend
> this patch to Ocfs2-devel ?
> 
> thx very much.

No.  You don't need to subscribe or resend.  Your original patch
will be approved and go through after a small delay.

regards,
dan carpenter
