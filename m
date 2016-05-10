From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 10 May 2016 14:10:43 +0800
Subject: [Ocfs2-devel] ocfs2: fix recursive locking deadlock
In-Reply-To: <20160509225804.e4ba0fb054acb1d92fe3db44@linux-foundation.org>
References: <1462856023-13801-1-git-send-email-junxiao.bi@oracle.com>
	<20160509225804.e4ba0fb054acb1d92fe3db44@linux-foundation.org>
Message-ID: <57317B63.8060806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/10/2016 01:58 PM, Andrew Morton wrote:
> On Tue, 10 May 2016 12:53:41 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
> 
>> These two patches is to fix recursive locking deadlock issues. As we
>> talked with Mark before, recursive locking is not allowed in ocfs2,
>> so these two patches fixes the deadlock issue with reverting back
>> patches to avoid recursive locking. Please review.
> 
> 2-3 years old so I guess it isn't a huge issue.  Did you consider
> backporting into -stable kernels?
> 
We'd better do that. I reproduced every one in my test env.

Thanks,
Junxiao.
