From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 8 Aug 2019 09:08:46 +0800
Subject: [Ocfs2-devel] [PATCH][ocfs2-next] ocfs2: ensure ret is set to
 zero before returning
In-Reply-To: <bf4d059a-94fc-d8cf-78c7-8606644185a5@canonical.com>
References: <20190807121929.28918-1-colin.king@canonical.com>
	<fb3d7441-93ea-b619-52fc-00da950c9201@gmail.com>
	<bf4d059a-94fc-d8cf-78c7-8606644185a5@canonical.com>
Message-ID: <0cee7ca9-8704-171a-ec82-ee6c16e3381b@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin Ian King <colin.king@canonical.com>, Joseph Qi <jiangqi903@gmail.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org



On 19/8/7 20:42, Colin Ian King wrote:
> On 07/08/2019 13:35, Joseph Qi wrote:
>>
>>
>> On 19/8/7 20:19, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> A previous commit introduced a regression where variable ret was
>>> originally being set from the return from a call to function
>>> dlm_create_debugfs_subroot and this set was removed. Currently
>>> ret is now uninitialized if no alloction errors are found which
>>> may end up with a bogus check on ret < 0 on the 'leave:' return
>>> path.  Fix this by setting ret to zero on a successful execution
>>> path.
>>
>> Good catch.
>> Or shall we just initialize 'ret' at first?
> 
> Initialized ret first may not catch subsequent coding errors where error
> returns paths have not initialized ret, so my preference is when it is
> required and not before.
> 
Okay, looks good to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

>>
>>>
>>> Addresses-Coverity: ("Uninitialzed scalar variable")
> 
> Can this be fixed up when applied rather sending a V2?
>>
Currently ocfs2 patches are maintained in Andrew's mm tree.
So it depends on Andrew.

Thanks,
Joseph
