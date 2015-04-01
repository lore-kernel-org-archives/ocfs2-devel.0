From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 31 Mar 2015 19:19:09 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if the ocfs2 lock resource
 be initialized before calling ocfs2_dlm_lock
In-Reply-To: <551B3F41.6020501@huawei.com>
References: <5518C165.10106@huawei.com>
	<20150331151348.2887ede16683257826833e04@linux-foundation.org>
	<551B3F41.6020501@huawei.com>
Message-ID: <20150331191909.d5445d66.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 1 Apr 2015 08:43:45 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: ocfs2: make mlog_errno return the errno
> > 
> > ocfs2 does
> > 
> > 	mlog_errno(v);
> > 	return v;
> > 
> > in many places.  Change mlog_errno() so we can do
> > 
> > 	return mlog_errno(v);
> > 
> I don't think this is fit for all.
> In many places it should do cleanup rather than just return the error
> code.

There are about 50 sites which can use this.
