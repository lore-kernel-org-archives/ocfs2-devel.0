From: MARCOS MATSUNAGA <marcos.matsunaga@oracle.com>
Date: Mon, 13 Sep 2010 23:48:43 -0400
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2/dlm: dynamically allocate lvb
 for dlm_lock_resource
In-Reply-To: <4C8E654F.4050503@oracle.com>
References: <201008261310.o7PGMqsi009165@acsinet15.oracle.com>
	<4C8E654F.4050503@oracle.com>
Message-ID: <4C8EF09B.2000100@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Sunil,

I ran buildkernel and collect some of the stats that you requested.

You can find them at http://oss.oracle.com/~mmatsuna/ocfs2-stats/ and 
the files are:
ocfs2-stat-6850.log 
<http://oss.oracle.com/%7Emmatsuna/ocfs2-stats/ocfs2-stat-6850.log>

ocfs2-stat-6942.log  <http://oss.oracle.com/%7Emmatsuna/ocfs2-stats/ocfs2-stat-6942.log>
ocfs2-stat-10059.log  <http://oss.oracle.com/%7Emmatsuna/ocfs2-stats/ocfs2-stat-10059.log>
ocfs2-stat-32460.log  <http://oss.oracle.com/%7Emmatsuna/ocfs2-stats/ocfs2-stat-32460.log>


I collected samples every 30 seconds on all nodes. Each node starts two 
builds in parallel and the make command is "make -j2 V=1".

On 9/13/2010 1:54 PM, Sunil Mushran wrote:
> On 08/26/2010 06:06 AM, Wengang Wang wrote:
>> This patch tries to dynamically allocate lvb for dlm_lock_resource which needs to access lvb.
>>
>> Without the patch applied,
>> [wwg at cool linux-2.6]$ egrep "o2dlm_lockres" /proc/slabinfo
>> o2dlm_lockres         42     42    256   32    2 : tunables    0    0    0 : slabdata      2      2      0
>>
>> After patch applied,
>> [wwg at cool linux-2.6]$ egrep "o2dlm_lockres" /proc/slabinfo
>> o2dlm_lockres         42     42    192   21    1 : tunables    0    0    0 : slabdata      2      2      0
>>
>> #the result is taken on i686
>>
> So the core logic allocates a lvb or not based on the lock name. That
> will not work because we support userdlm (not to be confused with
> userspace stack that uses fsdlm) that allows the user to specify the name.
>
> A better solution is to make the user pass in a flag to create the lvb.
> That's one issue.
>
> The other issue concerns the real savings. While the savings on a per
> lockres basis are impressive (will be even more on a 64-bit system), I
> am unsure on the overall savings.
>
> To check that, run some workload... like a kernel build (one node should
> be sufficient) and gather some numbers below.
>
> # cd /sys/kernel/debug/o2dlm/<domain>
> # grep -h "^NAME:" locking_state | sort | cut -c6 | uniq -c
>
> Marcos, Can you also gather this stat when you run metadata heavy
> tests.
>
> Thanks
> Sunil
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100913/f6861dd3/attachment.html 
