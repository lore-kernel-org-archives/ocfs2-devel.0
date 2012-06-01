From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 01 Jun 2012 09:44:25 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: clear unaligned io flag when
	dio fails
In-Reply-To: <x49fwagcuii.fsf@segfault.boston.devel.redhat.com>
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
	<1338437550-24499-2-git-send-email-junxiao.bi@oracle.com>
	<x49fwagcuii.fsf@segfault.boston.devel.redhat.com>
Message-ID: <4FC81E79.1080003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, joe.jin@oracle.com

On 05/31/2012 10:09 PM, Jeff Moyer wrote:
> Junxiao Bi <junxiao.bi@oracle.com> writes:
>
>> The unaligned io flag is set in the kiocb when an unaligned
>> dio is issued, it should be cleared even when the dio fails,
>> or it may affect the following io which are using the same
>> kiocb.
> What code is re-using kiocbs, much less re-using them without
> re-initializing them?
See my comment in another thread. aio_write seems called two times with
the same kiocb.
>
> -Jeff
