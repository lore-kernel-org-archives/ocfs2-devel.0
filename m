From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 15 Sep 2011 09:49:26 +0800
Subject: [Ocfs2-devel] [PATCH] Wake up down-convert thread when clearing
 OCFS2_LOCK_UPCONVERT_FINISHING from ocfs2_lock_res.l_flags
In-Reply-To: <4E7157C8.8090606@oracle.com>
References: <201109130913.p8D9DehZ013352@acsmt357.oracle.com>
	<4E7157C8.8090606@oracle.com>
Message-ID: <20110915014926.GA9488@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-09-14 18:41, Sunil Mushran wrote:
> Instead of passing osb, just wakeup_dc from the 5 locations.
> Cleaner that-a-way.

Yes, that's cool. I will post shortly.

thanks,
wengang.

> 
> On 09/13/2011 02:13 AM, Wengang Wang wrote:
> >In down convert thread, when the ocfs2_lock_res is in OCFS2_LOCK_UPCONVERT_FINISHING
> >state, it is requeued for next run of ocfs2_downconvert_thread_do_work(). If not
> >waked up, the DC thread just sleep there without even there are ocfs2_lock_res' left
> >in the list.
> >
> >So when clearing the OCFS2_LOCK_UPCONVERT_FINISHING flag, we need also to wake up dc
> >thread accordingly.
> >
