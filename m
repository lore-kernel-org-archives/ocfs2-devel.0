From: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 2 May 2015 21:13:19 -0700
Subject: [Ocfs2-devel] [PATCH RESEND] ocfs2: use retval instead of
 status for checking error
In-Reply-To: <CAHb8M2Ck9x25O3JMQm0nqJriWx6QMb8DyO=O7Asw3JYk8kBNuw@mail.gmail.com>
References: <20150424014545.GA9252@devel.8.8.4.4>
	<CAHb8M2Ck9x25O3JMQm0nqJriWx6QMb8DyO=O7Asw3JYk8kBNuw@mail.gmail.com>
Message-ID: <20150502211319.0d406048.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, mfasheh@suse.com, linux-kernel <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>, Joseph Qi <joseph.qi@huawei.com>

On Sun, 3 May 2015 12:02:39 +0900 DaeSeok Youn <daeseok.youn@gmail.com> wrote:

> 2015-04-24 10:45 GMT+09:00 Daeseok Youn <daeseok.youn@gmail.com>:
> > The use of 'status' in __ocfs2_add_entry() can return wrong
> > value. Some functions' return value in __ocfs2_add_entry(),
> > i.e ocfs2_journal_access_di() is saved to 'status'.
> > But 'status' is not used in 'bail' label for returning result
> > of __ocfs2_add_entry().
> >
> > So use retval instead of status.
> >
> > Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> > Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> > ---
> Andrew.
> 
> How is it going this patch, please check for me.

I merged this over a week ago and it is in linux-next:
http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-retval-instead-of-status-for-checking-error.patch

You were sent a commit email at the time.
