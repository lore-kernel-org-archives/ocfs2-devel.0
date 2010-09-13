From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 13 Sep 2010 10:54:23 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2/dlm: dynamically allocate lvb
 for dlm_lock_resource
In-Reply-To: <201008261310.o7PGMqsi009165@acsinet15.oracle.com>
References: <201008261310.o7PGMqsi009165@acsinet15.oracle.com>
Message-ID: <4C8E654F.4050503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 08/26/2010 06:06 AM, Wengang Wang wrote:
> This patch tries to dynamically allocate lvb for dlm_lock_resource which needs to access lvb.
>
> Without the patch applied,
> [wwg at cool linux-2.6]$ egrep "o2dlm_lockres" /proc/slabinfo
> o2dlm_lockres         42     42    256   32    2 : tunables    0    0    0 : slabdata      2      2      0
>
> After patch applied,
> [wwg at cool linux-2.6]$ egrep "o2dlm_lockres" /proc/slabinfo
> o2dlm_lockres         42     42    192   21    1 : tunables    0    0    0 : slabdata      2      2      0
>
> #the result is taken on i686
>    

So the core logic allocates a lvb or not based on the lock name. That
will not work because we support userdlm (not to be confused with
userspace stack that uses fsdlm) that allows the user to specify the name.

A better solution is to make the user pass in a flag to create the lvb.
That's one issue.

The other issue concerns the real savings. While the savings on a per
lockres basis are impressive (will be even more on a 64-bit system), I
am unsure on the overall savings.

To check that, run some workload... like a kernel build (one node should
be sufficient) and gather some numbers below.

# cd /sys/kernel/debug/o2dlm/<domain>
# grep -h "^NAME:" locking_state | sort | cut -c6 | uniq -c

Marcos, Can you also gather this stat when you run metadata heavy
tests.

Thanks
Sunil
