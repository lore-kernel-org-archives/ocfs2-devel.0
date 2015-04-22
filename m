From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 22 Apr 2015 14:45:21 -0700
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: return error while
 ocfs2_figure_merge_contig_type failing
In-Reply-To: <5536ECFA.5080400@huawei.com>
References: <5536ECFA.5080400@huawei.com>
Message-ID: <20150422144521.0c4015c2ec3ef2016fcc9279@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 22 Apr 2015 08:36:10 +0800 Xue jiufei <xuejiufei@huawei.com> wrote:

> Now function ocfs2_figure_merge_contig_type() still return CONTIG_NONE
> when some error occurs which will cause unpredictable error.
> So return error while ocfs2_figure_merge_contig_type failing.

Can you please redo this patch against current mainline?  The
conflicts are significant.

Thanks.
