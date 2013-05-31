From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 31 May 2013 15:25:35 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: should not use le32_add_cpu to
 set ocfs2_dinode i_flags
In-Reply-To: <51A6DA6A.5060301@huawei.com>
References: <51A6DA6A.5060301@huawei.com>
Message-ID: <20130531152535.a832b5dd6435595798ffb73d@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 30 May 2013 12:49:46 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> If we use le32_add_cpu to set ocfs2_dinode i_flags, it may lead to the
> corresponding flag corrupted. So we should change it to bitwise and/or
> operation.
> 

The usual question: what is the end-user impact of the bug which was
just fixed?

For the usual reason: so I and others can decide which kernel versions
need the fix.

Thanks.
