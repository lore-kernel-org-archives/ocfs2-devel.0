From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 22 Apr 2015 13:42:50 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: return error while
 ocfs2_figure_merge_contig_type failing
In-Reply-To: <55372F5B.7080204@oracle.com>
References: <5536ECFA.5080400@huawei.com> <55372F5B.7080204@oracle.com>
Message-ID: <553734DA.2030604@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/4/22 13:19, Junxiao Bi wrote:
> On 04/22/2015 08:36 AM, Xue jiufei wrote:
>> > Now function ocfs2_figure_merge_contig_type() still return CONTIG_NONE
>> > when some error occurs which will cause unpredictable error.
>> > So return error while ocfs2_figure_merge_contig_type failing.
>> > 
>> > Signed-off-by: joyce.xue <xuejiufei@huawei.com>
> Looks fine.
> 
> Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
