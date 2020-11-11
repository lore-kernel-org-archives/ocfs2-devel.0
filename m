From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 10 Nov 2020 16:55:57 -0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: initialize ip_next_orphan
In-Reply-To: <20201110130433.a891a2c79e96c0815079a199@linux-foundation.org>
References: <20201109171746.27884-1-wen.gang.wang@oracle.com>
	<a7851471-9897-b1a9-fc47-0fa9821764fb@linux.alibaba.com>
	<d4ebfc4e-1e4a-11c2-1020-376c6b5886b3@oracle.com>
	<20201110130433.a891a2c79e96c0815079a199@linux-foundation.org>
Message-ID: <a14df5cd-df2c-7a3c-30cd-67e90773ca06@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 11/10/20 1:04 PM, Andrew Morton wrote:
> On Mon, 9 Nov 2020 17:56:41 -0800 Wengang Wang <wen.gang.wang@oracle.com> wrote:
>
>>>> Looking at more on ip_next_orphan, I found it's not initialized when
>>>> allocating a new ocfs2_inode_info structure.
>>>>
>>>> Fix:
>>>>  ????initialize ip_next_orphan as NULL.
>>>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Thank you Joseph!
>>
>> AKPM, could you please pull this patch to your tree?
> I'm trying to figure out whether we should add cc:stable to this.  But
> to know that, I need to know the end-user visible effects of the bug,
> and that isn't described in this changelog (it should have been!).
>
> Please describe this?

The observed end-user visible effects is that:

The reflink operations from some nodes hang for very long time waiting 
for the cluster lock on the orphan directory.

So yes, we should add cc:stable. Sorry, I missed that part.

Thanks,
Wengang
