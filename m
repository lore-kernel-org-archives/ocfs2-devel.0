From: ryding <ryan.ding@oracle.com>
Date: Tue, 15 Sep 2015 10:34:36 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fill-in the unused portion of the
 block with zeros by dio_zero_block()
In-Reply-To: <20150914152216.f0eac2d700ab39911d0aedf3@linux-foundation.org>
References: <55EF9184.5090007@huawei.com>	<55F0E287.1020701@oracle.com>
	<20150914152216.f0eac2d700ab39911d0aedf3@linux-foundation.org>
Message-ID: <55F783BC.5080402@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 09/15/2015 06:22 AM, Andrew Morton wrote:
> On Thu, 10 Sep 2015 09:53:11 +0800 ryding <ryan.ding@oracle.com> wrote:
>
>> Hi Yiwen,
>>
>> I'm working on this issue. The patch will be send out soon. And the
>> issue that do not support file hole will be fixed too. I have proved it
>> can pass all ltp-aiodio test cases, and has better performance. ;-)
> Yes, your "ocfs2: fill in the unused portion of the block with zeros by
> dio_zero_block()" conflicts with this patch a little.
>
> Does your patchset need alteration to fix this bug?
My patchset "ocfs2: fix ocfs2 direct io code patch to support sparse 
file and
data ordering semantics" has already include the fix to this bug. 
Yiwen's patch
is no longer needed if my patchset is accepted.
