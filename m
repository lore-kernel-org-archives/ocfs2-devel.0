From: Xue jiufei <xuejiufei@huawei.com>
Date: Sat, 25 Apr 2015 10:15:31 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: return error while
 ocfs2_figure_merge_contig_type failing
In-Reply-To: <20150422144521.0c4015c2ec3ef2016fcc9279@linux-foundation.org>
References: <5536ECFA.5080400@huawei.com>
	<20150422144521.0c4015c2ec3ef2016fcc9279@linux-foundation.org>
Message-ID: <553AF8C3.5000700@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi andrew,
I did this against mainline linux-4.0. Do you mean that I should
do patch against linux-next tree?

Thanks.

On 2015/4/23 5:45, Andrew Morton wrote:
> On Wed, 22 Apr 2015 08:36:10 +0800 Xue jiufei <xuejiufei@huawei.com> wrote:
> 
>> Now function ocfs2_figure_merge_contig_type() still return CONTIG_NONE
>> when some error occurs which will cause unpredictable error.
>> So return error while ocfs2_figure_merge_contig_type failing.
> 
> Can you please redo this patch against current mainline?  The
> conflicts are significant.
> 
> Thanks.
> 
> 
