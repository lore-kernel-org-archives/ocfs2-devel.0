From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 29 Mar 2017 14:34:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2hb: revert hb threshold to keep
	compatible
In-Reply-To: <20170328203158.6ae7ff0e6bbff6f5bceb9a19@linux-foundation.org>
References: <1490665245-15374-1-git-send-email-junxiao.bi@oracle.com>
	<20170328153146.da60162a5a5d02c34cdd848e@linux-foundation.org>
	<903c2745-edff-09d3-1db7-55996ba87d53@oracle.com>
	<20170328203158.6ae7ff0e6bbff6f5bceb9a19@linux-foundation.org>
Message-ID: <a8f7b220-5303-1f34-8efa-234160504794@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

On 03/29/2017 11:31 AM, Andrew Morton wrote:
> On Wed, 29 Mar 2017 09:07:08 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
> 
>> On 03/29/2017 06:31 AM, Andrew Morton wrote:
>>> On Tue, 28 Mar 2017 09:40:45 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
>>>
>>>> Configfs is the interface for ocfs2-tools to set configure to
>>>> kernel. Change heartbeat dead threshold name in configfs will
>>>> cause compatible issue, so revert it.
>>>>
>>>> Fixes: 45b997737a80 ("ocfs2/cluster: use per-attribute show and store methods")
>>>
>>> I don't get it.  45b997737a80 was merged nearly two years ago, so isn't
>>> it a bit late to fix compatibility issues?
>>>
>> This compatibility will not cause ocfs2 down, just some configure (hb
>> dead threshold) lose effect. If someone want to use the new kernel, they
>> should apply this fix.
> 
> Well could someone please send a better changelog?  One which carefully
> describes the present behaviour, what is wrong with it and how the
> patch fixes it?

A new one, please help review.

Configfs is the interface for ocfs2-tools to set configure to
kernel and there
$configfs_dir/cluster/$clustername/heartbeat/dead_threshold is the one
used to configure heartbeat dead threshold. Kernel has a default value
of it but user can set O2CB_HEARTBEAT_THRESHOLD in /etc/sysconfig/o2cb
to override it.
Commit 45b997737a80 ("ocfs2/cluster: use per-attribute show and store
methods") changed heartbeat dead threshold name while ocfs2-tools not,
so ocfs2-tools won't set this configure and default value is always
used. So revert it.

Thanks,
Junxiao.

> 
> One reason for doing this is to permit effecitive patch review.
> 
> Another reason is to permit others to decide whether the patch should
> be backported into -stable kernels.
> 
> Yet another reason is so that maintainers of other kernels can
> determine whether this patch will fix behaviour which their users are
> reporting.
> 
> Thanks.
> 
