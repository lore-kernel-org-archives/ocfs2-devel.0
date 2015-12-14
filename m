From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 14 Dec 2015 23:07:42 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix recursive locking deadlock
In-Reply-To: <20151214085701.GB7837@desktop.lab.bej.apac.novell.com>
References: <1450058259-30682-1-git-send-email-junxiao.bi@oracle.com>
	<566EC6A8020000F90002219D@relay2.provo.novell.com>
	<566E5BA5.5030308@oracle.com>
	<20151214085701.GB7837@desktop.lab.bej.apac.novell.com>
Message-ID: <CF112FCC-8F5B-4F88-A4FC-663B5C40AD90@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


> ? 2015?12?14????4:57?Eric Ren <zren@suse.com> ???
> 
> Hi,
> 
> On Mon, Dec 14, 2015 at 02:03:17PM +0800, Junxiao Bi wrote: 
>> On 12/14/2015 01:39 PM, Gang He wrote:
>>> Hello Junxiao,
>>> 
>>> From the initial description, the second lock_XYZ(PR) should be blocked, since DLM have a fair queue  mechanism, otherwise, it looks to bring a write lock starvation.
>> Should be blocked? No, that is a deadlock. I don't think this recursive
>> locking is common, so no need care starvation here.
> "not common" is really good news. I think we should list recursive use
> cases first
I have said in pervious mail, this way is simple for developer, it is usually hard to find the recursive use case before see the deadlock call trace.
> and try to decrease that use before messing up "__ocfs2_cluster_lock"
> further.
I don?t see this is a mess up, I think record which processes are using the lockers is very useful. I am going to add a blocker list of lockres. With this, for one process, we can see which locks it is holding, and which lock it is blocked.
This can be exported to debugfs and is useful to debug deadlock issue.

> As for this patch,  cost is too high :/
I don?t think so. The list will not be long, and searching on it will be very fast. Also please keep in mind, ocfs2_cluster_lock/unlock itself is never the bottle neck of the performance, when you get a high delay for locking, that is because io triggered by down convert on other nodes or lock race hurt the performance, a list search is just a cpu op, it is much faster than io. I don?t see it can hurt performance.

Thanks,
Junxiao.
> 
> Thanks,
> Eric
>> 
>>> Second, this issue can be reproduced in old Linux kernels (e.g. 3.16.7-24)? there should not be any regression issue? 
>> Maybe just hard to reproduce, ocfs2 supports recursive locking.
>> 
>>> Finally, really do not like nested using lock, can we avoid this.
>> I didn't see a good reason why this should be avoided. Without this,
>> developer needs pay more attend to not involve recursive locking,
>> usually that is very hard before run a full test or a very detailed review.
>> 
>> Thanks,
>> Junxiao.
>>> 
>>> Thanks
>>> Gang
>>> 
>>> 
>> 
>> 
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com <mailto:Ocfs2-devel@oss.oracle.com>
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20151214/6ce7afe8/attachment-0001.html 
