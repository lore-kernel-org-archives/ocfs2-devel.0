From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 20:13:13 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a tiny race case when fire
	callbacks
In-Reply-To: <521D5979.8030708@huawei.com>
References: <521C446D.8000500@huawei.com>
	<20130827135424.fbd9390e516fb7ca63d57b57@linux-foundation.org>
	<521D5979.8030708@huawei.com>
Message-ID: <20130827201313.75e7c962.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 28 Aug 2013 09:59:21 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> On 2013/8/28 4:54, Andrew Morton wrote:
> > On Tue, 27 Aug 2013 14:17:17 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
> > 
> >> Signed-off-by: Joyce <xuejiufei@huawei.com>
> >> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> > 
> > This signoff trail makes me wonder: which of you was the primary
> > author of this patch?
> > 
> > 
> Sorry for the misleading signoff trail. Joyce fixed this bug and I
> rearranged the patch and sent it.
> Please refer Joyce as the primary author, thanks.

No problems.  Damn, am I good, or what ;)

The way to handle this situation is to put an explicit From:Joyce line
at the very start of the changelog.  If that is present, the person who
receives the patch should prioritize that From: line over the one which
is present in the email envelope.
