From: Eric Ren <zren@suse.com>
Date: Tue, 11 Oct 2016 11:30:12 +0800
Subject: [Ocfs2-devel] [Question] deadlock on chmod when running
 discontigous block group multiple node testing
In-Reply-To: <a753e9d1-2f32-7675-7e22-1a4fdc8746a3@oracle.com>
References: <66f1a48d-21e2-aeed-5d79-2ad2576760f5@suse.com>
	<a753e9d1-2f32-7675-7e22-1a4fdc8746a3@oracle.com>
Message-ID: <69634c77-46d9-d56b-8d6c-b3137675afbb@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 10/11/2016 10:58 AM, Junxiao Bi wrote:
>> Do you think this issue can be fixed by your patches?
> Looks not. Those two patches are to fix recursive locking deadlock. But
> from above call trace, there is no recursive lock.
OK, thanks a lot!

Eric
>
> Thanks,
> Junxiao.
>> I will try your patches later, but I am little worried the possibility
>> of reproduction may not be 100%.
>> So ask you to confirm;-)
>>
>> Eric
>
