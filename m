From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Nov 2010 22:22:26 +0800
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: Remove EXIT from masklog.
In-Reply-To: <20101110094545.GD31158@mail.oracle.com>
References: <4CDA08B6.2070002@oracle.com>
	<1289357543-2538-3-git-send-email-tao.ma@oracle.com>
	<20101110094545.GD31158@mail.oracle.com>
Message-ID: <4CDAAAA2.1060501@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, Nov 10, 2010 at 10:52:21AM +0800, Tao Ma wrote:
>   
>> mlog_exit is used to record the exit status of a function.
>> But because it is added in so many functions, if we enable it,
>> the system logs get filled up quickly and cause too much I/O.
>> So actually no one can open it for a production system or even
>> for a test.
>>
>> This patch just try to remove it. So in case of report error, a
>> mlog_errno is used while if all the errors in the function are
>> properly reported, mlog_exit is just removed.
>> for mlog_exit:
>> 1. if all the error paths already use mlog_errno, it is just removed.
>>    Otherwise, it will be replaced by mlog_errno.
>> 2. if it is used to print some return value, it is replaced with
>>    mlog(0,...).
>> mlog_exit_ptr is changed to mlog(0.
>>     
>
> 	This one is great, except I would only select certain exit
> return codes to log.  Most of them aren't very interesting.
>   
Actually I have checked all of them to make sure that only the error 
code is prompted.
But maybe I may miss something, so let us wait and see.

Regards,
Tao
