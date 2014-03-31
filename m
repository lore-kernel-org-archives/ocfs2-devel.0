From: Wengang <wen.gang.wang@oracle.com>
Date: Mon, 31 Mar 2014 09:39:44 +0800
Subject: [Ocfs2-devel] [patch 2/8] ocfs2: flock: drop cross-node lock
 when failed locally
In-Reply-To: <20140331013047.GC4488@wotan.suse.de>
References: <20140319211000.A597C31C25A@corp2gmr1-1.hot.corp.google.com>
	<20140331013047.GC4488@wotan.suse.de>
Message-ID: <5338C760.4090409@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

I find it by code review.

thanks,
wengang

? 2014?03?31? 09:30, Mark Fasheh ??:
> On Wed, Mar 19, 2014 at 02:10:00PM -0700, Andrew Morton wrote:
>> From: Wengang Wang <wen.gang.wang@oracle.com>
>> Subject: ocfs2: flock: drop cross-node lock when failed locally
>>
>> ocfs2_do_flock() calls ocfs2_file_lock() to get the cross-node clock and
>> then call flock_lock_file_wait() to compete with local processes.  In case
>> flock_lock_file_wait() failed, say -ENOMEM, clean up work is not done.
>> This patch adds the cleanup --drop the cross-node lock which was just
>> granted.
> Out of curiousity was this a bug someone hit, or did you catch this
> via code review.
>
> Reviewed-by: Mark Fasheh <mfasheh@suse.de>
> 	--Mark
>
> --
> Mark Fasheh
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
