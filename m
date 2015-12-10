From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 Dec 2015 14:02:40 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix SGID not inherited issue
In-Reply-To: <566791C1.6050407@oracle.com>
References: <1449461346-21864-1-git-send-email-junxiao.bi@oracle.com>
	<20151208132215.6efe510a3868e57c9ca2f87a@linux-foundation.org>
	<566791C1.6050407@oracle.com>
Message-ID: <20151210140240.e38f0f569e4ea7d1911b1055@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 9 Dec 2015 10:28:17 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Hi Andrew,
> 
> On 12/09/2015 05:22 AM, Andrew Morton wrote:
> > On Mon,  7 Dec 2015 12:09:06 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
> > 
> >> commit 8f1eb48758aa ("ocfs2: fix umask ignored issue") introduced an issue,
> >> SGID of sub dir was not inherited from its parents dir. It is because SGID
> >> is set into "inode->i_mode" in ocfs2_get_init_inode(), but is overwritten
> >> by "mode" which don't have SGID set later.
> >>
> >> Fixes: 8f1eb48758aa ("ocfs2: fix umask ignored issue")
> >> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> >> Cc: <stable@vger.kernel.org>
> > 
> > 8f1eb48758aa is only in 4.4-rcX so I removed the cc:stable.
> If 8f1eb48758aa is merged into stable, but this patch not, there will be
> a regression issue in stable branch?

Ah, yes, right you are, thanks.
